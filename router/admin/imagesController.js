const express = require('express');
const router = express.Router();
const utils = require("../../utils/index.js");
const pools = require("../../utils/pools.js");
const axios = require('axios');
const querySql = require("../../utils/query.js");

/**
 * 后台管理 - 图片列表查询接口
 * 从wallpaper_images_list表查询所有图片详情，关联wallpaper_image_group获取分组信息
 * 支持分页、标题模糊查询、分类过滤、状态过滤和标签过滤
 */
router.post('/getImageList', async (req, res) => {
	try {
		const {
			pageNumber = 1,
			pageSize = 20,
			title,
			categoryId,
			status,
			tags,
			sort_field = 'create_time',
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
		const allowedSortFields = ['id', 'image_url', 'status', 'create_time', 'update_time', 'like_count', 'favorite_count', 'view_count'];
		const sortField = allowedSortFields.includes(sort_field) ? sort_field : 'create_time';

		// 排序方向
		const sortOrder = sort_order === 'ASC' ? 'ASC' : 'DESC';

		// 构建SQL查询 - 从wallpaper_images_list表查询，关联wallpaper_image_group获取分组信息
		let sql = `
			SELECT 
				i.id,
				i.image_url,
				i.status,
				i.like_count,
				i.favorite_count,
				i.view_count,
				i.is_webp,
				i.create_time,
				i.update_time,
				i.group_id,
				i.tag_id,
				l.title,
				l.category_id,
				l.category_name,
				l.file as folder_path,
				l.group_images_total
			FROM wallpaper_images_list i
			LEFT JOIN wallpaper_image_group l ON i.group_id = l.id
			WHERE 1=1
		`;

		let countSql = `
			SELECT COUNT(*) as total 
			FROM wallpaper_images_list i
			LEFT JOIN wallpaper_image_group l ON i.group_id = l.id
			WHERE 1=1
		`;

		let params = [];
		let countParams = [];

		// 添加标题模糊查询条件
		if (title && title.trim()) {
			sql += ` AND l.title LIKE ?`;
			countSql += ` AND l.title LIKE ?`;
			const titleParam = `%${title.trim()}%`;
			params.push(titleParam);
			countParams.push(titleParam);
		}

		// 添加分类过滤条件
		if (categoryId) {
			sql += ` AND l.category_id = ?`;
			countSql += ` AND l.category_id = ?`;
			params.push(categoryId);
			countParams.push(categoryId);
		}

		// 添加状态过滤条件
		if (status !== undefined && status !== null && status !== '') {
			sql += ` AND i.status = ?`;
			countSql += ` AND i.status = ?`;
			params.push(status);
			countParams.push(status);
		}

		// 添加标签过滤条件
		if (tags && Array.isArray(tags) && tags.length > 0) {
			// 使用 FIND_IN_SET 匹配 tag_id 字段中的标签ID（逗号分隔）
			const tagConditions = tags.map(() => `FIND_IN_SET(?, i.tag_id)`).join(' OR ');
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

		// 处理结果 - 获取每张图片的标签信息
		const imageIds = result.map(item => item.id);

		// 获取分组ID列表（用于查询标签）
		const groupIds = [...new Set(result.map(item => item.group_id).filter(id => id))];

		// 查询标签信息（关联wallpaper_image_group获取标签）
		let tagInfoMap = {};

		if (groupIds.length > 0) {
			const tagsSql = `
				SELECT t.*, it.image_id, l.tags_id
				FROM wallpaper_image_tags t
				JOIN wallpaper_image_to_tags it ON t.id = it.tag_id
				JOIN wallpaper_image_group l ON it.image_id = l.id
				WHERE it.image_id IN (?)
			`;

			const tagsResult = await querySql(tagsSql, [groupIds]);

			// 构建分组ID到标签的映射
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

			// 处理tagId字符串为数组
			if (camelCaseItem.tagId && typeof camelCaseItem.tagId === 'string') {
				camelCaseItem.tagIdArray = camelCaseItem.tagId.split(',').map(id => parseInt(id)).filter(id => !isNaN(id));
			} else {
				camelCaseItem.tagIdArray = [];
			}

			// 添加标签详细信息（使用group_id关联）
			camelCaseItem.tags = tagInfoMap[item.group_id] || [];

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
 * 后台管理 - 删除图片接口
 * 1. 从wallpaper_images_list表删除对应数据
 * 2. wallpaper_image_group表对应分组的group_images_total减1
 * 3. 如果删除的图片是封面图，则同时删除wallpaper_image_group表中的记录
 */
router.post('/deleteImage', async (req, res) => {
	try {
		const { id } = req.body;

		// 参数校验
		if (!id) {
			return res.status(400).send({
				code: 400,
				msg: "缺少图片ID参数"
			});
		}

		// 开启事务
		await pools({
			sql: "START TRANSACTION",
			val: [],
			run: true,
		});
		try {
			// 1. 查询要删除的图片信息（获取group_id和image_url用于后续判断）
			const { result: imageInfo } = await pools({
				sql: "SELECT id, group_id, image_url FROM wallpaper_images_list WHERE id = ?",
				val: [id],
				run: true,
			});

			if (!imageInfo || imageInfo.length === 0) {
				await pools({ sql: "ROLLBACK", val: [], run: true });
				return res.status(404).send({
					code: 404,
					msg: "图片不存在"
				});
			}

			const { group_id: groupId, image_url: imageUrl } = imageInfo[0];

			// 2. 查询分组信息（获取当前group_images_total和url）
			const { result: groupInfo } = await pools({
				sql: "SELECT id, group_images_total, url FROM wallpaper_image_group WHERE id = ?",
				val: [groupId],
				run: true,
			});

			let deleteGroup = false;

			if (groupInfo && groupInfo.length > 0) {
				const { group_images_total: totalCount, url: coverUrl } = groupInfo[0];

				// 3. 判断是否需要删除分组记录
				// 条件：删除的图片是封面图（image_url === url）且分组只剩1张图
				// imageUrl === coverUrl &&
				if ( Number(totalCount) <= 1) {
					deleteGroup = true;
				} else {
					// 4. 否则只更新group_images_total减1
					await pools({
						sql: "UPDATE wallpaper_image_group SET group_images_total = group_images_total - 1 WHERE id = ? AND group_images_total > 0",
						val: [groupId],
						run: true,
					});
				}
			}

			// 5. 删除wallpaper_images_list表中的记录
			const { result: deleteResult } = await pools({
				sql: "DELETE FROM wallpaper_images_list WHERE id = ?",
				val: [id],
				run: true,
			});

			if (deleteResult.affectedRows === 0) {
				await pools({ sql: "ROLLBACK", val: [], run: true });
				return res.status(404).send({
					code: 404,
					msg: "图片不存在或已删除"
				});
			}

			// 6. 如果需要删除分组，同时删除wallpaper_image_group表记录
			if (deleteGroup) {
				await pools({
					sql: "DELETE FROM wallpaper_image_group WHERE id = ?",
					val: [groupId],
					run: true,
				});

				// 同时删除标签关联关系
				await pools({
					sql: "DELETE FROM wallpaper_image_to_tags WHERE image_id = ?",
					val: [groupId],
					run: true,
				});
			}

			// 提交事务
			await pools({
				sql: "COMMIT",
				val: [],
				run: true,
			});

			return res.send({
				code: 200,
				msg: "删除成功",
				data: {
					deletedId: id,
					groupId: groupId,
					deletedGroup: deleteGroup
				}
			});

		} catch (error) {
			// 回滚事务
			await pools({ sql: "ROLLBACK", val: [], run: true });
			throw error;
		}

	} catch (error) {
		console.error(`[${formatDateTime()}] 删除图片失败:`, error);
		res.status(500).send({
			code: 500,
			msg: "服务器内部错误"
		});
	}
});

// 修改图片显示隐藏状态
router.post('/editImageStatus', async (req, res) => {
	try {
		const { id, status } = req.body;

		// 参数校验
		if (!id) {
			return res.status(400).send({
				code: 400,
				msg: "缺少图片ID参数"
			});
		}
		// status 必须是有效的数值 (0: 隐藏, 1: 显示)
		if (status === undefined || status === null || ![0, 1].includes(Number(status))) {
			return res.status(400).send({
				code: 400,
				msg: "状态参数错误，status 必须为 0 或 1"
			});
		}

		// 执行更新
		const { result } = await pools({
			sql: "UPDATE wallpaper_images_list SET status = ?, update_time = NOW() WHERE id = ?",
			val: [Number(status), id],
			run: true,
		});

		if (result.affectedRows === 0) {
			return res.status(404).send({
				code: 404,
				msg: "图片不存在"
			});
		}

		return res.send({
			code: 200,
			msg: "状态修改成功",
			data: {
				id,
				status: Number(status)
			}
		});

	} catch (error) {
		console.error(`[${formatDateTime()}] 修改图片状态失败:`, error);
		res.status(500).send({
			code: 500,
			msg: "服务器内部错误"
		});
	}
});

module.exports = router;