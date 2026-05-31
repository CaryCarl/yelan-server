const express = require("express")
const router = express.Router()
const pools = require("../../../utils/pools.js")
const COS = require("cos-nodejs-sdk-v5")
const config = require("../../../utils/config.js")

// 腾讯云COS客户端配置
const cos = new COS(config.cos);
const Bucket = config.cos.Bucket;

/**
 * 删除图片接口
 * 
 * 功能：
 * 1. 根据图片ID删除wallpaper_image_group表中的图片记录
 * 2. 同时删除wallpaper_image_to_tags表中的关联记录
 * 3. 可选：从腾讯云COS存储中删除图片文件
 */
router.post("/delete_images", async (req, res) => {
    try {
        const { imageIds, deleteFiles = false } = req.body;
        
        // 参数验证
        if (!imageIds || !Array.isArray(imageIds) || imageIds.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "图片ID参数错误",
            });
        }

        // 1. 查询要删除的图片信息（用于可能的文件删除）
        let imageInfo = [];
        if (deleteFiles) {
            const { result } = await pools({
                sql: `SELECT id, url, file FROM wallpaper_image_group WHERE id IN (${imageIds.join(',')})`,
                val: [],
                run: true,
            });
            imageInfo = result || [];
        }

        // 2. 删除wallpaper_image_to_tags表中的关联记录
        // 分批处理，每批50条
        const batchSize = 50;
        let deletedTagsCount = 0;
        
        for (let i = 0; i < imageIds.length; i += batchSize) {
            const batch = imageIds.slice(i, i + batchSize);
            try {
                const { result } = await pools({
                    sql: `DELETE FROM wallpaper_image_to_tags WHERE image_id IN (${batch.join(',')})`,
                    val: [],
                    run: true,
                });
                deletedTagsCount += result?.affectedRows || 0;
            } catch (err) {
                console.warn(`删除标签关联批次 ${i/batchSize + 1} 失败:`, err);
                // 继续处理下一批
            }
        }

        // 3. 删除wallpaper_image_group表中的图片记录
        // 分批处理，每批50条
        let deletedImagesCount = 0;
        
        for (let i = 0; i < imageIds.length; i += batchSize) {
            const batch = imageIds.slice(i, i + batchSize);
            try {
                const { result } = await pools({
                    sql: `DELETE FROM wallpaper_image_group WHERE id IN (${batch.join(',')})`,
                    val: [],
                    run: true,
                });
                deletedImagesCount += result?.affectedRows || 0;
            } catch (err) {
                console.warn(`删除图片批次 ${i/batchSize + 1} 失败:`, err);
                // 继续处理下一批
            }
        }

        // 4. 如果需要，从腾讯云COS存储中删除图片文件
        const deletedFiles = [];
        if (deleteFiles && imageInfo.length > 0) {
            for (const image of imageInfo) {
                try {
                    // 从URL中提取COS对象键
                    const key = extractKeyFromUrl(image.url);
                    if (key) {
                        // 使用腾讯云COS SDK删除文件
                        await new Promise((resolve, reject) => {
                            cos.deleteObject({
                                Bucket,
                                Region: config.cos.Region,
                                Key: key
                            }, (err, data) => {
                                if (err) {
                                    console.warn('删除COS文件失败:', err);
                                    resolve(); // 继续处理其他文件
                                } else {
                                    deletedFiles.push(key);
                                    resolve(data);
                                }
                            });
                        });
                    }
                } catch (fileError) {
                    console.warn('处理文件删除失败:', fileError);
                    // 继续处理其他文件
                }
            }
        }

        // 返回成功响应
        return res.status(200).json({
            code: 200,
            mesg: "图片删除成功",
            data: {
                deletedImages: deletedImagesCount,
                deletedTags: deletedTagsCount,
                deletedFiles: deletedFiles.length > 0 ? deletedFiles : undefined,
            },
        });
    } catch (err) {
        console.error("处理请求时出错:", err);
        return res.status(500).json({
            code: 500,
            mesg: err.message || "服务器处理请求失败",
        });
    }
});

/**
 * 软删除图片接口
 * 
 * 功能：
 * 1. 将图片状态设置为无效（status=0），而不是物理删除
 * 2. 保留wallpaper_image_to_tags表中的关联记录
 */
