const express = require('express');
const router = express.Router();
const utils = require("../../../utils/index.js");
const pools = require("../../../utils/pools.js");
const COS = require('cos-nodejs-sdk-v5');
const config = require("../../../utils/config.js");

// 保存图片
router.post("/addImgInfo", async (req, res) => {
	const typeNames = req.body; // 假设请求体直接是数组

	if (!Array.isArray(typeNames) || typeNames.length === 0) {
		return res.status(400).send({ message: 'Invalid input data' });
	}

	// 构建批量插入的 SQL 语句和参数
	const sql = 'INSERT INTO app_img_list (group_id,name,create_time,url,des,file_name,originalname,status) VALUES ?';
	const values = typeNames.map(item => [item.typeId, item.typeName, item.createTime, item.url, item.des, item.filename,item.originalname, item.status]);

	await pools({ sql, val: [values], run: false, res, req });
});


// 查询图片
router.post("/getAppImgList", async (req, res) => {
	let sql = `SELECT * FROM app_img_list WHERE 1=1`, obj = req.body;
	let countSql = `SELECT COUNT(*) as total FROM app_img_list WHERE 1=1`;
	let params = []

	if (obj?.name) {
		sql = utils.setLike(sql, "name", obj.name);
		countSql = utils.setLike(countSql, "name", obj.name);
	}
	if (obj.status !== undefined && obj.status !== null && obj.status !== '') {
		sql += ' AND status = ?';
		countSql += ' AND status = ?';
		params.push(obj.status);
	}
	let { result } = await pools({ sql, val: [obj.status], res, req });
	let countResult = await pools({ sql: countSql, val: params, res, req });
	let total = countResult?.result[0]?.total || 0

	const camelCaseResult = result.map(utils.toCamelCase);

	res.send(utils.returnData({ data: camelCaseResult, total }));
});
//删除图片
router.post("/delAppImg", async (req, res) => {
	let sql = "DELETE FROM app_img_list WHERE id=?",
		obj = req.body;
	await pools({ sql, val: [obj.id], run: false, res, req });
});

// -------------------------------------------------------------------------------------------------


/**
 * 图片分类--------------------------
 */
//添加图片分类
router.post("/addType", async (req, res) => {
	try {
		let sql = "INSERT INTO wallpaper_image_categories (name, create_time,file, status) VALUES (?, ?, ?, ?)",
			obj = req.body;
		let file = `dajuzi/${obj.file}/`;

		// 使用腾讯云COS创建文件夹（上传一个空对象，以/结尾）
		await cos.putObject({
			Bucket: '', // 存储桶名称
			Region: '', // 地域
			Key: file, // 文件夹路径，以/结尾
			Body: Buffer.from(''), // 空内容
		});

		await pools({ sql, val: [obj.name, obj.createTime, file, obj.status], run: false, res, req });
	} catch (error) {
		console.error('添加分类失败:', error);
		return res.status(500).send({
			code: 500,
			msg: "创建文件夹失败"
		});
	}
});

//删除分类
router.post("/delType", async (req, res) => {
	let sql = "DELETE FROM wallpaper_image_categories WHERE id=?",
		obj = req.body;
	await pools({ sql, val: [obj.id], run: false, res, req });
});

//修改图片分类
router.post("/editType", async (req, res) => {
	let sql = "UPDATE  wallpaper_image_categories SET name=?,file=?,status=?,update_time=? WHERE id=?",
		obj = req.body;
	await pools({ sql, val: [obj.name, obj.file, obj.status, obj.updateTime, obj.id], run: false, res, req });
});
// 查询图片分类
router.post("/getType", async (req, res) => {
	let sql = `SELECT * FROM wallpaper_image_categories WHERE 1=1`, obj = req.body;
	let countSql = `SELECT COUNT(*) as total FROM wallpaper_image_categories WHERE 1=1`;
	let params = []
	if (obj?.name) {
		sql = utils.setLike(sql, "name", obj.name);
		countSql = utils.setLike(countSql, "name", obj.name);
	}
	if (obj.status !== undefined && obj.status !== null && obj.status !== '') {
		sql += ' AND status = ?';
		countSql += ' AND status = ?';
		params.push(obj.status);
	}
	let { result } = await pools({ sql, val: [obj.status], res, req });
	let countResult = await pools({ sql: countSql, val: params, res, req });
	let total = countResult?.result[0]?.total || 0
	const camelCaseResult = result.map(utils.toCamelCase);
	res.send(utils.returnData({ data: camelCaseResult, total }));
});



// 修改分类状态并同步更新关联图片的状态
router.post("/update_category_status", async (req, res) => {
	try {
		const { id, status } = req.body;

		if (!id || status === undefined) {
			return res.status(400).json({
				code: 400,
				message: '参数错误：分类ID和状态不能为空'
			});
		}

		// 1. 更新分类的status字段
		await pools({
			sql: `UPDATE wallpaper_image_categories SET status = ? WHERE id = ?`,
			val: [status, id],
			run: true
		});

		// 2. 查找所有category_id等于该分类ID的图片，并更新它们的status
		const updateImageSql = `
			UPDATE wallpaper_image_group
			SET status = ?
			WHERE category_id = ?
		`;

		await pools({
			sql: updateImageSql,
			val: [status, id],
			run: true
		});

		res.json({
			code: 200,
			message: '分类状态更新成功，关联图片状态已同步'
		});

	} catch (error) {
		console.error('更新分类状态失败:', error);
		res.status(500).json({
			code: 500,
			message: '服务器内部错误',
			error: error.message
		});
	}
});


module.exports = router;
