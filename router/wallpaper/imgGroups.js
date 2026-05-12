const express = require('express');
const router = express.Router();
const utils = require("../../utils/index.js");
const pools = require("../../utils/pools.js");
const axios = require('axios');
const querySql = require("../../utils/query.js");

/**
 * 后台管理 - 图片列表查询接口
 * 支持分页、标签过滤、标题模糊查询、分类过滤和状态过滤
 */
router.post('/getImageList', async (req, res) => {
	try {
		const {
			pageNumber = 1,
				pageSize = 10,
				tags_id,
				title,
				category_id,
				status,
				sort_field = 'creation_time',
				sort_order = 'DESC'
		} = req.body;

		// 参数校验
		if (pageNumber < 1 || pageSize < 1) {
			return res.status(400).send({
				code: 400,
				msg: "分页参数错误"
			});
		}

		// 允许的排序字段
		const allowedSortFields = ['id', 'title', 'category_id', 'creation_time', 'status'];
		const sortField = allowedSortFields.includes(sort_field) ? sort_field : 'creation_time';

		// 排序方向
		const sortOrder = sort_order === 'ASC' ? 'ASC' : 'DESC';

		// 构建基础SQL查询
		let sql = `SELECT i.*, c.name as category_name 
                   FROM wallpaper_image_list i
                   LEFT JOIN wallpaper_image_categories c ON i.category_id = c.id
                   WHERE 1=1`;

		let countSql = `SELECT COUNT(*) as total FROM wallpaper_image_list WHERE 1=1`;

		let params = [];
		let countParams = [];

		// 添加标签过滤条件
		if (tags_id) {
			// 如果是单个标签ID
			if (!Array.isArray(tags_id)) {
				sql += ` AND FIND_IN_SET(?, tags_id)`;
				countSql += ` AND FIND_IN_SET(?, tags_id)`;
				params.push(tags_id);
				countParams.push(tags_id);
			}
			// 如果是多个标签ID数组
			else if (tags_id.length > 0) {
				const tagConditions = tags_id.map(() => `FIND_IN_SET(?, tags_id)`).join(" OR ");
				sql += ` AND (${tagConditions})`;
				countSql += ` AND (${tagConditions})`;
				params.push(...tags_id);
				countParams.push(...tags_id);
			}
		}

		// 添加标题模糊查询条件
		if (title && title.trim()) {
			sql += ` AND title LIKE ?`;
			countSql += ` AND title LIKE ?`;
			const titleParam = `%${title.trim()}%`;
			params.push(titleParam);
			countParams.push(titleParam);
		}

		// 添加分类过滤条件
		if (category_id) {
			// 如果是单个分类ID
			if (!Array.isArray(category_id)) {
				sql += ` AND i.category_id = ?`;
				countSql += ` AND category_id = ?`;
				params.push(category_id);
				countParams.push(category_id);
			}
			// 如果是多个分类ID数组
			else if (category_id.length > 0) {
				sql += ` AND i.category_id IN (?)`;
				countSql += ` AND category_id IN (?)`;
				params.push(category_id);
				countParams.push(category_id);
			}
		}

		// 添加状态过滤条件
		if (status !== undefined && status !== null && status !== '') {
			sql += ` AND i.status = ?`;
			countSql += ` AND status = ?`;
			params.push(status);
			countParams.push(status);
		}

		// 获取总记录数
		const [countResult] = await querySql(countSql, countParams);
		const total = countResult.total || 0;

		// 如果没有记录，直接返回空数组
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

		// 添加排序
		sql += ` ORDER BY i.${sortField} ${sortOrder}`;

		// 添加分页
		const offset = (pageNumber - 1) * pageSize;
		sql += ` LIMIT ? OFFSET ?`;
		params.push(Number(pageSize), Number(offset));

		// 执行查询
		const result = await querySql(sql, params);

		// 处理结果 - 获取每个图片的标签信息
		const imageIds = result.map(item => item.id);

		// 如果有图片，查询它们的标签信息
		let tagInfoMap = {};

		if (imageIds.length > 0) {
			const tagsSql = `
                SELECT t.*, it.image_id
                FROM wallpaper_image_tags t
                JOIN wallpaper_image_to_tags it ON t.id = it.tag_id
                WHERE it.image_id IN (?)
            `;

			const tagsResult = await querySql(tagsSql, [imageIds]);

			// 构建图片ID到标签的映射
			tagsResult.forEach(tag => {
				if (!tagInfoMap[tag.image_id]) {
					tagInfoMap[tag.image_id] = [];
				}
				tagInfoMap[tag.image_id].push({
					id: tag.id,
					name: tag.name,
					group_id: tag.group_id,
					group_name: tag.group_name
				});
			});
		}

		// 处理结果 - 转换为驼峰命名并添加标签信息
		const formattedResult = result.map(item => {
			// 转换为驼峰命名
			let camelCaseItem = utils.toCamelCase(item);

			// 处理标签ID字符串为数组
			if (camelCaseItem.tagsId && typeof camelCaseItem.tagsId === 'string') {
				camelCaseItem.tagsIdArray = camelCaseItem.tagsId.split(',').map(id => parseInt(id));
			} else {
				camelCaseItem.tagsIdArray = [];
			}

			// 添加标签详细信息
			camelCaseItem.tags = tagInfoMap[item.id] || [];

			return camelCaseItem;
		});

		// 返回结果
		res.send({
			code: 200,
			data: formattedResult,
			total,
			pageNumber: Number(pageNumber),
			pageSize: Number(pageSize),
			msg: "查询成功"
		});

	} catch (error) {
		console.error(`[${formatDateTime()}] 查询图片列表失败:`, error);
		res.status(500).send({
			code: 500,
			msg: "服务器内部错误"
		});
	}
});

