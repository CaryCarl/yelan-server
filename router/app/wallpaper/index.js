const express = require('express');
const router = express.Router();
const utils = require("../../../utils/index.js");
const pools = require("../../../utils/pools.js");
const querySql = require("../../../utils/query.js");

// 查询图片分类
router.get("/get_image_type", async (req, res) => {
	let obj = req.query;
	let sql = `SELECT * FROM wallpaper_image_categories WHERE 1=1`;
	let countSql = `SELECT COUNT(*) as total FROM wallpaper_image_categories WHERE 1=1`;
	let params = [];
	let countParams = [];

	if (obj?.name) {
		sql = utils.setLike(sql, "name", obj.name);
		countSql = utils.setLike(countSql, "name", obj.name);
	}
	if (obj.status !== undefined && obj.status !== null && obj.status !== '') {
		sql += ' AND status = ?';
		countSql += ' AND status = ?';
		params.push(obj.status);
		countParams.push(obj.status);
	}

	let { result } = await pools({ sql, val: params, res, req });
	let countResult = await pools({ sql: countSql, val: countParams, res, req });
	let total = countResult?.result[0]?.total || 0;
	const camelCaseResult = result.map(utils.toCamelCase);
	res.send(utils.returnData({ data: camelCaseResult, total }));
});

// 查询图片标签
router.get("/get_image_tags", async (req, res) => {
	try {
		const { status } = req.query;
		let sql = `SELECT * FROM wallpaper_image_tags WHERE 1=1`;
		let params = [];

		if (status !== undefined && status !== null && status !== '') {
			sql += ' AND status = ?';
			params.push(status);
		}

		sql += ' ORDER BY id DESC';

		const { result } = await pools({ sql, val: params });
		const camelCaseResult = result.map(item => utils.toCamelCase(item));

		res.json({
			code: 200,
			data: camelCaseResult,
			message: '查询成功'
		});

	} catch (error) {
		console.error('查询图片标签失败:', error);
		res.status(500).json({
			code: 500,
			message: '服务器内部错误'
		});
	}
});

// 查询用户收藏分组
router.post('/getUserCollections', async (req, res) => {
	try {
		const openid = req.headers['x-wx-openid'];
		const {
			pageNumber = 1, pageSize = 1000
		} = req.body;

		// 参数校验 
		if (!openid) return res.status(401).send({
			code: 4011,
			msg: "身份凭证缺失"
		});
		if (isNaN(pageNumber) || isNaN(pageSize)) {
			return res.status(400).send({
				code: 4005,
				msg: "分页参数格式错误"
			});
		}

		const offset = (pageNumber - 1) * pageSize;

		// 步骤1：获取用户收藏的group_id列表 
		const [collectionIds, totalResult] = await Promise.all([
			querySql(`
        SELECT group_id 
        FROM wallpaper_user_collections 
        WHERE user_id = ?
        LIMIT ? OFFSET ?
      `, [openid, Number(pageSize), Number(offset)]),

			querySql(`
        SELECT COUNT(*) AS total 
        FROM wallpaper_user_collections 
        WHERE user_id = ?
      `, [openid])
		]);

		// 处理无收藏数据情况 
		if (collectionIds.length === 0) {
			return res.send({
				code: 200,
				data: [],
				total: 0
			});
		}

		// 步骤2：查询分组详细信息 
		const groupList = await querySql(`
		  SELECT 
		    id, category_id, category_name,
		    title, cover_image,
		    images_url,  -- 直接读取json类型字段 
		    create_time,
		    featured,
		    status 
		  FROM wallpaper_image_groups 
		  WHERE id IN (?)
		  ORDER BY FIELD(id, ${collectionIds.map(() => '?').join(',')}) 
		`, [
			collectionIds.map(i => i.group_id), // IN参数展开 
			...collectionIds.map(i => i.group_id) // FIELD排序参数 
		]);

		// 处理图片URL解析 
		groupList.forEach(group => {
			if (group.cover_image) {
				group.cover_image = JSON.parse(group.images_url)[0] + '?imageMogr2/thumbnail/!20p'
			}
			try {
				// group.images_url = JSON.parse(group.images_url);
				group.images_url = []
			} catch (e) {
				group.images_url = [];
				console.warn(`JSON 解析失败: ${group.id}`, e);
			}
		});

		res.send({
			code: 200,
			data: [...groupList].reverse(),
			total: totalResult[0].total
		});

	} catch (e) {
		console.error(`[${formatDateTime()}]  收藏查询失败:`, e);
		res.status(500).send({
			code: 5001,
			msg: "服务端数据解析异常"
		});
	}
});


