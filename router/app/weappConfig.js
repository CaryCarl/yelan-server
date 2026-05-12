const express = require('express');
const router = express.Router();
const querySql = require("../../utils/query.js");

// 新增小程序信息
router.post("/add_miniprogram", async (req, res) => {
	try {
		const { appid, app_secret, name, description, status, is_ad, ad_template_list, is_download } = req.body;

		if (!appid || !app_secret || !name) {
			return res.send({
				code: 400,
				msg: '缺少必要参数',
				data: null
			});
		}
        const adTemplateStr = ad_template_list ? JSON.stringify(ad_template_list) : null;
		const sql = `INSERT INTO miniprogram_info (appid, app_secret, name, description, status, is_ad, ad_template_list, is_download) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
		const params = [appid, app_secret, name, description, status, is_ad, adTemplateStr, is_download];
		const result = await querySql(sql, params);
		res.send({
			code: 200,
			msg: '添加小程序成功',
			data: result
		});
	} catch (error) {
		console.error('添加小程序失败:', error);
		res.send({
			code: 500,
			msg: '添加小程序失败',
			error: error.message
		});
	}
});

// 更新小程序信息
router.post("/update_miniprogram", async (req, res) => {
	try {
		const {
			id,
			app_secret,
			name,
			description,
			status,
			is_ad,
			ad_template_list,
            is_download
		} = req.body;

		if (!id) {
			return res.send({
				code: 400,
				msg: '缺少ID参数',
				data: null
			});
		}

		// 检查记录是否存在
		const [exist] = await querySql(
			'SELECT 1 FROM miniprogram_info WHERE id = ?',
			[id]
		);

		if (!exist) {
			return res.send({
				code: 404,
				msg: '未找到对应的小程序信息',
				data: null
			});
		}

		// 构建更新字段
		const updateFields = [];
		const updateValues = [];

		if (app_secret !== undefined) {
			updateFields.push('app_secret = ?');
			updateValues.push(app_secret);
		}
		if (name !== undefined) {
			updateFields.push('name = ?');
			updateValues.push(name);
		}
		if (description !== undefined) {
			updateFields.push('description = ?');
			updateValues.push(description);
		}
		if (status !== undefined) {
			updateFields.push('status = ?');
			updateValues.push(status);
		}
		if (is_ad !== undefined) {
			updateFields.push('is_ad = ?');
			updateValues.push(is_ad);
		}
		if (ad_template_list !== undefined) {
			updateFields.push('ad_template_list = ?');
			updateValues.push(JSON.stringify(ad_template_list));
		}

        if (is_download !== undefined) {
            updateFields.push('is_download = ?');
            updateValues.push(is_download);
        }

		if (updateFields.length === 0) {
			return res.send({
				code: 400,
				msg: '没有要更新的数据',
				data: null
			});
		}

		// 执行更新
		await querySql(
			`UPDATE miniprogram_info SET ${updateFields.join(', ')} WHERE id = ?`,
			[...updateValues, id]
		);

		res.send({
			code: 200,
			msg: '更新成功',
			data: null
		});

	} catch (error) {
		console.error('更新小程序信息失败:', error);
		res.send({
			code: 500,
			msg: '更新失败',
			error: error.message
		});
	}
});

// 查询小程序信息列表
router.get("/get_miniprogram_list", async (req, res) => {
	try {
		const { pageNumber = 1, pageSize = 10, status, name, is_ad } = req.query;
		let sql = `SELECT 
			id, appid, app_secret, name, description, status,is_ad, ad_template_list,
			create_time, update_time ,is_download
			FROM miniprogram_info WHERE 1=1`;
		let countSql = 'SELECT COUNT(*) as total FROM miniprogram_info WHERE 1=1';
		let params = [];
		if (status) {
			sql += ' AND status = ?';
			countSql += ' AND status = ?';
			params.push(status);
		}
		if (name) {
			sql += ' AND name LIKE ?';
			countSql += ' AND name LIKE ?';
			params.push(`%${name}%`);
		}
		if (is_ad) {
			sql += ' AND is_ad = ?';
			countSql += ' AND is_ad = ?';
			params.push(is_ad);
		}
		sql += ' ORDER BY create_time DESC LIMIT ? OFFSET ?';
		countSql += ' ';
		params.push(Number(pageSize), Number(pageNumber - 1) * Number(pageSize));
		const [list, totalResult] = await Promise.all([	
			querySql(sql, params),
			querySql(countSql, params)
		]);
		console.log(list, totalResult);
		res.send({
			code: 200,
			msg: '获取小程序列表成功',
			data: list,
			total: totalResult[0].total
		});
	} catch (error) {
		console.error('获取小程序列表失败:', error);
		res.send({
			code: 500,
			msg: '获取小程序列表失败',
			error: error.message
		});

	}
});

// 获取小程序详情
router.get("/get_miniprogram_detail", async (req, res) => {
	try {
		const { id, appid } = req.query;
		
		if (!id && !appid) {
			return res.send({
				code: 400,
				msg: '缺少查询参数，请提供id或appid',
				data: null
			});
		}

		let sql = `SELECT 
			id, appid, app_secret, name, description, status, is_ad, ad_template_list,
			create_time, update_time ,is_download
			FROM miniprogram_info WHERE 1=1`;
		let params = [];

		if (id) {
			sql += ' AND id = ?';
			params.push(id);
		}
		if (appid) {
			sql += ' AND appid = ?';
			params.push(appid);
		}

		const [detail] = await querySql(sql, params);

		if (!detail) {
			return res.send({
				code: 404,
				msg: '未找到对应的小程序信息',
				data: null
			});
		}

		res.send({
			code: 200,
			msg: '查询成功',
			data: detail
		});

	} catch (error) {
		console.error('查询小程序详情失败:', error);
		res.send({
			code: 500,
			msg: '查询失败',
			error: error.message
		});
	}
});


// 删除小程序信息
router.post("/delete_miniprogram", async (req, res) => {
	try {
		const { id } = req.body;

		if (!id) {
			return res.send({
				code: 400,
				msg: '缺少ID参数',
				data: null
			});
		}

		// 检查记录是否存在
		const [exist] = await querySql(
			'SELECT 1 FROM miniprogram_info WHERE id = ?',
			[id]
		);

		if (!exist) {
			return res.send({
				code: 404,
				msg: '未找到对应的小程序信息',
				data: null
			});
		}

		// 执行删除
		await querySql(
			'DELETE FROM miniprogram_info WHERE id = ?',
			[id]
		);

		res.send({
			code: 200,
			msg: '删除成功',
			data: null
		});

	} catch (error) {
		console.error('删除小程序信息失败:', error);
		res.send({
			code: 500,
			msg: '删除失败',
			error: error.message
		});
	}
});


module.exports = router;