const express = require('express');
const axios = require('axios');
const router = express.Router();
const querySql = require("../../utils/query.js");
const config = require("../../utils/config.js");

// 微信配置
const wxConfig = config.wxConfig;


// 查询第三方解析接口，重新封装返回数据
router.get("/get_analysis", async (req, res) => {
	try {
		const { url } = req.query;

		if (!url) {
			return res.send({
				code: 400,
				msg: '请提供需要解析的URL',
				data: null
			});
		}

		// 请求第三方解析接口
		const response = await axios.get(`https://hzapi.hlyphp.top/Watermark/Index`, {
			params: {
				appid: '6830804acf26a892gIgzX',
				url: url
			}
		});

		// 重新封装返回数据
		let data = response?.data?.data;
		let temp = {
			code: response?.data?.code,
			message: response?.data?.msg,
			data: {
				title: data?.title || '',
				link: data?.link || '',
				cover: data?.imageSrc || '',
				imageAtlas: data?.imageAtlas || [],
				videoSrc: data?.videoSrc || '',
				videoUrl: data?.videourl || '',
				state: data?.state || '',
				description: data?.description || '',
			}
		};
		res.send(temp);

	} catch (error) {
		console.error('解析失败:', error);
		res.send({
			code: 500,
			msg: '解析服务异常',
			error: error.message
		});
	}
});

// 微信登录接口
// 小程序信息后续替换为请求头传入的appid
router.post('/login', async (req, res) => {
	try {
		const {
			code,
			userInfo
		} = req.body;
		if (!code) return res.send({
			code: 400,
			msg: '缺少Code参数',
		});

		const wxUrl =
			`https://api.weixin.qq.com/sns/jscode2session?appid=${wxConfig.appId}&secret=${wxConfig.appSecret}&js_code=${code}&grant_type=authorization_code`;
		const wxResponse = await axios.get(wxUrl);
		const {
			openid,
			session_key,
			unionid
		} = wxResponse.data;

		if (!openid) return res.send({
			code: 500,
			msg: '微信登录失败',
		});

		// 3. 查询/创建用户
		const queryUsersSql = 'SELECT * FROM wx_users WHERE openid = ?';
		const queryAdminSql = 'SELECT id FROM wx_admin_users WHERE openid = ? LIMIT 1';
		const insertSql = `INSERT INTO wx_users SET ?`;
		const updateSql = `UPDATE wx_users SET session_key = ?, updated_at = ? WHERE openid = ?`;

		// 查询用户是否存在
		const [user] = await querySql(queryUsersSql, [openid]);

		if (!user) {
			// 创建新用户
			const newUser = {
				openid,
				unionid,
				session_key,
				nickname: userInfo?.nickName,
				avatar_url: userInfo?.avatarUrl,
				gender: userInfo?.gender,
				country: userInfo?.country,
				province: userInfo?.province,
				city: userInfo?.city
			};
			await querySql(insertSql, newUser);
		} else {
			// 更新会话密钥
			await querySql(updateSql, [session_key, formatDateTime(), openid]);
		}

		const [adminUser] = await querySql(queryAdminSql, [openid]);
		const isAdmin = !!adminUser;

		res.send({
			code: 200,
			msg: '成功',
			data: {
				openid,
				nickname: user?.nickname || userInfo?.nickName || "微信用户",
				avatarUrl: user?.avatar_url || userInfo?.avatarUrl || '',
				isAdmin
			},
		});

	} catch (error) {
		console.error('登录失败:', error);
		res.send({
			code: 500,
			msg: '登录服务异常',
			error
		});
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

// 获取用户信息
router.get("/get_user_info", async (req, res) => {
	try {
		const { openid } = req.query;

		if (!openid) {
			return res.send({
				code: 400,
				msg: '缺少openid参数',
				data: null
			});
		}

		const sql = 'SELECT openid, nickname, avatar_url, gender, country, province, city, created_at, updated_at FROM wx_users WHERE openid = ?';
		const [userInfo] = await querySql(sql, [openid]);

		if (!userInfo) {
			return res.send({
				code: 404,
				msg: '用户不存在',
				data: null
			});
		}

		res.send({
			code: 200,
			msg: '查询成功',
			data: userInfo
		});

	} catch (error) {
		console.error('获取用户信息失败:', error);
		res.send({
			code: 500,
			msg: '查询失败',
			error: error.message
		});
	}
});

// 更新用户信息
router.post("/update_user_info", async (req, res) => {
	try {
		const { openid, nickname, avatar_url } = req.body;

		if (!openid) {
			return res.send({
				code: 400,
				msg: '缺少openid参数',
				data: null
			});
		}

		if (!nickname && !avatar_url) {
			return res.send({
				code: 400,
				msg: '请提供要更新的信息',
				data: null
			});
		}

		// 构建更新数据
		const updateData = {};
		if (nickname) updateData.nickname = nickname;
		if (avatar_url) updateData.avatar_url = avatar_url;
		updateData.updated_at = formatDateTime();

		// 检查用户是否存在
		const checkSql = 'SELECT id FROM wx_users WHERE openid = ?';
		const [user] = await querySql(checkSql, [openid]);

		if (!user) {
			return res.send({
				code: 404,
				msg: '用户不存在',
				data: null
			});
		}

		// 更新用户信息
		const updateSql = 'UPDATE wx_users SET ? WHERE openid = ?';
		await querySql(updateSql, [updateData, openid]);

		res.send({
			code: 200,
			msg: '更新成功',
			data: null
		});

	} catch (error) {
		console.error('更新用户信息失败:', error);
		res.send({
			code: 500,
			msg: '更新失败',
			error: error.message
		});
	}
});
module.exports = router;