const express = require('express');
const router = express.Router();
const axios = require('axios'); 


// 图片代理接口
router.get('/download_image', async (req, res) => {
    const url = req.query.url;
    if (!url) {
        return res.status(400).send({
            code: 400,
            msg: '缺少图片URL参数',
            data: null
        });
    }

    try {
        // 拉取远程图片
        const response = await axios.get(url, { 
            responseType: 'stream',
            timeout: 10000,
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
        });

        // 设置响应头
        res.setHeader('Content-Type', response.headers['content-type'] || 'image/jpeg');
        
        // 管道流输出图片内容
        response.data.pipe(res);

    } catch (error) {
        console.error('图片下载失败:', error);
        if (!res.headersSent) {
            res.status(500).send({
                code: 500,
                msg: '图片下载失败',
                error: error.message
            });
        }
    }
});

module.exports = router;