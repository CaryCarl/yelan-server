const express = require('express');
const router = express.Router();
const utils = require("../../utils/index.js");
const pools = require("../../utils/pools.js");
const axios = require('axios');
const querySql = require("../../utils/query.js");
const { formatDateTime } = require("../../utils/formatDateTime.js");

/**
 * 后台管理 - 云存储配置列表查询
 */
router.post('/getCloudConfigList', async (req, res) => {
	try {
		const {
			pageNumber = 1,
			pageSize = 20,
			appid,
			operator,
			config_type,
			status
		} = req.body;

		let sql = `SELECT * FROM cloud_config WHERE 1=1`;
		let countSql = `SELECT COUNT(*) as total FROM cloud_config WHERE 1=1`;
		let params = [];
		let countParams = [];

		if (appid) {
			sql += ` AND appid = ?`;
			countSql += ` AND appid = ?`;
			params.push(appid);
			countParams.push(appid);
		}

		if (operator) {
			sql += ` AND operator = ?`;
			countSql += ` AND operator = ?`;
			params.push(operator);
			countParams.push(operator);
		}

		if (config_type) {
			sql += ` AND config_type = ?`;
			countSql += ` AND config_type = ?`;
			params.push(config_type);
			countParams.push(config_type);
		}

		if (status !== undefined && status !== null && status !== '') {
			sql += ` AND status = ?`;
			countSql += ` AND status = ?`;
			params.push(status);
			countParams.push(status);
		}

		// 获取总记录数
		const [countResult] = await querySql(countSql, countParams);
		const total = countResult.total || 0;

		if (total === 0) {
			return res.send({
				code: 200,
				data: [],
				total: 0,
				pageNumber,
				pageSize,
				msg: "查询成功"
			});
		}

		// 排序和分页
		sql += ` ORDER BY id DESC LIMIT ? OFFSET ?`;
		const offset = (pageNumber - 1) * pageSize;
		params.push(Number(pageSize), Number(offset));

		const result = await querySql(sql, params);

		// 转换为驼峰命名
		const formattedResult = result.map(item => utils.toCamelCase(item));

		res.send({
			code: 200,
			data: formattedResult,
			total,
			pageNumber: Number(pageNumber),
			pageSize: Number(pageSize),
			msg: "查询成功"
		});

	} catch (error) {
		console.error(`[${formatDateTime()}] 查询云存储配置列表失败:`, error);
		res.status(500).send({ code: 500, msg: "服务器内部错误" });
	}
});

/**
 * 后台管理 - 添加云存储配置
 */
router.post('/addCloudConfig', async (req, res) => {
	try {
		const {
			appid,
			operator,
			config_type,
			secret_id,
			secret_key,
			region,
			bucket,
			status = 1,
			remark,
			extend_field1,
			extend_field2,
			extend_field3,
			extend_field4,
			extend_json
		} = req.body;

		// 参数校验
		if (!operator || !config_type) {
			return res.status(400).send({ code: 400, msg: "运营商和配置类型不能为空" });
		}

		const { result } = await pools({
			sql: `INSERT INTO cloud_config 
				(appid, operator, config_type, secret_id, secret_key, region, bucket, status, remark, 
				extend_field1, extend_field2, extend_field3, extend_field4, extend_json)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
			val: [appid, operator, config_type, secret_id, secret_key, region, bucket, status, remark,
				extend_field1, extend_field2, extend_field3, extend_field4, extend_json ? JSON.stringify(extend_json) : null],
			run: true,
		});

		if (result.insertId) {
			return res.send({
				code: 200,
				msg: "添加成功",
				data: { id: result.insertId }
			});
		}

		return res.status(500).send({ code: 500, msg: "添加失败" });

	} catch (error) {
		console.error(`[${formatDateTime()}] 添加云存储配置失败:`, error);
		res.status(500).send({ code: 500, msg: "服务器内部错误" });
	}
});

/**
 * 后台管理 - 编辑云存储配置
 */
router.post('/editCloudConfig', async (req, res) => {
	try {
		const {
			id,
			appid,
			operator,
			config_type,
			secret_id,
			secret_key,
			region,
			bucket,
			status,
			remark,
			extend_field1,
			extend_field2,
			extend_field3,
			extend_field4,
			extend_json
		} = req.body;

		// 参数校验
		if (!id) {
			return res.status(400).send({ code: 400, msg: "缺少配置ID" });
		}

		if (!operator || !config_type) {
			return res.status(400).send({ code: 400, msg: "运营商和配置类型不能为空" });
		}

		const { result } = await pools({
			sql: `UPDATE cloud_config SET 
				appid = ?, operator = ?, config_type = ?, secret_id = ?, secret_key = ?, 
				region = ?, bucket = ?, status = ?, remark = ?,
				extend_field1 = ?, extend_field2 = ?, extend_field3 = ?, extend_field4 = ?,
				extend_json = ?, update_time = NOW()
				WHERE id = ?`,
			val: [appid, operator, config_type, secret_id, secret_key, region, bucket, status, remark,
				extend_field1, extend_field2, extend_field3, extend_field4,
				extend_json ? JSON.stringify(extend_json) : null, id],
			run: true,
		});

		if (result.affectedRows === 0) {
			return res.status(404).send({ code: 404, msg: "配置不存在" });
		}

		return res.send({ code: 200, msg: "更新成功", data: { id } });

	} catch (error) {
		console.error(`[${formatDateTime()}] 编辑云存储配置失败:`, error);
		res.status(500).send({ code: 500, msg: "服务器内部错误" });
	}
});

/**
 * 后台管理 - 删除云存储配置
 */
router.post('/deleteCloudConfig', async (req, res) => {
	try {
		const { id } = req.body;

		if (!id) {
			return res.status(400).send({ code: 400, msg: "缺少配置ID" });
		}

		const { result } = await pools({
			sql: "DELETE FROM cloud_config WHERE id = ?",
			val: [id],
			run: true,
		});

		if (result.affectedRows === 0) {
			return res.status(404).send({ code: 404, msg: "配置不存在" });
		}

		return res.send({ code: 200, msg: "删除成功", data: { id } });

	} catch (error) {
		console.error(`[${formatDateTime()}] 删除云存储配置失败:`, error);
		res.status(500).send({ code: 500, msg: "服务器内部错误" });
	}
});

/**
 * 后台管理 - 切换云存储配置状态
 */
router.post('/toggleCloudConfigStatus', async (req, res) => {
	try {
		const { id } = req.body;

		if (!id) {
			return res.status(400).send({ code: 400, msg: "缺少配置ID" });
		}

		// 查询当前状态
		const { result: currentConfig } = await pools({
			sql: "SELECT status FROM cloud_config WHERE id = ?",
			val: [id],
			run: true,
		});

		if (!currentConfig || currentConfig.length === 0) {
			return res.status(404).send({ code: 404, msg: "配置不存在" });
		}

		const newStatus = currentConfig[0].status === 1 ? 0 : 1;

		await pools({
			sql: "UPDATE cloud_config SET status = ?, update_time = NOW() WHERE id = ?",
			val: [newStatus, id],
			run: true,
		});

		return res.send({
			code: 200,
			msg: "状态切换成功",
			data: { id, status: newStatus }
		});

	} catch (error) {
		console.error(`[${formatDateTime()}] 切换配置状态失败:`, error);
		res.status(500).send({ code: 500, msg: "服务器内部错误" });
	}
});

module.exports = router;