const multer = require('multer');
const config = require("./config.js");
const utils = require("./index");
const OSS = require('ali-oss');

const client = new OSS({region: process.env.OSS_REGION,
    accessKeyId: process.env.OSS_ACCESS_KEY_ID,
    accessKeySecret: process.env.OSS_ACCESS_KEY_SECRET,
    bucket: process.env.OSS_BUCKET
});


//上传的文件保存在 upload
const storage = multer.diskStorage({
    //存储的位置
    destination(req, file, cb) {
        cb(null, config.fileSite);
    },
    //文件名字的确定 multer默认帮我们取一个没有扩展名的文件名，因此需要我们自己定义
    filename(req, file, cb) {
        let math = Math.random();
        math = math.toString().replace(".", "");//随机字符串
        const timestamp = +new Date();
        let suffix = file.originalname.split('.')[1]
        // cb(null, `${Date.now()}${math}-${file.originalname}`)
        cb(null, `${Date.now()}${math}-${timestamp}.${suffix}`)
    }
});
//传入storage 除了这个参数我们还可以传入dest等参数
let upload = multer({
    storage
}).array(config.fileName);
//上传总函数
let fileEvent = (req, res) => {
	console.log('req, res---', req)
    return new Promise((resolve, reject) => {
        upload(req, res, async function (err) {
            if (err) return res.send(utils.returnData({ code: -1, msg: "上传文件错误123~", req, err }));
            try {
                //循环处理
                let imgPath = [];
                for (const file of req.files) {
                    const regex = /^(.+)\.[^.]+$/;
                    const regexRes = file.originalname.match(regex);
                    let name = "";
                    if (regexRes) name = regexRes[1];

                    // 上传到OSS
                    const folderPath = req.query?.filePath ? req.query?.filePath : 'app-img/'; // 替换为你想要的文件夹路径
                    const ossFilePath = `${folderPath}${file.filename}`;

                    try {
                        const result = await client.put(ossFilePath, file.path);
                        imgPath.push({ url: result.url, name, originalname: file.originalname, filename: file.filename });
                        console.log("Uploaded to OSS:", result.url);
                    } catch (ossErr) {
                        console.error("OSS Upload Error:", ossErr);
                        return res.send(utils.returnData({ code: -1, msg: "OSS上传文件错误~", req, err: ossErr }));
                    }
                }

                resolve(imgPath)
            } catch (err) {
                res.send(utils.returnData({ code: -1, msg: "上传文件错误1~", req, err }));
            }
        });
    });
};
module.exports = fileEvent;