const express = require('express');
const bodyparser = require('body-parser'); //body中间件
const cors = require('cors'); //解决跨域的中间件
const utils = require("./utils/index.js");
const {
	errLog
} = require("./utils/err");
const server = express();
server.listen(3002);
server.use(cors({
	origin: "*",
}));
server.use(express.static('./public')); //用户的静态资源
server.use(bodyparser.json());
// server.use(bodyparser.urlencoded({//body中间件
// 	extended:false
// }));
server.use(async function (req, res, next) {
	if (req.headers.token) {
		let user = await utils.getUserInfo({
			req,
			res
		});
		if (user.status === 0) return res.send(utils.returnData({
			code: 203,
			msg: "你账号已被禁用，请联系管理员！！",
			req
		}));
	}
	next();
})

process.on('unhandledRejection', (err, test) => {
	errLog({
		err,
		code: 500,
		msg: "后端系统错误！",
		funName: "fatal"
	});
}).on('uncaughtException', err => {
	errLog({
		err,
		code: 500,
		msg: "后端系统错误！！",
		funName: "fatal"
	});
});
const adminRouter = require('./router/system/admin.js'); //管理菜单等路由

const xcxApi = require("./router/app/index.js");//图片分组管理
const weappConfig = require("./router/app/weappConfig.js");//图片分组管理
const uploadCOS = require("./router/uploadCOS.js");	//资料上传
// 配置管理
const systemConfig = require("./router/admin/config.js");


/**
 * 后台管理系统壁纸模块
 */
const imageList = require("./router/wallpaper/imageList.js");	//图片列表
const imgGroups = require("./router/wallpaper/imgGroups.js");	//图片列表
const imageType = require("./router/wallpaper/imageType.js");	//图片类型
const imageTags = require("./router/wallpaper/imageTags.js");	//图片标签

const imagesController = require("./router/admin/imagesController.js");	//图片列表
const imagesGroup = require("./router/admin/imagesGroup.js");	//图片分组
const albumConfig = require("./router/admin/albumConfig.js");	//专辑配置

server.use('/admin', adminRouter);




/**
 * 壁纸模块-后台管理系统
 */
server.use("/api/app/auth", xcxApi);
server.use("/api/weappConfig", weappConfig);
server.use("/api/upload", uploadCOS);


server.use("/api/wallpaper/imageList", imageList);
server.use("/api/wallpaper/imgGroups", imgGroups);
server.use("/api/wallpaper/imageType", imageType);
server.use("/api/wallpaper/imageTags", imageTags);

server.use("/api/v1/systemConfig", systemConfig);
server.use("/api/v1/imagesController",imagesController);
server.use("/api/v1/imagesGroup",imagesGroup);
server.use("/api/v1/albumConfig",albumConfig);


/**
 * 下面是小程序端接口
 */
/**
 * 小程序壁纸模块
 */
const xcxApiWallpaper = require("./router/app/wallpaper/index.js");//图片分组管理
const xcxApiImageList=require("./router/app/wallpaper/imageList.js");//图片分组管理
const randomImages=require("./router/app/wallpaper/random-images.js");//图片分组管理
const imageFavorites=require("./router/app/wallpaper/image-favorites.js");//搜藏
const download=require("./router/app/wallpaper/download_image.js");//搜藏


server.use("/api/app/wallpaper", xcxApiWallpaper);
server.use("/api/app/image",xcxApiImageList);
server.use("/api/app/randomImages",randomImages);
server.use("/api/app/imageFavorites",imageFavorites);
server.use("/api/app/download",download);



console.log('后端接口启动成功');
