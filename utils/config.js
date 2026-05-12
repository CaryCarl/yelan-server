
module.exports = {
    //上传文件位置
    fileSite: "public",
    //上传name
    fileName: "file",
    //文件host
    fileHost: "http://127.0.0.1:3000",

    // 腾讯云 COS 配置
    cos: {
        SecretId: process.env.COS_SECRET_ID,// 腾讯云API密钥ID 
        SecretKey: process.env.COS_SECRET_KEY,// 腾讯云API密钥Key 
        Region: process.env.COS_REGION,// 存储桶地域，如华东-上海 
        Bucket: process.env.COS_BUCKED,// 存储桶名称
    },
    oss:{
        region: 'oss-cn-shanghai',
        accessKeyId: "",
        accessKeySecret: "",
        bucket: ""
    },
    // 微信配置
    wxConfig: {
        appId: 'wx65ede331cd1aadbc',
        appSecret: '221b2a16a5f280bf38cdb85d030226f1'
    }
}
