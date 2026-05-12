const express = require('express');
const router = express.Router();
const querySql = require("../../utils/query.js");


// 新增资料分类
router.post("/add_category", async (req, res) => {
    try {
        const { name, appids, sort_order = 0, sort_field = 'sort_order', description } = req.body;

        // 参数验证
        if (!name || !appids || !Array.isArray(appids)) {
            return res.send({
                code: 400,
                msg: '参数错误：分类名称和关联小程序不能为空',
                data: null
            });
        }

        // 检查分类名称是否已存在
        const existCheck = await querySql(
            'SELECT id FROM material_category WHERE name = ? AND status = 1',
            [name]
        );

        if (existCheck.length > 0) {
            return res.send({
                code: 400,
                msg: '分类名称已存在',
                data: null
            });
        }

        // 插入数据
        const result = await querySql(
            'INSERT INTO material_category (name, appids, sort_order, sort_field, description) VALUES (?, ?, ?, ?, ?)',
            [name, JSON.stringify(appids), sort_order, sort_field, description]
        );

        res.send({
            code: 200,
            msg: '添加成功',
            data: {
                id: result.insertId
            }
        });

    } catch (error) {
        console.error('添加资料分类失败:', error);
        res.send({
            code: 500,
            msg: '添加失败',
            error: error.message
        });
    }
});

// 修改资料分类
router.post("/update_category", async (req, res) => {
    try {
        // 检查数据库连接
        const checkConnection = await querySql('SELECT 1');
        if (!checkConnection) {
            throw new Error('数据库连接失败');
        }

        const { id, name, appids, sort_order, sort_field, description, status } = req.body;

        // 参数验证
        if (!id) {
            return res.send({
                code: 400,
                msg: '参数错误：分类ID不能为空',
                data: null
            });
        }

        // 验证 appids 格式
        if (appids && !Array.isArray(appids)) {
            return res.send({
                code: 400,
                msg: '参数错误：appids必须是数组格式',
                data: null
            });
        }

        // 检查分类是否存在
        const existCheck = await querySql(
            'SELECT id FROM material_category WHERE id = ?',
            [id]
        ).catch(err => {
            console.error('查询分类失败:', err);
            throw new Error('数据库查询失败');
        });

        if (!existCheck || existCheck.length === 0) {
            return res.send({
                code: 404,
                msg: '分类不存在或已被删除',
                data: null
            });
        }

        // 如果要修改名称，检查新名称是否与其他分类重复
        if (name) {
            const nameCheck = await querySql(
                'SELECT id FROM material_category WHERE name = ? AND id != ?',
                [name, id]
            ).catch(err => {
                console.error('检查名称重复失败:', err);
                throw new Error('数据库查询失败');
            });

            if (nameCheck && nameCheck.length > 0) {
                return res.send({
                    code: 400,
                    msg: '分类名称已存在',
                    data: null
                });
            }
        }

        // 构建更新语句
        let updateFields = [];
        let params = [];

        if (name) {
            updateFields.push('name = ?');
            params.push(name);
        }
        if (appids) {
            updateFields.push('appids = ?');
            params.push(JSON.stringify(appids));
        }
        if (sort_order !== undefined) {
            updateFields.push('sort_order = ?');
            params.push(sort_order);
        }
        if (sort_field) {
            updateFields.push('sort_field = ?');
            params.push(sort_field);
        }
        if (description !== undefined) {
            updateFields.push('description = ?');
            params.push(description);
        }

        if (status !== undefined) {
            updateFields.push('status = ?'); params.push(status);
        }
        if (updateFields.length === 0) {
            return res.send({
                code: 400,
                msg: '没有需要更新的字段',
                data: null
            });
        }

        params.push(id);
        const sql = `UPDATE material_category SET ${updateFields.join(', ')} WHERE id = ?`;

        // 添加超时处理
        const updateResult = await Promise.race([
            querySql(sql, params),
            new Promise((_, reject) =>
                setTimeout(() => reject(new Error('数据库操作超时')), 5000)
            )
        ]).catch(err => {
            console.error('执行更新失败:', err);
            throw new Error(err.message || '数据库更新失败');
        });

        res.send({
            code: 200,
            msg: '更新成功',
            data: null
        });

    } catch (error) {
        console.error('更新资料分类失败:', error);
        res.send({
            code: 500,
            msg: error.message || '更新失败',
            error: error.message
        });
    }
});

