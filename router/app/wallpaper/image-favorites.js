const express = require('express');
const router = express.Router();
const utils = require("../../../utils/index.js");
const querySql = require("../../../utils/query.js");

/**
 * 查询图片是否被当前用户收藏
 * 请求参数: image_id - 图片ID 或 image_url - 图片URL
 * 返回: { collected: true/false, image_id: 图片ID }
 */
router.post('/checkImageFavorite', async (req, res) => {
    try {
        // 获取用户身份和图片参数
        const openid = req.headers['x-wx-openid'];
        const { image_id, image_url } = req.body;

        // 参数校验
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }

        // 至少需要提供image_id或image_url中的一个
        if (!image_id && !image_url) {
            return res.status(400).send({
                code: 400,
                msg: "请提供图片ID或图片URL"
            });
        }

        let targetImageId = null;

        // 如果提供了image_id，直接使用
        if (image_id && !isNaN(image_id)) {
            targetImageId = image_id;
        } 
        // 如果提供了image_url，先查询对应的image_id
        else if (image_url) {
            const [imageInfo] = await querySql(
                `SELECT id FROM wallpaper_image_list WHERE url = ? LIMIT 1`,
                [image_url]
            );

            if (!imageInfo) {
                return res.send({
                    code: 200,
                    data: {
                        collected: false,
                        image_id: null,
                        message: "未找到对应图片"
                    },
                    msg: "查询成功"
                });
            }

            targetImageId = imageInfo.id;
        } else {
            return res.status(400).send({
                code: 400,
                msg: "图片参数格式错误"
            });
        }

        // 查询收藏状态
        const [result] = await querySql(
            `SELECT 1 FROM wallpaper_user_favorites 
             WHERE user_id = ? AND image_id = ? AND status = 1
             LIMIT 1`,
            [openid, targetImageId]
        );

        // 返回收藏状态
        res.send({
            code: 200,
            data: {
                collected: !!result, // 转换为布尔值
                image_id: targetImageId
            },
            msg: "查询成功"
        });

    } catch (error) {
        console.error(`[${formatDateTime()}] 查询收藏状态失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

/**
 * 收藏图片
 * 请求参数: image_id - 图片ID
 * 返回: 操作结果
 */
router.post('/addFavorite', async (req, res) => {
    try {
        // 获取用户身份和图片ID
        const openid = req.headers['x-wx-openid'];
        const { image_id } = req.body;

        // 参数校验
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }

        if (!image_id || isNaN(image_id)) {
            return res.status(400).send({
                code: 400,
                msg: "图片ID参数错误"
            });
        }

        // 查询当前收藏状态
        const [existingFavorite] = await querySql(
            `SELECT id, status FROM wallpaper_user_favorites 
             WHERE user_id = ? AND image_id = ?`,
            [openid, image_id]
        );

        let isNewFavorite = false;

        if (!existingFavorite) {
            // 新增收藏记录
            await querySql(
                `INSERT INTO wallpaper_user_favorites (user_id, image_id, create_time, status) 
                 VALUES (?, ?, NOW(), 1)`,
                [openid, image_id]
            );
            isNewFavorite = true;
        } else if (existingFavorite.status === 0) {
            // 更新已存在但被取消的收藏记录
            await querySql(
                `UPDATE wallpaper_user_favorites 
                 SET status = 1, create_time = NOW() 
                 WHERE id = ?`,
                [existingFavorite.id]
            );
            isNewFavorite = true;
        } else {
            // 已经收藏过，不需要操作
            return res.send({
                code: 200,
                data: {
                    collected: true,
                    message: "图片已经在收藏中"
                },
                msg: "操作成功"
            });
        }

        // 如果是新收藏，更新图片收藏数量
        if (isNewFavorite) {
            await querySql(
                `UPDATE wallpaper_image_list 
                 SET favorite_count = favorite_count + 1 
                 WHERE id = ?`,
                [image_id]
            );
        }

        // 返回操作结果
        res.send({
            code: 200,
            data: {
                collected: true,
                message: "收藏成功"
            },
            msg: "操作成功"
        });

    } catch (error) {
        console.error(`[${formatDateTime()}] 收藏图片失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

/**
 * 取消收藏图片
 * 请求参数: image_id - 图片ID
 * 返回: 操作结果
 */
router.post('/removeFavorite', async (req, res) => {
    try {
        // 获取用户身份和图片ID
        const openid = req.headers['x-wx-openid'];
        const { image_id } = req.body;

        // 参数校验
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }

        if (!image_id || isNaN(image_id)) {
            return res.status(400).send({
                code: 400,
                msg: "图片ID参数错误"
            });
        }

        // 查询当前收藏状态
        const [existingFavorite] = await querySql(
            `SELECT id, status FROM wallpaper_user_favorites 
             WHERE user_id = ? AND image_id = ?`,
            [openid, image_id]
        );

        // 如果没有收藏记录或已经取消，直接返回
        if (!existingFavorite || existingFavorite.status === 0) {
            return res.send({
                code: 200,
                data: {
                    collected: false,
                    message: "图片未收藏"
                },
                msg: "操作成功"
            });
        }

        // 更新收藏状态为取消(0)
        await querySql(
            `UPDATE wallpaper_user_favorites 
             SET status = 0 
             WHERE id = ?`,
            [existingFavorite.id]
        );

        // 更新图片收藏数量
        await querySql(
            `UPDATE wallpaper_image_list 
             SET favorite_count = GREATEST(favorite_count - 1, 0) 
             WHERE id = ?`,
            [image_id]
        );

        // 返回操作结果
        res.send({
            code: 200,
            data: {
                collected: false,
                message: "取消收藏成功"
            },
            msg: "操作成功"
        });

    } catch (error) {
        console.error(`[${formatDateTime()}] 取消收藏图片失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

/**
 * 切换图片收藏状态（收藏/取消收藏）
 * 请求参数: image_id - 图片ID
 * 返回: 操作后的收藏状态
 */
router.post('/toggleImageFavorite', async (req, res) => {
    try {
        // 获取用户身份和图片ID
        const openid = req.headers['x-wx-openid'];
        const { image_id } = req.body;

        // 参数校验
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }

        if (!image_id || isNaN(image_id)) {
            return res.status(400).send({
                code: 400,
                msg: "图片ID参数错误"
            });
        }

        // 查询当前收藏状态
        const [existingFavorite] = await querySql(
            `SELECT id, status FROM wallpaper_user_favorites 
             WHERE user_id = ? AND image_id = ?`,
            [openid, image_id]
        );

        let newStatus = false;

        if (!existingFavorite) {
            // 新增收藏记录
            await querySql(
                `INSERT INTO wallpaper_user_favorites (user_id, image_id, create_time, status) 
                 VALUES (?, ?, NOW(), 1)`,
                [openid, image_id]
            );
            
            // 更新图片收藏数量 +1
            await querySql(
                `UPDATE wallpaper_image_list 
                 SET favorite_count = favorite_count + 1 
                 WHERE id = ?`,
                [image_id]
            );
            
            newStatus = true;
        } else if (existingFavorite.status === 0) {
            // 更新已存在但被取消的收藏记录
            await querySql(
                `UPDATE wallpaper_user_favorites 
                 SET status = 1, create_time = NOW() 
                 WHERE id = ?`,
                [existingFavorite.id]
            );
            
            // 更新图片收藏数量 +1
            await querySql(
                `UPDATE wallpaper_image_list 
                 SET favorite_count = favorite_count + 1 
                 WHERE id = ?`,
                [image_id]
            );
            
            newStatus = true;
        } else {
            // 取消收藏
            await querySql(
                `UPDATE wallpaper_user_favorites 
                 SET status = 0 
                 WHERE id = ?`,
                [existingFavorite.id]
            );
            
            // 更新图片收藏数量 -1
            await querySql(
                `UPDATE wallpaper_image_list 
                 SET favorite_count = GREATEST(favorite_count - 1, 0) 
                 WHERE id = ?`,
                [image_id]
            );
            
            newStatus = false;
        }

        // 返回操作结果
        res.send({
            code: 200,
            data: {
                collected: newStatus,
                message: newStatus ? "收藏成功" : "取消收藏成功"
            },
            msg: "操作成功"
        });

    } catch (error) {
        console.error(`[${formatDateTime()}] 切换收藏状态失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

/**
 * 获取用户收藏的图片列表
 * 请求参数: pageNumber, pageSize
 * 返回: 收藏图片列表和总数
 */
router.post('/getUserFavorites', async (req, res) => {
    try {
        // 获取用户身份和分页参数
        const openid = req.headers['x-wx-openid'];
        const { pageNumber = 1, pageSize = 10 } = req.body;

        // 参数校验
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }

        if (pageNumber < 1 || pageSize < 1) {
            return res.status(400).send({
                code: 400,
                msg: "分页参数错误"
            });
        }

        // 计算偏移量
        const offset = (pageNumber - 1) * pageSize;

        // 查询收藏总数
        const [countResult] = await querySql(
            `SELECT COUNT(*) as total 
             FROM wallpaper_user_favorites 
             WHERE user_id = ? AND status = 1`,
            [openid]
        );
        
        const total = countResult.total || 0;

        // 如果没有收藏记录，直接返回空数组
        if (total === 0) {
            return res.send({
                code: 200,
                data: [],
                total: 0,
                msg: "查询成功"
            });
        }

        // 查询收藏的图片列表
        const favoriteImages = await querySql(
            `SELECT i.*, f.create_time as favorite_time 
             FROM wallpaper_image_list i
             INNER JOIN wallpaper_user_favorites f ON i.id = f.image_id
             WHERE f.user_id = ? AND f.status = 1 AND i.status = 1
             ORDER BY f.create_time DESC
             LIMIT ? OFFSET ?`,
            [openid, Number(pageSize), Number(offset)]
        );

        // 处理结果
        const formattedResult = favoriteImages.map(item => {
            // 转换为驼峰命名
            let camelCaseItem = utils.toCamelCase(item);
            
            // 处理标签ID字符串为数组
            if (camelCaseItem.tagsId && typeof camelCaseItem.tagsId === 'string') {
                camelCaseItem.tagsIdArray = camelCaseItem.tagsId.split(',').map(id => parseInt(id));
            } else {
                camelCaseItem.tagsIdArray = [];
            }
            
            return camelCaseItem;
        });

        // 返回结果
        res.send({
            code: 200,
            data: formattedResult,
            total,
            msg: "查询成功"
        });

    } catch (error) {
        console.error(`[${formatDateTime()}] 查询用户收藏失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

// 格式化日期时间
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