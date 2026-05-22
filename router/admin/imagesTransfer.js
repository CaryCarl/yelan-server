const express = require('express');
const router = express.Router();
const path = require('path');
const fs = require('fs');
const COS = require('cos-nodejs-sdk-v5');
const querySql = require("../utils/query.js");
const multer = require('multer');
const crypto = require('crypto');
const https = require('https');
const http = require('http');
const { URL } = require('url');
const utils = require("../utils/index.js");

// 配置 multer 用于处理文件上传
const upload = multer({
	dest: 'uploads/'
}); // 文件暂存目录

// 图片中转
/**
 * 将小红书等链接的图片下载并上传到云存储
 */
router.post('/imagesTransferCOS', async (req, res) => {
	try {
		const { url, appid } = req.body;

		if (!url) {
			return res.json(utils.returnData({ code: 400, msg: "缺少url参数" }));
		}

		if (!appid) {
			return res.json(utils.returnData({ code: 400, msg: "缺少appid参数" }));
		}

		// 1. 查询云存储配置
		const configSql = `SELECT secret_id, secret_key, region, bucket
			FROM cloud_config
			WHERE appid = ? AND operator = 'tencent' AND config_type = 'cos' AND status = 1
			LIMIT 1`;
		const configResult = await querySql(configSql, [appid]);

		if (!configResult || configResult.length === 0) {
			return res.json(utils.returnData({ code: 500, msg: "未找到可用的云存储配置" }));
		}
		const cosConfig = utils.toCamelCase(configResult[0]);

		// 2. 初始化COS实例
		const cosClient = new COS({
			SecretId: cosConfig.secretId,
			SecretKey: cosConfig.secretKey,
			Region: cosConfig.region
		});

		// 3. 请求解析接口获取图片列表
		const parseResult = await requestPost('https://www.caiyundao123.com/api/url/parse', { url });

		if (!parseResult || parseResult.status !== 200 || !parseResult.data || !parseResult.data.pics) {
			return res.json(utils.returnData({ code: 500, msg: "解析链接失败", data: parseResult }));
		}

		const pics = parseResult.data.pics;
		const uploadedUrls = [];

		// 4. 遍历下载并上传每张图片
		for (const picUrl of pics) {
			try {
				const uploadedUrl = await downloadAndUploadToCos(cosClient, cosConfig, picUrl, 'test1');
				uploadedUrls.push(uploadedUrl);
			} catch (err) {
				console.error(`[${utils.formatDateTime()}] 上传图片失败: ${picUrl}`, err);
			}
		}

		// 5. 返回结果
		return res.json(utils.returnData({
			data: {
				originalData: parseResult.data,
				uploadedUrls: uploadedUrls,
				totalCount: pics.length,
				successCount: uploadedUrls.length
			}
		}));

	} catch (error) {
		console.error(`[${utils.formatDateTime()}] 图片中转失败:`, error);
		return res.json(utils.returnData({ code: 500, msg: "图片中转失败", err: error.message }));
	}
});

/**
 * 发送POST请求
 */
function requestPost(url, data) {
	return new Promise((resolve, reject) => {
		const urlObj = new URL(url);
		const isHttps = urlObj.protocol === 'https:';
		const client = isHttps ? https : http;

		const options = {
			hostname: urlObj.hostname,
			port: urlObj.port || (isHttps ? 443 : 80),
			path: urlObj.pathname,
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
				'Content-Length': Buffer.byteLength(JSON.stringify(data))
			}
		};

		const req = client.request(options, (res) => {
			let chunks = [];
			res.on('data', (chunk) => chunks.push(chunk));
			res.on('end', () => {
				try {
					const result = JSON.parse(Buffer.concat(chunks).toString());
					resolve(result);
				} catch (e) {
					reject(e);
				}
			});
		});

		req.on('error', reject);
		req.write(JSON.stringify(data));
		req.end();
	});
}

/**
 * 下载图片并上传到COS
 */
function downloadAndUploadToCos(cosClient, cosConfig, imageUrl, folder) {
	return new Promise((resolve, reject) => {
		const urlObj = new URL(imageUrl);
		const isHttps = urlObj.protocol === 'https:';
		const client = isHttps ? https : http;

		const options = {
			hostname: urlObj.hostname,
			port: urlObj.port || (isHttps ? 443 : 80),
			path: urlObj.pathname,
			method: 'GET',
			headers: {
				'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
			}
		};

		const req = client.request(options, (res) => {
			// 检查重定向
			if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
				downloadAndUploadToCos(cosClient, cosConfig, res.headers.location, folder)
					.then(resolve)
					.catch(reject);
				return;
			}

			if (res.statusCode !== 200) {
				reject(new Error(`下载失败，状态码: ${res.statusCode}`));
				return;
			}

			const chunks = [];
			res.on('data', (chunk) => chunks.push(chunk));
			res.on('end', () => {
				const buffer = Buffer.concat(chunks);
				const ext = getFileExt(imageUrl) || '.jpg';
				const fileName = `${Date.now()}_${crypto.randomBytes(8).toString('hex')}${ext}`;
				const cosPath = `${folder}/${fileName}`;

				cosClient.putObject({
					Bucket: cosConfig.bucket,
					Key: cosPath,
					Region: cosConfig.region,
					Body: buffer,
					ContentLength: buffer.length
				}, (err, data) => {
					if (err) {
						reject(err);
					} else {
						resolve(`https://${cosConfig.bucket}.cos.${cosConfig.region}.myqcloud.com/${cosPath}`);
					}
				});
			});
		});

		req.on('error', reject);
		req.end();
	});
}

/**
 * 获取文件扩展名
 */
function getFileExt(url) {
	try {
		const urlObj = new URL(url);
		const pathname = urlObj.pathname;
		const lastDot = pathname.lastIndexOf('.');
		if (lastDot !== -1 && lastDot < pathname.length - 1) {
			return pathname.substring(lastDot);
		}
		// 从Content-Type推断
		return null;
	} catch {
		return null;
	}
}


module.exports = router;