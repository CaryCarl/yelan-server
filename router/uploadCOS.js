const express = require('express');
const router = express.Router();
const path = require('path');
const fs = require('fs');
const COS = require('cos-nodejs-sdk-v5');
const pools = require("../utils/pools.js")

const multer = require('multer');
const crypto = require('crypto');
const config = require("../utils/config.js")

const cos = new COS({
	SecretId: config.cos.SecretId, // 腾讯云API密钥ID 
	SecretKey: config.cos.SecretKey, // 腾讯云API密钥Key 
	Region: config.cos.Region // 存储桶地域，如华东-上海 
});
// 配置 multer 用于处理文件上传
const upload = multer({
	dest: 'uploads/'
}); // 文件暂存目录

/**
 * 图片分组--------------------------
 */
router.post("/uploadCOS", upload.single('file'), async (req, res) => {
	try {
	    const wxOpenid = req.headers["x-wx-openid"]
	    if (!wxOpenid) {
			return res.status(401).json({
				code: 401,
				mesg: "缺少x-wx-openid请求头",
			})
		}

		const {
			result: adminResult
		} = await pools({
			sql: "SELECT id FROM wx_admin_users WHERE openid = ? LIMIT 1",
			val: [String(wxOpenid).trim()],
			run: true,
		})

		if (!adminResult || adminResult.length === 0) {
			return res.status(403).json({
				code: 403,
				mesg: "无上传权限",
			})
		}
		const file = req.file; // 前端上传的文件

		if (!file) {
			return res.status(400).json({
				success: false,
				message: '未上传文件'
			});
		}
		// 生成新的文件名
		const newFileName = generateRandomFileName(file.originalname);

		// 构造 OSS 文件路径
		const ossFilePath = path.join(req.query.filePath, newFileName).replace(/\\/g, '/');

		// 腾讯云COS上传 
		const result = await cos.putObject({
			Bucket: config.cos.Bucket, // 格式：<BucketName>-<APPID>
			Key: ossFilePath,
			Region: config.cos.Region,
			Body: fs.createReadStream(file.path)  // 文件流上传 
		});

		// 返回成功响应
		res.json({
			success: true,
			message: '文件上传成功',
			data: {
				url: 'https://' + result.Location, // 文件的访问 URL
				name: result.name, // 文件的 OSS 路径
				originalName: file.originalname,
				newFileName,
				filePath: req.query.filePath,
				result: result
			},
		});

	} catch (error) {
		console.error('文件上传失败:', error);
		res.status(500).json({
			success: false,
			message: '文件上传失败',
			error: error.message
		});
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