// 查询收藏状态
router.post('/checkCollection', async (req, res) => {
	try {
		// 1. 获取用户身份（请求头）
		const openid = req.headers['x-wx-openid'];
		const {
			group_id
		} = req.body;

		// 2. 参数有效性校验 
		if (!openid) return res.status(401).send({
			code: 4011,
			msg: "未携带身份凭证"
		});
		if (!Number.isSafeInteger(group_id)) {
			return res.status(400).send({
				code: 4003,
				msg: "分组ID需为有效整数"
			});
		}


		// 3. 高效存在性查询（取代COUNT）
		const [result] = await querySql(
			`SELECT 1 FROM wallpaper_user_collections 
       WHERE user_id = ? AND group_id = ? 
       LIMIT 1`, // 关键优化点：找到即终止扫描 
			[openid, group_id]
		);

		// 4. 响应结构简化 
		res.send({
			code: 200,
			data: {
				collected: !!result // 直接转换查询结果 
			}
		});

	} catch (e) {
		handleError(res, e);
	}
});


// 收藏/取消收藏
router.post('/toggleCollect', async (req, res) => {

	const openid = req.headers['x-wx-openid'];
	if (!openid) return res.status(401).send({
		code: 4011,
		msg: "未携带身份凭证"
	});

	const {
		group_id
	} = req.body;
	try {
		// 原子性操作
		const [exist] = await querySql(
			`SELECT 1 FROM wallpaper_user_collections 
       WHERE user_id = ? AND group_id = ? 
       FOR UPDATE`, // 行级锁防止并发冲突
			[openid, group_id]
		);

		if (exist !== undefined) {
			// 取消收藏
			await querySql(
				`DELETE FROM wallpaper_user_collections 
         WHERE user_id = ? AND group_id = ?`,
				[openid, group_id]
			);
			res.send({
				code: 200,
				data: false
			});
		} else {
			// 新增收藏
			await querySql(
				`INSERT INTO wallpaper_user_collections (user_id, group_id)
         VALUES (?, ?)`,
				[openid, group_id]
			);

			res.send({
				code: 200,
				data: true
			});
		}


	} catch (e) {
		res.status(500).send({
			code: 500,
			msg: '操作失败'
		});
	} finally {
		conn.release();
	}
});


function formatDateTime() {
	const date = new Date();
	const padZero = num => num.toString().padStart(2, '0'); // 补零函数

	return [
		date.getFullYear(),
		padZero(date.getMonth() + 1), // 月份从0开始计算
		padZero(date.getDate()),
	].join('-') + ' ' + [
		padZero(date.getHours()),
		padZero(date.getMinutes()),
		padZero(date.getSeconds())
	].join(':');
}

router.post('/getImageGroups', async (req, res, next) => {
	try {
		const {
			id,
			status,
			featured,
			pageNumber,
			pageSize
		} = req.body; // 获取前端传递的参数

		let sql = 'SELECT * FROM wallpaper_image_groups WHERE 1=1'; // 基础查询语句
		let countSql = 'SELECT COUNT(*) as total FROM wallpaper_image_groups WHERE 1=1';
		let params = []; // 查询参数

		// 根据 ID 查询
		if (id) {
			sql += ' AND id = ?';
			countSql += ' AND id = ?';
			params.push(id);
		}
		// 根据 status 查询
		if (status !== undefined && status !== null && status !== '') {
			if (Array.isArray(status)) {
				// 如果 status 是数组，查询多个状态
				sql += ' AND status IN (?)';
				countSql += ' AND status IN (?)';
				params.push(status);
			} else {
				// 如果 status 是单个值，查询单个状态
				sql += ' AND status = ?';
				countSql += ' AND status = ?';
				params.push(status);
			}
		}
		if (featured !== undefined && featured !== null && featured !== '') {
			sql += ' AND featured = ?';
			countSql += ' AND featured = ?';
			params.push(featured);
		}

		// 排序
		sql += ' ORDER BY create_time DESC';

		// 分页处理
		if (pageNumber && pageSize) {
			const offset = (pageNumber - 1) * pageSize; // 计算偏移量
			sql += ' LIMIT ? OFFSET ?';
			params.push(Number(pageSize), Number(offset));
		}

		// 执行查询
		let list = await querySql(sql, params);
		// 执行查询：获取总数
		let countResult = await querySql(countSql, params);

		// 解析 images_url 字段
		list = list.map(item => {

			if (item.cover_image) {
				item.cover_image = JSON.parse(item.images_url)[0] + '?imageMogr2/thumbnail/!15p'
			}

			if (item.images_url && !pageNumber) {
				try {
					let temp = JSON.parse(item.images_url);
					temp = temp.map(url => url + '?imageMogr2/thumbnail/!70p'); // 返回新数组 
					item.images_url = temp;

				} catch (e) {
					console.error('解析 images_url 失败:', e);
					item.images_url = null; // 解析失败时设置为 null
				}
			} else {
				item.images_url = []
			}

			return item;
		});
		// 返回结果
		res.send({
			code: 200,
			msg: '成功',
			data: list,
			total: countResult[0].total || 0
		});
	} catch (e) {
		next(e); // 错误处理
	}
});

module.exports = router;