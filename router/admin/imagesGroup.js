const express = require('express');
const router = express.Router();
const utils = require("../../utils/index.js");
const pools = require("../../utils/pools.js");
const axios = require('axios');
const querySql = require("../../utils/query.js");
const { formatDateTime } = require("../../utils/formatDateTime.js");

/**
 * 后台管理 - 分组列表查询接口
 * 从wallpaper_image_group表查询所有分组
 * 支持分页、标题模糊查询、分类过滤、状态过滤、标签过滤和is_webp过滤
 */
router.post('/getImageGroupList', async (req, res) => {
	try {
		const {
			pageNumber = 1,
			pageSize = 20,
			title,
			categoryId,
			status,
			tags,
			isWebp,
			sort_field = 'creation_time',
			sort_order = 'DESC'
		} = req.body;

		// 参数校验
		if (pageNumber < 1 || pageSize < 1) {
			return res.json(utils.returnData({ code: 400, msg: "分页参数错误" }));
		}

		// 允许的排序字段
		const allowedSortFields = ['id', 'creation_time', 'status', 'is_webp', 'favorite_count', 'group_images_total'];
		const sortField = allowedSortFields.includes(sort_field) ? sort_field : 'creation_time';

		// 排序方向
		const sortOrder = sort_order === 'ASC' ? 'ASC' : 'DESC';

		// 构建SQL查询
		let sql = `SELECT * FROM wallpaper_image_group WHERE 1=1`;
		let countSql = `SELECT COUNT(*) as total FROM wallpaper_image_group WHERE 1=1`;
		let params = [];
		let countParams = [];

		// 添加标题模糊查询条件
		if (title && title.trim()) {
			sql += ` AND title LIKE ?`;
			countSql += ` AND title LIKE ?`;
			const titleParam = `%${title.trim()}%`;
			params.push(titleParam);
			countParams.push(titleParam);
		}

		// 添加分类过滤条件
		if (categoryId) {
			sql += ` AND category_id = ?`;
			countSql += ` AND category_id = ?`;
			params.push(categoryId);
			countParams.push(categoryId);
		}

		// 添加状态过滤条件
		if (status !== undefined && status !== null && status !== '') {
			sql += ` AND status = ?`;
			countSql += ` AND status = ?`;
			params.push(status);
			countParams.push(status);
		}

		// 添加is_webp过滤条件
		if (isWebp !== undefined && isWebp !== null && isWebp !== '') {
			sql += ` AND is_webp = ?`;
			countSql += ` AND is_webp = ?`;
			params.push(isWebp);
			countParams.push(isWebp);
		}

		// 添加标签过滤条件
		if (tags && Array.isArray(tags) && tags.length > 0) {
			// 使用 FIND_IN_SET 匹配 tags_id 字段中的标签ID（逗号分隔）
			const tagConditions = tags.map(() => `FIND_IN_SET(?, tags_id)`).join(' OR ');
			sql += ` AND (${tagConditions})`;
			countSql += ` AND (${tagConditions})`;
			params.push(...tags);
			countParams.push(...tags);
		}

		// 获取总记录数
		const [countResult] = await querySql(countSql, countParams);
		const total = countResult.total || 0;

		// 如果没有记录，直接返回空数组
		if (total === 0) {
			return res.json(utils.returnData({
				data: [],
				total: 0,
				pageNumber,
				pageSize
			}));
		}

		// 添加排序
		sql += ` ORDER BY ${sortField} ${sortOrder}`;

		// 添加分页
		const offset = (pageNumber - 1) * pageSize;
		sql += ` LIMIT ? OFFSET ?`;
		params.push(Number(pageSize), Number(offset));

		// 执行查询
		const result = await querySql(sql, params);

		// 处理结果 - 转换为驼峰命名
		const formattedResult = result.map(item => {
			let camelCaseItem = utils.toCamelCase(item);

			// 处理tagsId字符串为数组
			if (camelCaseItem.tagsId && typeof camelCaseItem.tagsId === 'string') {
				camelCaseItem.tagsIdArray = camelCaseItem.tagsId.split(',').map(id => parseInt(id)).filter(id => !isNaN(id));
			} else {
				camelCaseItem.tagsIdArray = [];
			}

			return camelCaseItem;
		});

		// 返回结果
		res.json(utils.returnData({
			data: formattedResult,
			total,
			pageNumber: Number(pageNumber),
			pageSize: Number(pageSize)
		}));

	} catch (error) {
		console.error(`[${formatDateTime()}] 查询分组列表失败:`, error);
		res.json(utils.returnData({ code: 500, msg: "查询失败", err: error.message }));
	}
});