router.post("/soft_delete_images", async (req, res) => {
    try {
        const { imageIds } = req.body;
        
        // 参数验证
        if (!imageIds || !Array.isArray(imageIds) || imageIds.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "图片ID参数错误",
            });
        }
        
        // 更新图片状态为无效
        const { result } = await pools({
            sql: `UPDATE wallpaper_image_group SET status = 0 WHERE id IN (${imageIds.join(',')})`,
            val: [],
            run: true,
        });
        
        // 返回成功响应
        return res.status(200).json({
            code: 200,
            mesg: "图片已标记为无效",
            data: {
                updatedImages: result?.affectedRows || 0,
            },
        });
        
    } catch (err) {
        console.error("处理请求时出错:", err);
        return res.status(500).json({
            code: 500,
            mesg: err.message || "服务器处理请求失败",
        });
    }
});

/**
 * 批量恢复软删除的图片
 * 
 * 功能：
 * 1. 将图片状态设置为有效（status=1）
 */
router.post("/restore_images", async (req, res) => {
    try {
        const { imageIds } = req.body;
        
        // 参数验证
        if (!imageIds || !Array.isArray(imageIds) || imageIds.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "图片ID参数错误",
            });
        }
        
        // 更新图片状态为有效
        const { result } = await pools({
            sql: `UPDATE wallpaper_image_group SET status = 1 WHERE id IN (${imageIds.join(',')})`,
            val: [],
            run: true,
        });
        
        // 返回成功响应
        return res.status(200).json({
            code: 200,
            mesg: "图片已恢复",
            data: {
                updatedImages: result?.affectedRows || 0,
            },
        });
        
    } catch (err) {
        console.error("处理请求时出错:", err);
        return res.status(500).json({
            code: 500,
            mesg: err.message || "服务器处理请求失败",
        });
    }
});

/**
 * 批量删除COS中的文件
 * 
 * 功能：
 * 1. 仅删除COS存储中的文件，不删除数据库记录
 */
router.post("/delete_cos_files", async (req, res) => {
    try {
        const { urls } = req.body;
        
        // 参数验证
        if (!urls || !Array.isArray(urls) || urls.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "URL参数错误",
            });
        }
        
        // 从URL中提取对象键并删除
        const results = [];
        for (const url of urls) {
            try {
                const key = extractKeyFromUrl(url);
                if (!key) {
                    results.push({ url, success: false, message: "无效的URL格式" });
                    continue;
                }
                
                // 使用腾讯云COS SDK删除文件
                await new Promise((resolve, reject) => {
                    cos.deleteObject({
                        Bucket,
                        Region: config.cos.Region,
                        Key: key
                    }, (err, data) => {
                        if (err) {
                            console.error(`删除文件失败: ${key}`, err);
                            results.push({ url, success: false, message: err.message });
                            reject(err);
                        } else {
                            console.log(`成功删除文件: ${key}`);
                            results.push({ url, success: true, key });
                            resolve(data);
                        }
                    });
                });
            } catch (error) {
                results.push({ url, success: false, message: error.message });
            }
        }
        
        // 返回成功响应
        return res.status(200).json({
            code: 200,
            mesg: "文件删除操作完成",
            data: {
                results,
                successCount: results.filter(r => r.success).length,
                failCount: results.filter(r => !r.success).length
            },
        });
        
    } catch (err) {
        console.error("处理请求时出错:", err);
        return res.status(500).json({
            code: 500,
            mesg: err.message || "服务器处理请求失败",
        });
    }
});

/**
 * 从腾讯云COS URL中提取对象键
 * @param {string} url - 图片URL
 * @returns {string|null} - COS对象键或null
 */
function extractKeyFromUrl(url) {
    if (!url) return null;
    
    try {
        // 假设URL格式为 https://bucket-name.cos.region.myqcloud.com/object-key
        // 或 https://bucket-domain/object-key
        const urlObj = new URL(url);
        
        // 移除开头的斜杠
        let key = urlObj.pathname.startsWith('/') ? urlObj.pathname.substring(1) : urlObj.pathname;
        
        // 处理可能的URL编码
        key = decodeURIComponent(key);
        
        return key;
    } catch (error) {
        console.error("URL解析失败:", url, error);
        return null;
    }
}

/**
 * 格式化日期时间
 * @returns {string} - 格式化的日期时间字符串
 */
function formatDateTime() {
    const date = new Date();
    const padZero = num => num.toString().padStart(2, '0');

    return [
        date.getFullYear(),
        padZero(date.getMonth() + 1),
        padZero(date.getDate()),
    ].join('-') + ' ' + [
        padZero(date.getHours()),
        padZero(date.getMinutes()),
        padZero(date.getSeconds())
    ].join(':');
}

module.exports = router;