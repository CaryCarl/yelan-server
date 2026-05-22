const express = require('express');
const router = express.Router();
const path = require('path');
const fs = require('fs');
const COS = require('cos-nodejs-sdk-v5');
const querySql = require("../utils/query.js");
const multer = require('multer');
const crypto = require('crypto');
const utils = require("../utils/index.js");

// 配置 multer 用于处理文件上传
const upload = multer({
	dest: 'uploads/'
}); // 文件暂存目录

/**
 * 图片分组--------------------------
 */
router.post("/uploadCOS", upload.single('file'), async (req, res) => {
	try {
		const { openid, appid } = req.body;

		if (!openid) {
			return res.json(utils.returnData({ code: 400, msg: "缺少openid参数" }));
		}

		if (!appid) {
			return res.json(utils.returnData({ code: 400, msg: "缺少appid参数" }));
		}

		// 1. 查询用户是否有管理员权限
		const userSql = "SELECT id, can_upload, status FROM wx_admin_users WHERE openid = ? LIMIT 1";
		const userResult = await querySql(userSql, [openid]);

		if (!userResult || userResult.length === 0) {
			return res.json(utils.returnData({ code: 403, msg: "无上传权限，用户不存在" }));
		}

		const userInfo = userResult[0];

		// 2. 检查用户上传权限状态
		if (userInfo.can_upload !== 1 || userInfo.status !== 1) {
			return res.json(utils.returnData({ code: 403, msg: "无上传权限" }));
		}

		// 3. 从cloud_config表查询对应的appid配置
		const configSql = `SELECT secret_id, secret_key, region, bucket
			FROM cloud_config
			WHERE appid = ? AND operator = 'tencent' AND config_type = 'cos' AND status = 1
			LIMIT 1`;
		const configResult = await querySql(configSql, [appid]);

		if (!configResult || configResult.length === 0) {
			return res.json(utils.returnData({ code: 500, msg: "未找到可用的云存储配置" }));
		}
		const cosConfig = utils.toCamelCase(configResult[0]);

		// 4. 初始化COS实例
		const cosClient = new COS({
			SecretId: cosConfig.secretId,
			SecretKey: cosConfig.secretKey,
			Region: cosConfig.region
		});

		const file = req.file; // 前端上传的文件

		if (!file) {
			return res.json(utils.returnData({ code: 400, msg: "未上传文件" }));
		}

		// 5. 生成新的文件名
		const newFileName = generateRandomFileName(file.originalname);

		// 6. 构造 COS 文件路径
		const cosFilePath = path.join(req.query.filePath || 'uploads', newFileName).replace(/\\/g, '/');

		// 7. 腾讯云COS上传
		const result = await cosClient.putObject({
			Bucket: cosConfig.bucket,
			Key: cosFilePath,
			Region: cosConfig.region,
			Body: fs.createReadStream(file.path) // 文件流上传
		});

		// 8. 清理临时文件
		fs.unlink(file.path, (err) => {
			if (err) console.error('删除临时文件失败:', err);
		});

		// 9. 返回成功响应
		return res.json(utils.returnData({
			data: {
				url: 'https://' + result.Location,
				name: result.name,
				originalName: file.originalname,
				newFileName,
				filePath: req.query.filePath,
				appid: appid
			}
		}));

	} catch (error) {
		console.error(`[${utils.formatDateTime()}] 文件上传失败:`, error);
		return res.json(utils.returnData({ code: 500, msg: "文件上传失败", err: error.message }));
	}
});

// 生成随机文件名
function generateRandomFileName(originalName) {
	const ext = path.extname(originalName); // 获取文件扩展名
	const randomString = crypto.randomBytes(8).toString('hex'); // 生成随机字符串
	const timestamp = Date.now(); // 获取当前时间戳
	return `${timestamp}_${randomString}${ext}`; // 组合成新文件名
}


module.exports = router;