// 格式化日期时间
function formatDateTime() {
	const date = new Date();
	const padZero = num => num.toString().padStart(2, '0');

	return [
		date.getFullYear(),
		padZero(date.getMonth() + 1),
		padZero(date.getDate()),
	].join('-') + ' ' + [
		padZero(date.getHours()),
		padZero(date.getMinutes()),
		padZero(date.getSeconds())
	].join(':');
}
/**
 * 图片分组--------------------------
 */
//添加图片分组
router.post("/addImageGroups", async (req, res) => {
	let sql =
		"INSERT INTO wallpaper_image_groups (category_id, category_name,title, file, status, create_time, cover_image,images_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
		obj = req.body;
	const result = await client.put(obj.file, Buffer.from(''));
	if (result?.res?.status !== 200) {
		return {
			code: 500,
			mesg: "创建文件夹失败"
		}
	}
	let imagesUrl = JSON.stringify(obj.imagesUrl)
	await pools({
		sql,
		val: [obj.categoryId, obj.categoryName, obj.title, obj.file, obj.status, obj.createTime, obj
			.coverImage || "", imagesUrl
		],
		run: false,
		res,
		req
	});
});
//删除分组
router.post("/delImageGroups", async (req, res) => {
	let sql = "DELETE FROM wallpaper_image_groups WHERE id=?",
		obj = req.body;
	await pools({
		sql,
		val: [obj.id],
		run: false,
		res,
		req
	});
});


//修改图片分组
router.post("/editImageGroups", async (req, res) => {
	let sql =
		"UPDATE  wallpaper_image_groups SET title=?,file=?,status=?,update_time=?,category_id=?,category_name=?,cover_image=?,images_url=? WHERE id=?",
		obj = req.body;
	let imagesUrlStr = JSON.stringify(obj.imagesUrl);
	await pools({
		sql,
		val: [obj.title, obj.file, obj.status, obj.updateTime, obj.categoryId, obj.categoryName, obj
			.coverImage, imagesUrlStr, obj.id
		],
		run: false,
		res,
		req
	});
});

// 下载图片并返回 Buffer 
async function downloadImage(url) {
	const response = await axios.get(url, {
		responseType: 'arraybuffer'
	});
	return Buffer.from(response.data, 'binary');
}

// 查询图片分组
router.post("/getImageGroups", async (req, res) => {
	let sql = `SELECT * FROM wallpaper_image_groups WHERE 1=1`,
		obj = req.body;
	let countSql = `SELECT COUNT(*) as total FROM wallpaper_image_groups WHERE 1=1`;
	let params = []
	if (obj?.title) {
		sql = utils.setLike(sql, "title", obj.title);
		countSql = utils.setLike(countSql, "title", obj.title);
	}
	if (obj.status !== undefined && obj.status !== null && obj.status !== '') {
		sql += ' AND status = ?';
		countSql += ' AND status = ?';
		params.push(obj.status);
	}

	if (obj?.categoryId) {
		sql += ' AND category_id = ?';
		countSql += ' AND category_id = ?';
		params.push(obj.categoryId);
	}

	// 分页处理
	if (obj.pageNumber && obj.pageSize) {
		const offset = (obj.pageNumber - 1) * obj.pageSize; // 计算偏移量
		sql += ' LIMIT ? OFFSET ?';
		params.push(Number(obj.pageSize), Number(offset));
	}

	let {
		result
	} = await pools({
		sql,
		val: params,
		res,
		req
	});
	let countResult = await pools({
		sql: countSql,
		val: params,
		res,
		req
	});
	let total = countResult?.result[0]?.total || 0

	// const camelCaseResult = result.map(utils.toCamelCase);
	// 将 images_url 从 JSON 字符串转为数组
	const camelCaseResult = result.map(item => {
		let camelCaseItem = utils.toCamelCase(item); // 转换为驼峰命名
		if (camelCaseItem.imagesUrl) {
			camelCaseItem.imagesUrl = JSON.parse(camelCaseItem.imagesUrl); // 解析 JSON 字符串
		}
		return camelCaseItem;
	});


	res.send(utils.returnData({
		data: camelCaseResult,
		total
	}));
});

module.exports = router;