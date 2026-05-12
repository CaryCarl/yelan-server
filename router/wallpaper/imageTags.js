const express = require('express');
const router = express.Router();
const utils = require("../../utils/index.js");
const pools = require("../../utils/pools.js");

/**
 * 标签管理--------------------------
 */

//添加标签
router.post("/create_image_tag", async (req, res) => {
	let sql = "INSERT INTO wallpaper_image_tags(name,sort,status,	group_id,group_name) VALUES (?,?,?,?,?)",
		obj = req.body;

	await pools({
		sql,
		val: [obj.name, obj.sort, obj.status, obj.groupId, obj.groupName],
		run: false,
		res,
		req
	});
});


//删除标签
router.get("/delete_image_tag", async (req, res) => {
	try {
		let sql = "DELETE FROM wallpaper_image_tags WHERE id = ?";
		// 注意：GET 请求建议改用 req.query.id，前端访问方式为 /delete_image_tag?id=1
		let id = req.query.id || req.body.id;
		console.log(id);

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


//修改标签
router.post("/update_image_tag", async (req, res) => {
	let sql =
		`UPDATE wallpaper_image_tags 
            SET name=?, sort=?, status=?, group_id=?, group_name=?
            WHERE id=?`;

	const {
		name,
		sort,
		status,
		groupId,
		groupName,
		id
	} = req.body;

	await pools({
		sql,
		val: [name, sort, status, groupId, groupName, id],
		run: false,
		res,
		req
	});
});

// 查询图片标签
router.get("/get_wallpaper_image_tags", async (req, res) => {
	try {
		// 直接查询所有标签数据
		const result = await pools({
			sql: `SELECT  * FROM wallpaper_image_tags`
		});

		// 将 images_url 从 JSON 字符串转为数组
		const camelCaseResult = result.result.map(item => {
			let camelCaseItem = utils.toCamelCase(item); // 转换为驼峰命名
			return camelCaseItem;
		});

		res.json({
			code: 200,
			data: camelCaseResult,
			message: '查询成功'
		});

	} catch (error) {
		console.error(' 查询图片标签失败:', error);
		res.status(500).json({
			code: 500,
			message: '服务器内部错误'
		});
	}
});

// 修改标签状态并同步更新关联图片的状态
router.post("/update_image_tag_status", async (req, res) => {
	try {
		const { id, status } = req.body;

		if (!id || status === undefined) {
			return res.status(400).json({
				code: 400,
				message: '参数错误：标签ID和状态不能为空'
			});
		}

		// 1. 先查询标签当前状态
		const tagQuery = await pools({
			sql: `SELECT status FROM wallpaper_image_tags WHERE id = ?`,
			val: [id],
			run: true
		});

		const oldStatus = tagQuery?.result?.[0]?.status;

		// 2. 更新标签的status字段
		await pools({
			sql: `UPDATE wallpaper_image_tags SET status = ? WHERE id = ?`,
			val: [status, id],
			run: true
		});

		// 3. 查找所有tags_id字段包含该标签ID的图片，并更新它们的status
		// 使用 FIND_IN_SET 函数，tags_id 格式如 '5,10,6'
		const updateImageSql = `
			UPDATE wallpaper_image_list
			SET status = ?
			WHERE FIND_IN_SET(?, tags_id)
		`;

		await pools({
			sql: updateImageSql,
			val: [status, String(id)],
			run: true
		});

		res.json({
			code: 200,
			message: '标签状态更新成功，关联图片状态已同步'
		});

	} catch (error) {
		console.error('更新标签状态失败:', error);
		res.status(500).json({
			code: 500,
			message: '服务器内部错误',
			error: error.message
		});
	}
});


module.exports = router;