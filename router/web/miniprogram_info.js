const express = require('express');
const router = express.Router();
const querySql = require("../../utils/query.js");

// 查询小程序信息列表
router.get("/get_miniprogram_list", async (req, res) => {
	try {
		const { pageNumber = 1, pageSize = 10, status, name, is_ad } = req.query;
		
		let sql = `SELECT 
			id, appid, app_secret, advertiser_id, name, description, status,
			bananer_ad_id, jili_ad_id, chaping_ad_id, ad_template_list,
			is_ad, create_time, update_time 
			FROM miniprogram_info WHERE 1=1`;
		let countSql = 'SELECT COUNT(*) as total FROM miniprogram_info WHERE 1=1';
		let params = [];

		// 状态筛选
		if (status !== undefined && status !== '') {
			sql += ' AND status = ?';
			countSql += ' AND status = ?';
			params.push(status);
		}

		// 广告状态筛选
		if (is_ad !== undefined && is_ad !== '') {
			sql += ' AND is_ad = ?';
			countSql += ' AND is_ad = ?';
			params.push(is_ad);
		}

		// 名称搜索
		if (name) {
			sql += ' AND name LIKE ?';
			countSql += ' AND name LIKE ?';
			params.push(`%${name}%`);
		}

		// 分页
		const offset = (pageNumber - 1) * pageSize;
		sql += ' ORDER BY create_time DESC LIMIT ? OFFSET ?';
		params.push(Number(pageSize), Number(offset));

		// 执行查询
		const [list, totalResult] = await Promise.all([
			querySql(sql, params),
			querySql(countSql, params.slice(0, -2))
		]);

		// 处理 ad_template_list 字段

		const formattedList = list.map(item => ({
			...item,
			ad_template_list: item.ad_template_list ? JSON.parse(item.ad_template_list) : null
		}));
		console.log(formattedList);

		res.send({
			code: 200,
			msg: '查询成功',
			data: formattedList,
			total: totalResult[0].total
		});

	} catch (error) {
		console.error('查询小程序列表失败:', error);
		res.send({
			code: 500,
			msg: '查询失败',
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
			id, appid, app_secret, advertiser_id, name, description, status,
			bananer_ad_id, jili_ad_id, chaping_ad_id, ad_template_list,
			create_time, update_time 
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

		// 处理 ad_template_list 字段
		const formattedDetail = {
			...detail,
			ad_template_list: detail.ad_template_list ? JSON.parse(detail.ad_template_list) : null
		};

		res.send({
			code: 200,
			msg: '查询成功',
			data: formattedDetail
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

// 新增小程序信息
router.post("/add_miniprogram", async (req, res) => {
	try {
		const {
			appid,
			app_secret,
			advertiser_id,
			name,
			description,
			status = 1,
			bananer_ad_id,
			jili_ad_id,
			chaping_ad_id,
			ad_template_list,
			is_ad
		} = req.body;

		// 参数校验
		if (!appid || !app_secret || !name) {
			return res.send({
				code: 400,
				msg: '缺少必要参数',
				data: null
			});
		}

		// 检查appid是否已存在
		const [exist] = await querySql(
			'SELECT 1 FROM miniprogram_info WHERE appid = ?',
			[appid]
		);

		if (exist) {
			return res.send({
				code: 400,
				msg: '该AppID已存在',
				data: null
			});
		}

		// 插入数据
		const result = await querySql(
			`INSERT INTO miniprogram_info 
			(appid, app_secret, advertiser_id, name, description, status, 
			bananer_ad_id, jili_ad_id, chaping_ad_id, ad_template_list, is_ad) 
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
			[
				appid, 
				app_secret, 
				advertiser_id || "", 
				name || "", 
				description || "", 
				status,
				bananer_ad_id || "", 
				jili_ad_id || "", 
				chaping_ad_id || "", 
				ad_template_list ? JSON.stringify(ad_template_list) : null,
				is_ad || 0
			]
		);
		res.send({
			code: 200,
			msg: '添加成功',
			data: {
				id: result.insertId
			}
		});
	} catch (error) {
		console.error('添加小程序信息失败:', error);
		res.send({
			code: 500,
			msg: '添加失败',
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
			advertiser_id,
			name,
			description,
			status,
			bananer_ad_id,
			jili_ad_id,
			chaping_ad_id,
			ad_template_list,
			is_ad
		} = req.body;

		console.log(req.body);

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
		if (advertiser_id !== undefined) {
			updateFields.push('advertiser_id = ?');
			updateValues.push(advertiser_id);
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
		if (bananer_ad_id !== undefined) {
			updateFields.push('bananer_ad_id = ?');
			updateValues.push(bananer_ad_id);
		}
		if (jili_ad_id !== undefined) {
			updateFields.push('jili_ad_id = ?');
			updateValues.push(jili_ad_id);
		}
		if (chaping_ad_id !== undefined) {
			updateFields.push('chaping_ad_id = ?');
			updateValues.push(chaping_ad_id);
		}
		if (ad_template_list !== undefined) {
			updateFields.push('ad_template_list = ?');
			updateValues.push(JSON.stringify(ad_template_list));
		}
		if (is_ad !== undefined) {
			updateFields.push('is_ad = ?');
			updateValues.push(is_ad);
		}

		// 添加更新时间
		updateFields.push('update_time = ?');
		updateValues.push(new Date());

		// 添加ID到参数数组
		updateValues.push(id);

		// 执行更新
		await querySql(
			`UPDATE miniprogram_info SET ${updateFields.join(', ')} WHERE id = ?`,
			updateValues
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