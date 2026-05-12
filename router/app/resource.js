const express = require('express');
const router = express.Router();
const querySql = require("../../utils/query.js");


// 获取资料分类列表
router.get("/get_category_list", async (req, res) => {
    try {
        // 处理前端传来的 params 对象参数
        const params = req.query.params || req.query;
        const pageNumber = parseInt(params.pageNumber) || 1;
        const pageSize = parseInt(params.pageSize) || 10;
        const status = params.status !== undefined ? parseInt(params.status) : 1;
        const { name, appid } = params;

        console.log('查询参数:', { pageNumber, pageSize, status, name, appid }); // 添加日志

        let sql = `SELECT 
            id, name, status, count, appids, sort_order, sort_field, 
            description, create_time, update_time 
            FROM material_category WHERE 1=1`;
        let countSql = 'SELECT COUNT(*) as total FROM material_category WHERE 1=1';
        let queryParams = [];

        // 构建查询条件
        if (status !== undefined) {
            sql += ' AND status = ?';
            countSql += ' AND status = ?';
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


// 获取二级分类列表
router.get('/get_subcategory_list', async (req, res) => {
    try {
        const params = req.query.params || req.query;
        const pageNumber = parseInt(params.pageNumber) || 1;
        const pageSize = parseInt(params.pageSize) || 10;
        const status = params.status !== undefined ? parseInt(params.status) : 1;
        const { name, category_id } = params;
        let sql = `SELECT id, category_id, name, status, sort_order, description, create_time, update_time FROM material_subcategory WHERE 1=1`;
        let countSql = 'SELECT COUNT(*) as total FROM material_subcategory WHERE 1=1';
        let queryParams = [];
        if (status !== undefined) { sql += ' AND status = ?'; countSql += ' AND status = ?'; queryParams.push(status); }
        if (category_id) { sql += ' AND category_id = ?'; countSql += ' AND category_id = ?'; queryParams.push(category_id); }
        if (name) { sql += ' AND name LIKE ?'; countSql += ' AND name LIKE ?'; queryParams.push(`%${name}%`); }
        sql += ' ORDER BY sort_order DESC, create_time DESC';
        sql += ' LIMIT ? OFFSET ?';
        const offset = (pageNumber - 1) * pageSize;
        queryParams.push(parseInt(pageSize), offset);
        const [list, totalResult] = await Promise.all([
            querySql(sql, queryParams),
            querySql(countSql, queryParams.slice(0, -2))
        ]);
        res.send({
            code: 200,
            msg: '查询成功',
            data: list,
            total: totalResult[0].total,
            pageNumber,
            pageSize
        });
    } catch (error) {
        res.send({ code: 500, msg: error.message || '查询失败', error: error.message });
    }
});

// 获取资料列表
router.post("/get_material_list", async (req, res) => {
    try {
        const {
            pageNumber = 1,
            pageSize = 10,
            status = 1,
            category_id,
            sub_category_id,
            title,
            tags,
            sort = 'sort_time' // 排序字段：sort_time, view_count, favorite_count, like_count
        } = req.query;

        let sql = `
			SELECT 
				m.*,
				c.name as category_name,
				c.appids as category_appids
			FROM material_info m
			LEFT JOIN material_category c ON m.category_id = c.id
			WHERE 1=1
		`;
        let countSql = 'SELECT COUNT(*) as total FROM material_info m WHERE 1=1';
        let params = [];

        // 构建查询条件
        if (status !== undefined) {
            sql += ' AND m.status = ?';
            countSql += ' AND m.status = ?';
            params.push(status);
        }

        if (category_id) {
            sql += ' AND m.category_id = ?';
            countSql += ' AND m.category_id = ?';
            params.push(category_id);
        }

        // 精确判断sub_category_id，只在为有效数字且大于0时才加条件
        if (sub_category_id !== undefined && sub_category_id !== null && sub_category_id !== '' && !isNaN(Number(sub_category_id)) && Number(sub_category_id) > 0) {
            sql += ' AND m.sub_category_id = ?';
            countSql += ' AND m.sub_category_id = ?';
            params.push(Number(sub_category_id));
        }

        if (title) {
            sql += ' AND m.title LIKE ?';
            countSql += ' AND m.title LIKE ?';
            params.push(`%${title}%`);
        }

        if (tags) {
            sql += ' AND m.tags LIKE ?';
            countSql += ' AND m.tags LIKE ?';
            params.push(`%${tags}%`);
        }

        // 添加排序
        switch (sort) {
            case 'view_count':
                sql += ' ORDER BY m.view_count DESC';
                break;
            case 'favorite_count':
                sql += ' ORDER BY m.favorite_count DESC';
                break;
            case 'like_count':
                sql += ' ORDER BY m.like_count DESC';
                break;
            default:
                sql += ' ORDER BY m.sort_time DESC';
        }
        sql += ', m.create_time DESC';

        // 添加分页
        sql += ' LIMIT ? OFFSET ?';
        const offset = (pageNumber - 1) * pageSize;
        params.push(parseInt(pageSize), offset);

        // 执行查询
        const [list, totalResult] = await Promise.all([
            querySql(sql, params),
            querySql(countSql, params.slice(0, -2))
        ]);

        // 处理返回数据
        const processedList = list.map(item => ({
            ...item,
            category_appids: item.category_appids ? JSON.parse(item.category_appids) : [],
            extra_data: item.extra_data ? JSON.parse(item.extra_data) : null
        }));

        res.send({
            code: 200,
            msg: '查询成功',
            data: processedList,
            total: totalResult[0].total,
            pageNumber: parseInt(pageNumber),
            pageSize: parseInt(pageSize)
        });

    } catch (error) {
        console.error('查询资料列表失败:', error);
        res.send({
            code: 500,
            msg: '查询失败',
            error: error.message
        });
    }
});


// 获取资料详情
router.get("/get_material_detail", async (req, res) => {
    try {
        const { id } = req.query;

        if (!id) {
            return res.send({
                code: 400,
                msg: '参数错误：资料ID不能为空',
                data: null
            });
        }

        // 查询资料详情
        const sql = `
			SELECT 
				m.*,
				c.name as category_name,
				c.appids as category_appids
			FROM material_info m
			LEFT JOIN material_category c ON m.category_id = c.id
			WHERE m.id = ?
		`;

        const [detail] = await querySql(sql, [id]);

        if (!detail) {
            return res.send({
                code: 404,
                msg: '资料不存在',
                data: null
            });
        }

        // 更新浏览量
        await querySql(
            'UPDATE material_info SET view_count = view_count + 1 WHERE id = ?',
            [id]
        );

        // 处理JSON字段
        detail.category_appids = detail.category_appids ? JSON.parse(detail.category_appids) : [];
        detail.extra_data = detail.extra_data ? JSON.parse(detail.extra_data) : null;

        res.send({
            code: 200,
            msg: '查询成功',
            data: detail
        });

    } catch (error) {
        console.error('查询资料详情失败:', error);
        res.send({
            code: 500,
            msg: '查询失败',
            error: error.message
        });
    }
});

// 简单版资料列表查询接口：仅支持分页、sub_category_id、status
router.get('/get_material_list_simple', async (req, res) => {
    try {
        const {
            pageNumber = 1,
            pageSize = 10,
            sub_category_id,
            status = 1
        } = req.query;

        let sql = `SELECT * FROM material_info WHERE 1=1`;
        let countSql = 'SELECT COUNT(*) as total FROM material_info WHERE 1=1';
        let params = [];

        // status条件
        if (status !== undefined && status !== null && status !== '' && !isNaN(Number(status))) {
            sql += ' AND status = ?';
            countSql += ' AND status = ?';
            params.push(Number(status));
        }
        // sub_category_id条件
        if (sub_category_id !== undefined && sub_category_id !== null && sub_category_id !== '' && !isNaN(Number(sub_category_id)) && Number(sub_category_id) > 0) {
            sql += ' AND sub_category_id = ?';
            countSql += ' AND sub_category_id = ?';
            params.push(Number(sub_category_id));
        }
        // 分页
        sql += ' ORDER BY sort_time DESC, create_time DESC LIMIT ? OFFSET ?';
        const offset = (pageNumber - 1) * pageSize;
        params.push(parseInt(pageSize), offset);

        // 查询
        const [list, totalResult] = await Promise.all([
            querySql(sql, params),
            querySql(countSql, params.slice(0, -2))
        ]);

        res.send({
            code: 200,
            msg: '查询成功',
            data: list,
            total: totalResult[0].total,
            pageNumber: parseInt(pageNumber),
            pageSize: parseInt(pageSize)
        });
    } catch (error) {
        res.send({
            code: 500,
            msg: '查询失败',
            error: error.message
        });
    }
});

// 用户收藏资料
router.post('/addMaterialFavorite', async (req, res) => {
    try {
        const openid = req.headers['x-wx-openid'];
        const { material_id, category_id, sub_category_id, title, cover_image, tags } = req.body;
        let category_time = new Date();

        if (!openid) {
            return res.status(401).send({ code: 401, msg: "未携带身份凭证" });
        }
        if (!material_id) {
            return res.status(400).send({ code: 400, msg: "请提供资料ID" });
        }

        // --- 1. 修改：使用 SELECT 检查是否已经收藏过 ---
        const existingFavorite = await querySql(
            `SELECT id FROM material_user_collection_list WHERE user_id = ? AND material_id = ?`,
            [openid, material_id]
        );

        if (existingFavorite.length > 0) {
            return res.send({
                code: 200, // 或者 200，取决于前端逻辑
                msg: "资料已收藏，请勿重复操作"
            });
        }

        // --- 2. 执行真正的插入操作 ---
        // 确保所有 NOT NULL 的字段都在这里传入
        await querySql(
            `INSERT INTO material_user_collection_list 
            (user_id, material_id, category_id, sub_category_id, title, cover_image, category_time, tags, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                openid,
                material_id,
                category_id || 0, // 增加防空处理
                sub_category_id || 0,
                title || '',
                cover_image || '',
                category_time,
                tags ? JSON.stringify(tags) : null, // 如果 tags 是对象，建议转成字符串
                1
            ]
        );

        res.send({ code: 200, msg: "收藏成功" });

    } catch (error) {
        console.error('收藏失败详情:', error);
        res.status(500).send({
            code: 500,
            msg: '服务器错误',
            error: error.message
        });
    }
});

// 用户取消收藏资料
router.post('/removeMaterialFavorite', async (req, res) => {

    const openid = req.headers['x-wx-openid'];
    const { material_id } = req.body;
    if (!openid) {
        return res.status(401).send({ code: 401, msg: "未携带身份凭证" });
    }
    if (!material_id) {
        return res.status(400).send({ code: 400, msg: "请提供资料ID" });
    }
    const result = await querySql(
        `DELETE FROM material_user_collection_list WHERE user_id = ? AND material_id = ?`,
        [openid, material_id]
    );
    if (result) {
        res.send({ code: 200, msg: "取消收藏成功" });
    } else {
        res.send({ code: 400, msg: "取消收藏失败" });
    }
});


/**
 * 查询资料是否被当前用户收藏
 * 请求参数: material_id - 资料ID
 * 返回: { collected: true/false, material_id: 资料ID }
 */
router.post('/checkMaterialFavorite', async (req, res) => {
    try {
        // 获取用户身份和图片参数
        const openid = req.headers['x-wx-openid'];
        const { material_id } = req.body;

        // 参数校验
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }

        if (!material_id) {
            return res.status(400).send({
                code: 400,
                msg: "请提供资料ID"
            });
        }

        // 查询收藏状态 AND status = 1
        const [result] = await querySql(
            `SELECT 1 FROM material_user_collection_list 
             WHERE user_id = ? AND material_id = ?
             LIMIT 1`,
            [openid, material_id]
        );

        // 返回收藏状态
        res.send({
            code: 200,
            collected: !!result, // 转换为布尔值
            material_id: material_id,
            msg: "查询成功"
        });

    } catch (error) {
        console.error(`[${formatDateTime()}] 查询收藏状态失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

// 查询用户收藏资料列表
router.post('/getUserMaterialFavoriteList', async (req, res) => {
    try {
        const openid = req.headers['x-wx-openid'];
        const { pageNumber = 1, pageSize = 10 } = req.body;
        if (!openid) {
            return res.status(401).send({ code: 401, msg: "未携带身份凭证" });
        }
        const offset = (pageNumber - 1) * pageSize;
        const [list, totalResult] = await Promise.all([
            querySql(
                `SELECT * FROM material_user_collection_list WHERE user_id = ? AND status = 1 ORDER BY category_time DESC LIMIT ? OFFSET ?`,
                [openid, parseInt(pageSize), offset]
            ),
            querySql(
                `SELECT COUNT(*) as total FROM material_user_collection_list WHERE user_id = ? AND status = 1`,
                [openid]
            )
        ]);
        res.send({ code: 200, msg: '查询成功', data: list, total: totalResult[0].total, pageNumber: parseInt(pageNumber), pageSize: parseInt(pageSize), totalPages: Math.ceil(totalResult[0].total / parseInt(pageSize)) });
    } catch (error) {
        console.error('查询用户收藏资料列表失败:', error);
        res.status(500).send({
            code: 500,
            msg: '服务器内部错误'
        });
    }
});


module.exports = router;