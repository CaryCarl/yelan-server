const express = require('express');
const router = express.Router();
const utils = require("../../utils/index.js");
const pools = require("../../utils/pools.js");
const axios = require('axios');
const querySql = require("../../utils/query.js");

/**
 * ============================================================================
 * 热门专辑（hot_album）增删改查管理接口
 * ============================================================================
 */

/**
 * 1. 创建专辑 (Create)
 * 接口方法: POST
 * 路由地址: /admin/album/add
 */
router.post("/add", async (req, res) => {
	try {
		const { title, description, cover_image, sort_order = 0, category_id = null, tags = null } = req.body;

		// 基础参数校验
		if (!title) {
			return res.status(400).json({ code: 400, mesg: "专辑标题不能为空" });
		}

		const sql = `
			INSERT INTO hot_album (title, description, cover_image, sort_order, category_id, tags, status)
			VALUES (?, ?, ?, ?, ?, ?, 1)
		`;

		const { result } = await pools({
			sql,
			val: [title, description, cover_image, sort_order, category_id, tags],
			run: true
		});

		return res.status(200).json({
			code: 200,
			mesg: "专辑创建成功",
			data: { albumId: result.insertId }
		});
	} catch (err) {
		console.error("创建专辑失败:", err);
		return res.status(500).json({ code: 500, mesg: err.message || "服务器错误" });
	}
});

/**
 * 2. 删除专辑 (Delete)
 * 说明: 推荐使用软删除(修改status为0), 若需要彻底硬删除可使用 DELETE 语句。这里提供物理删除示例。
 * 接口方法: POST 或 DELETE
 * 路由地址: /admin/album/delete
 */
router.post("/delete", async (req, res) => {
	try {
		const { id } = req.body;

		if (!id) {
			return res.status(400).json({ code: 400, mesg: "专辑ID不能为空" });
		}

		// 彻底删除专辑主表记录
		const deleteAlbumSql = `DELETE FROM hot_album WHERE id = ?`;
		await pools({ sql: deleteAlbumSql, val: [id], run: true });

		// 同时清理关联表中的数据，防止产生孤儿关联数据
		const deleteRelationSql = `DELETE FROM hot_album_group_relation WHERE album_id = ?`;
		await pools({ sql: deleteRelationSql, val: [id], run: true });

		return res.status(200).json({
			code: 200,
			mesg: "专辑及关联数据删除成功"
		});
	} catch (err) {
		console.error("删除专辑失败:", err);
		return res.status(500).json({ code: 500, mesg: err.message || "服务器错误" });
	}
});

/**
 * 3. 修改专辑信息 (Update)
 * 接口方法: POST
 * 路由地址: /admin/album/update
 */
router.post("/update", async (req, res) => {
	try {
		const { id, title, description, cover_image, sort_order, status, category_id, tags } = req.body;

		if (!id) {
			return res.status(400).json({ code: 400, mesg: "专辑ID不能为空" });
		}

		// 构建动态更新字段与参数值
		const updateFields = [];
		const queryParams = [];

		if (title !== undefined) { updateFields.push("title = ?"); queryParams.push(title); }
		if (description !== undefined) { updateFields.push("description = ?"); queryParams.push(description); }
		if (cover_image !== undefined) { updateFields.push("cover_image = ?"); queryParams.push(cover_image); }
		if (sort_order !== undefined) { updateFields.push("sort_order = ?"); queryParams.push(sort_order); }
		if (status !== undefined) { updateFields.push("status = ?"); queryParams.push(status); }
		if (category_id !== undefined) { updateFields.push("category_id = ?"); queryParams.push(category_id); }
		if (tags !== undefined) { updateFields.push("tags = ?"); queryParams.push(tags); }

		if (updateFields.length === 0) {
			return res.status(400).json({ code: 400, mesg: "未传入任何修改字段" });
		}

		// 追加 WHERE 条件的 id 参数
		queryParams.push(id);

		const sql = `UPDATE hot_album SET ${updateFields.join(", ")} WHERE id = ?`;
		await pools({ sql, val: queryParams, run: true });

		return res.status(200).json({
			code: 200,
			mesg: "专辑更新成功"
		});
	} catch (err) {
		console.error("更新专辑失败:", err);
		return res.status(500).json({ code: 500, mesg: err.message || "服务器错误" });
	}
});

/**
 * 4. 查询专辑分页列表 (Read - List)
 * 说明: 支持关键词模糊搜索，支持管理端查询全部状态或用户端只查上架(status=1)
 * 接口方法: GET
 * 路由地址: /admin/album/list
 */
router.get("/list", async (req, res) => {
	try {
		const { page = 1, pageSize = 10, keyword = "", status } = req.query;

		const currentPage = parseInt(page) || 1;
		const limit = parseInt(pageSize) || 10;
		const offset = (currentPage - 1) * limit;

		// 动态构建查询条件
		let whereClause = "WHERE 1=1";
		const queryParams = [];

		if (keyword) {
			whereClause += " AND (title LIKE ? OR description LIKE ?)";
			queryParams.push(`%${keyword}%`, `%${keyword}%`);
		}

		if (status !== undefined && status !== "") {
			whereClause += " AND status = ?";
			queryParams.push(parseInt(status));
		}

		// 查询总量
		const countSql = `SELECT COUNT(*) AS total FROM hot_album ${whereClause}`;
		const { result: countResult } = await pools({ sql: countSql, val: queryParams, run: true });
		const total = countResult[0]?.total || 0;

		if (total === 0) {
			return res.status(200).json({
				code: 200,
				mesg: "查询成功",
				data: { list: [], pagination: { total, page: currentPage, pageSize: limit, totalPages: 0 } }
			});
		}

		// 查询分页数据 (按权重及创建时间倒序)
		const listSql = `
			SELECT * FROM hot_album 
			${whereClause} 
			ORDER BY sort_order DESC, id DESC 
			LIMIT ? OFFSET ?
		`;
		
		// 复制一份参数用于列表查询，并追加 limit 和 offset
		const listParams = [...queryParams, limit, offset];
		const { result: listResult } = await pools({ sql: listSql, val: listParams, run: true });

		// 统一执行下划线转驼峰命名转换
		const camelCaseList = listResult.map(item => utils.toCamelCase(item));
		const totalPages = Math.ceil(total / limit);

		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: {
				list: camelCaseList,
				pagination: { total, page: currentPage, pageSize: limit, totalPages }
			}
		});
	} catch (err) {
		console.error("获取专辑列表失败:", err);
		return res.status(500).json({ code: 500, mesg: err.message || "服务器错误" });
	}
});

/**
 * 5. 查询单个专辑详情 (Read - Detail)
 * 接口方法: GET
 * 路由地址: /admin/album/detail
 */
router.get("/detail", async (req, res) => {
	try {
		const { id } = req.query;

		if (!id) {
			return res.status(400).json({ code: 400, mesg: "专辑ID不能为空" });
		}

		const sql = `SELECT * FROM hot_album WHERE id = ?`;
		const { result } = await pools({ sql, val: [id], run: true });

		if (result.length === 0) {
			return res.status(404).json({ code: 404, mesg: "未找到该专辑信息" });
		}

		const camelCaseDetail = utils.toCamelCase(result[0]);

		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: camelCaseDetail
		});
	} catch (err) {
		console.error("获取专辑详情失败:", err);
		return res.status(500).json({ code: 500, mesg: err.message || "服务器错误" });
	}
});

module.exports = router;