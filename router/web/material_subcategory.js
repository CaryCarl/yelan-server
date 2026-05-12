const express = require('express');
const router = express.Router();
const querySql = require('../../utils/query.js');

const pools = require("../../utils/pools.js");

// 新增二级分类
router.post('/add_subcategory', async (req, res) => {
    try {
        const { category_id, name, sort_order = 0, description } = req.body;
        if (!category_id || !name) {
            return res.send({ code: 400, msg: '参数错误：一级分类ID和二级分类名称不能为空', data: null });
        }
        // 检查一级分类是否存在
        const catCheck = await querySql('SELECT id FROM material_category WHERE id = ? AND status = 1', [category_id]);
        if (catCheck.length === 0) {
            return res.send({ code: 400, msg: '一级分类不存在', data: null });
        }
        // 检查同分类下名称是否重复
        const existCheck = await querySql('SELECT id FROM material_subcategory WHERE name = ? AND category_id = ? AND status = 1', [name, category_id]);
        if (existCheck.length > 0) {
            return res.send({ code: 400, msg: '该分类下二级分类名称已存在', data: null });
        }
        const result = await querySql('INSERT INTO material_subcategory (category_id, name, sort_order, description) VALUES (?, ?, ?, ?)', [category_id, name, sort_order, description]);
        res.send({ code: 200, msg: '添加成功', data: { id: result.insertId } });
    } catch (error) {
        res.send({ code: 500, msg: '添加失败', error: error.message });
    }
});

// 修改二级分类
router.post('/update_subcategory', async (req, res) => {
    try {
        const { id, name, sort_order, description, category_id, status } = req.body;
        if (!id) {
            return res.send({ code: 400, msg: '参数错误：二级分类ID不能为空', data: null });
        }
        // 检查是否存在
        const existCheck = await querySql('SELECT id, category_id FROM material_subcategory WHERE id = ?', [id]);
        if (existCheck.length === 0) {
            return res.send({ code: 404, msg: '二级分类不存在', data: null });
        }
        // 检查同分类下名称是否重复
        if (name) {
            const nameCheck = await querySql('SELECT id FROM material_subcategory WHERE name = ? AND category_id = ? AND id != ?', [name, existCheck[0].category_id, id]);
            if (nameCheck.length > 0) {
                return res.send({ code: 400, msg: '该分类下二级分类名称已存在', data: null });
            }
        }
        let updateFields = [];
        let params = [];
        if (name) { updateFields.push('name = ?'); params.push(name); }
        if (sort_order !== undefined) { updateFields.push('sort_order = ?'); params.push(sort_order); }
        if (description !== undefined) { updateFields.push('description = ?'); params.push(description); }
        if (category_id !== undefined) { updateFields.push('category_id = ?'); params.push(category_id); }
        if (status !== undefined) { updateFields.push('status = ?'); params.push(status); }
        if (updateFields.length === 0) {
            return res.send({ code: 400, msg: '没有需要更新的字段', data: null });
        }
        params.push(id);
        const sql = `UPDATE material_subcategory SET ${updateFields.join(', ')} WHERE id = ?`;
        await querySql(sql, params);
        res.send({ code: 200, msg: '更新成功', data: null });
    } catch (error) {
        res.send({ code: 500, msg: '更新失败', error: error.message });
    }
});

// 删除二级分类
router.post('/delete_subcategory', async (req, res) => {
    try {
		let sql = "DELETE FROM material_subcategory WHERE id = ?";
		let id = req.body.id;

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
		res.status(500).json({
			code: 500,
			message: '操作失败',
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
        const status = params.status;
        const { name, category_id } = params;
        let sql = `SELECT id, category_id, name, status, sort_order, description, create_time, update_time FROM material_subcategory WHERE 1=1`;
        let countSql = 'SELECT COUNT(*) as total FROM material_subcategory WHERE 1=1';
        let queryParams = [];

        if (status !== undefined && status !== null && status !== '') {
            sql += ' AND status = ?'; countSql += ' AND status = ?';
            queryParams.push(status);
        }

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

// 获取二级分类详情
router.get('/get_subcategory_detail', async (req, res) => {
    try {
        const { id } = req.query;
        if (!id) {
            return res.send({ code: 400, msg: '参数错误：二级分类ID不能为空', data: null });
        }
        const sql = `SELECT id, category_id, name, status, sort_order, description, create_time, update_time FROM material_subcategory WHERE id = ?`;
        const [detail] = await querySql(sql, [id]);
        if (!detail) {
            return res.send({ code: 404, msg: '二级分类不存在', data: null });
        }
        res.send({ code: 200, msg: '查询成功', data: detail });
    } catch (error) {
        res.send({ code: 500, msg: '查询失败', error: error.message });
    }
});

module.exports = router; 