/**
 * 后台管理 - 修改分组状态接口
 */
router.post('/editImageGroupStatus', async (req, res) => {
	try {
		const { id, status } = req.body;

		// 参数校验
		if (!id) {
			return res.json(utils.returnData({ code: 400, msg: "缺少分组ID" }));
		}

		if (status === undefined || status === null || ![0, 1].includes(Number(status))) {
			return res.json(utils.returnData({ code: 400, msg: "状态参数错误，status 必须为 0 或 1" }));
		}

		// 执行更新
		const { result } = await pools({
			sql: "UPDATE wallpaper_image_group SET status = ? WHERE id = ?",
			val: [Number(status), id],
			run: true,
		});

		if (result.affectedRows === 0) {
			return res.json(utils.returnData({ code: 404, msg: "分组不存在" }));
		}

		return res.json(utils.returnData({
			data: { id, status: Number(status) }
		}));

	} catch (error) {
		console.error(`[${formatDateTime()}] 修改分组状态失败:`, error);
		res.json(utils.returnData({ code: 500, msg: "修改失败", err: error.message }));
	}
});

/**
 * 后台管理 - 批量修改分组状态接口
 */
router.post('/editImageGroupStatusBatch', async (req, res) => {
	try {
		const { ids, status } = req.body;

		// 参数校验
		if (!ids || !Array.isArray(ids) || ids.length === 0) {
			return res.json(utils.returnData({ code: 400, msg: "缺少分组ID列表" }));
		}

		if (status === undefined || status === null || ![0, 1].includes(Number(status))) {
			return res.json(utils.returnData({ code: 400, msg: "状态参数错误，status 必须为 0 或 1" }));
		}

		// 执行批量更新
		const placeholders = ids.map(() => '?').join(',');
		const { result } = await pools({
			sql: `UPDATE wallpaper_image_group SET status = ? WHERE id IN (${placeholders})`,
			val: [Number(status), ...ids],
			run: true,
		});

		return res.json(utils.returnData({
			data: {
				affectedRows: result.affectedRows,
				ids
			}
		}));

	} catch (error) {
		console.error(`[${formatDateTime()}] 批量修改分组状态失败:`, error);
		res.json(utils.returnData({ code: 500, msg: "修改失败", err: error.message }));
	}
});

/**
 * 后台管理 - 删除分组接口
 */
router.post('/deleteImageGroup', async (req, res) => {
	try {
		const { id } = req.body;

		if (!id) {
			return res.json(utils.returnData({ code: 400, msg: "缺少分组ID" }));
		}

		// 开启事务
		await pools({ sql: "START TRANSACTION", val: [], run: true });

		try {
			// 1. 查询分组信息
			const { result: groupInfo } = await pools({
				sql: "SELECT id, file FROM wallpaper_image_group WHERE id = ?",
				val: [id],
				run: true,
			});

			if (!groupInfo || groupInfo.length === 0) {
				await pools({ sql: "ROLLBACK", val: [], run: true });
				return res.json(utils.returnData({ code: 404, msg: "分组不存在" }));
			}

			// 2. 删除分组下的图片关联
			await pools({
				sql: "DELETE FROM wallpaper_image_list WHERE group_id = ?",
				val: [id],
				run: true,
			});

			// 3. 删除标签关联
			await pools({
				sql: "DELETE FROM wallpaper_image_to_tags WHERE image_id = ?",
				val: [id],
				run: true,
			});

			// 4. 删除分组
			const { result: deleteResult } = await pools({
				sql: "DELETE FROM wallpaper_image_group WHERE id = ?",
				val: [id],
				run: true,
			});

			if (deleteResult.affectedRows === 0) {
				await pools({ sql: "ROLLBACK", val: [], run: true });
				return res.json(utils.returnData({ code: 404, msg: "分组不存在" }));
			}

			// 提交事务
			await pools({ sql: "COMMIT", val: [], run: true });

			return res.json(utils.returnData({
				data: { id }
			}));

		} catch (error) {
			await pools({ sql: "ROLLBACK", val: [], run: true });
			throw error;
		}

	} catch (error) {
		console.error(`[${formatDateTime()}] 删除分组失败:`, error);
		res.json(utils.returnData({ code: 500, msg: "删除失败", err: error.message }));
	}
});

/**
 * 后台管理 - 批量删除分组接口
 */