// 删除资料分类
router.post("/delete_category", async (req, res) => {
    try {
        const { id } = req.body;

        if (!id) {
            return res.send({
                code: 400,
                msg: '参数错误：分类ID不能为空',
                data: null
            });
        }

        // 检查分类是否存在且未被删除
        const existCheck = await querySql(
            'SELECT id FROM material_category WHERE id = ? AND status = 0',
            [id]
        );

        if (existCheck.length === 0) {
            return res.send({
                code: 404,
                msg: '分类已发布或已被删除',
                data: null
            });
        }
        // 软删除
        let sql = "DELETE FROM material_category WHERE id = ?";
		const result = await pools({
			sql,
			val: [id],
			run: true, // 改为 true 即可实现真实删除
			res,
			req
		});


		res.json({
			code: 200,
			data: result,
			message: '删除成功'
		});


    } catch (error) {
        console.error('删除资料分类失败:', error);
        res.send({
            code: 500,
            msg: '删除失败',
            error: error.message
        });
    }
});

// 获取资料分类列表
router.get("/get_category_list", async (req, res) => {
    try {
        // 处理前端传来的 params 对象参数
        const params = req.query.params || req.query;
        const pageNumber = parseInt(params.pageNumber) || 1;
        const pageSize = parseInt(params.pageSize) || 10;
        const status = params.status;
        const { name, appid } = params;

        console.log('查询参数:', { pageNumber, pageSize, status, name, appid }); // 添加日志

        let sql = `SELECT 
            id, name, status, count, appids, sort_order, sort_field, 
            description, create_time, update_time 
            FROM material_category WHERE 1=1`;
        let countSql = 'SELECT COUNT(*) as total FROM material_category WHERE 1=1';
        let queryParams = [];

        // 构建查询条件
        if (status !== undefined && status !== null && status !== '') {
            sql += ' AND status = ?'; countSql += ' AND status = ?';
            queryParams.push(status);
        }

        if (name) {
            sql += ' AND name LIKE ?';
            countSql += ' AND name LIKE ?';
            queryParams.push(`%${name}%`);
        }

        if (appid) {
            sql += ' AND JSON_CONTAINS(appids, ?)';
            countSql += ' AND JSON_CONTAINS(appids, ?)';
            queryParams.push(`"${appid}"`);
        }

        // 添加排序和分页
        sql += ' ORDER BY sort_order DESC, create_time DESC';
        sql += ' LIMIT ? OFFSET ?';

        const offset = (pageNumber - 1) * pageSize;
        queryParams.push(parseInt(pageSize), offset);

        console.log('SQL语句:', sql); // 添加日志
        console.log('查询参数:', queryParams); // 添加日志

        // 执行查询
        const [list, totalResult] = await Promise.all([
            querySql(sql, queryParams),
            querySql(countSql, queryParams.slice(0, -2))
        ]).catch(err => {
            console.error('数据库查询失败:', err);
            throw new Error('数据库查询失败');
        });

        // 处理返回数据
        const processedList = list.map(item => ({
            ...item,
            appids: item.appids ? JSON.parse(item.appids) : []
        }));

        res.send({
            code: 200,
            msg: '查询成功',
            data: processedList,
            total: totalResult[0].total,
            pageNumber,
            pageSize
        });

    } catch (error) {
        console.error('查询资料分类列表失败:', error);
        res.send({
            code: 500,
            msg: error.message || '查询失败',
            error: error.message
        });
    }
});

// 获取资料分类详情
router.get("/get_category_detail", async (req, res) => {
    try {
        const { id } = req.query;

        if (!id) {
            return res.send({
                code: 400,
                msg: '参数错误：分类ID不能为空',
                data: null
            });
        }

        const sql = `SELECT 
            id, name, status, count, appids, sort_order, sort_field,
            description, create_time, update_time 
            FROM material_category WHERE id = ?`;

        const [detail] = await querySql(sql, [id]);

        if (!detail) {
            return res.send({
                code: 404,
                msg: '分类不存在',
                data: null
            });
        }

        // 处理 appids 字段
        detail.appids = detail.appids ? JSON.parse(detail.appids) : [];

        res.send({
            code: 200,
            msg: '查询成功',
            data: detail
        });

    } catch (error) {
        console.error('查询资料分类详情失败:', error);
        res.send({
            code: 500,
            msg: '查询失败',
            error: error.message
        });
    }
});

module.exports = router;