router.post('/deleteImageGroupBatch', async (req, res) => {
	try {
		const { ids } = req.body;

		if (!ids || !Array.isArray(ids) || ids.length === 0) {
			return res.json(utils.returnData({ code: 400, msg: "缺少分组ID列表" }));
		}

		// 开启事务
		await pools({ sql: "START TRANSACTION", val: [], run: true });

		try {
			const placeholders = ids.map(() => '?').join(',');

			// 1. 删除分组下的图片关联
			await pools({
				sql: `DELETE FROM wallpaper_image_list WHERE group_id IN (${placeholders})`,
				val: ids,
				run: true,
			});

			// 2. 删除标签关联
			await pools({
				sql: `DELETE FROM wallpaper_image_to_tags WHERE image_id IN (${placeholders})`,
				val: ids,
				run: true,
			});

			// 3. 删除分组
			const { result } = await pools({
				sql: `DELETE FROM wallpaper_image_group WHERE id IN (${placeholders})`,
				val: ids,
				run: true,
			});

			// 提交事务
			await pools({ sql: "COMMIT", val: [], run: true });

			return res.json(utils.returnData({
				data: {
					affectedRows: result.affectedRows,
					ids
				}
			}));

		} catch (error) {
			await pools({ sql: "ROLLBACK", val: [], run: true });
			throw error;
		}

	} catch (error) {
		console.error(`[${formatDateTime()}] 批量删除分组失败:`, error);
		res.json(utils.returnData({ code: 500, msg: "删除失败", err: error.message }));
	}
});

/**
 * 后台管理 - 查询分组下的图片列表接口
 * 根据groupId查询wallpaper_images_list表中的图片
 */
router.post('/getImageListByGroupId', async (req, res) => {
	try {
		const {
			groupId,
			pageNumber = 1,
			pageSize = 20,
			status,
			isWebp
		} = req.body;

		// 参数校验
		if (!groupId) {
			return res.json(utils.returnData({ code: 400, msg: "缺少分组ID(groupId)" }));
		}

		if (pageNumber < 1 || pageSize < 1) {
			return res.json(utils.returnData({ code: 400, msg: "分页参数错误" }));
		}

		// 构建SQL查询
		let sql = `SELECT * FROM wallpaper_images_list WHERE group_id = ?`;
		let countSql = `SELECT COUNT(*) as total FROM wallpaper_images_list WHERE group_id = ?`;
		let params = [groupId];
		let countParams = [groupId];

		// 添加状态过滤条件
		if (status !== undefined && status !== null && status !== '') {
			sql += ` AND status = ?`;
			countSql += ` AND status = ?`;
			params.push(status);
			countParams.push(status);
		}

		// 添加is_webp过滤条件
		if (isWebp !== undefined && isWebp !== null && isWebp !== '') {
			sql += ` AND is_webp = ?`;
			countSql += ` AND is_webp = ?`;
			params.push(isWebp);
			countParams.push(isWebp);
		}

		// 获取总记录数
		const [countResult] = await querySql(countSql, countParams);
		const total = countResult.total || 0;

		// 如果没有记录，直接返回空数组
		if (total === 0) {
			return res.json(utils.returnData({
				data: [],
				total: 0,
				pageNumber,
				pageSize
			}));
		}

		// 添加排序（按创建时间倒序）
		sql += ` ORDER BY create_time DESC`;

		// 添加分页
		const offset = (pageNumber - 1) * pageSize;
		sql += ` LIMIT ? OFFSET ?`;
		params.push(Number(pageSize), Number(offset));

		// 执行查询
		const result = await querySql(sql, params);

		// 处理结果 - 转换为驼峰命名
		const formattedResult = result.map(item => {
			let camelCaseItem = utils.toCamelCase(item);

			// 处理tagId字符串为数组
			if (camelCaseItem.tagId && typeof camelCaseItem.tagId === 'string') {
				camelCaseItem.tagIdArray = camelCaseItem.tagId.split(',').map(id => parseInt(id)).filter(id => !isNaN(id));
			} else {
				camelCaseItem.tagIdArray = [];
			}

			return camelCaseItem;
		});

		// 返回结果
		res.json(utils.returnData({
			data: formattedResult,
			total,
			pageNumber: Number(pageNumber),
			pageSize: Number(pageSize)
		}));

	} catch (error) {
		console.error(`[${formatDateTime()}] 查询分组图片列表失败:`, error);
		res.json(utils.returnData({ code: 500, msg: "查询失败", err: error.message }));
	}
});

module.exports = router;