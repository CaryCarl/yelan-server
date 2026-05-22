const express = require('express');
const router = express.Router();
const utils = require("../../../utils/index.js");
const querySql = require("../../../utils/query.js");
// 分页随机查询图片列表
router.post("/get_random_images", async (req, res) => {
    try {
        const {
            category_id,
            tags_id,
            pageNumber = 1,
            pageSize = 10,
            status = 1
        } = req.body;
        // 参数校验
        if (pageNumber < 1 || pageSize < 1) {
            return res.status(400).send({
                code: 400,
                msg: "分页参数错误"
            });
        }

        // 构建基础SQL查询
        let sql = `SELECT * FROM wallpaper_image_group WHERE status = ?`;
        let countSql = `SELECT COUNT(*) as total FROM wallpaper_image_group WHERE status = ?`;
        let params = [status];
        
        // 添加分类过滤条件
        if (category_id) {
            sql += ` AND category_id = ?`;
            countSql += ` AND category_id = ?`;
            params.push(category_id);
        }
        
        // 添加标签过滤条件
        if (tags_id) {
            // 如果是单个标签ID
            if (!Array.isArray(tags_id)) {
                sql += ` AND FIND_IN_SET(?, tags_id)`;
                countSql += ` AND FIND_IN_SET(?, tags_id)`;
                params.push(tags_id);
            } 
            // 如果是多个标签ID数组
            else if (tags_id.length > 0) {
                const tagConditions = tags_id.map(() => `FIND_IN_SET(?, tags_id)`).join(" OR ");
                sql += ` AND (${tagConditions})`;
                countSql += ` AND (${tagConditions})`;
                params.push(...tags_id);
            }
        }
        
        // 获取总记录数
        const countResult = await querySql(countSql, params);
        const total = countResult[0].total || 0;
        
        if (total === 0) {
            return res.send({
                code: 200,
                msg: "成功",
                data: [],
                total: 0
            });
        }
        
        // 添加随机排序
        sql += ` ORDER BY RAND()`;
        
        // 添加分页
        const offset = (pageNumber - 1) * pageSize;
        sql += ` LIMIT ? OFFSET ?`;
        params.push(Number(pageSize), Number(offset));
        
        // 执行查询
        const result = await querySql(sql, params);
        
        // 处理结果
        const formattedResult = result.map(item => {
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
            msg: "成功",
            data: formattedResult,
            total
        });
        
    } catch (error) {
        console.error(`[${formatDateTime()}] 随机查询图片失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

// 获取指定标签的随机图片
router.post("/getRandomImagesByTag", async (req, res) => {
    try {
        const {
            tag_id,
            limit = 10,
            exclude_ids = []
        } = req.body;
        
        if (!tag_id) {
            return res.status(400).send({
                code: 400,
                msg: "标签ID不能为空"
            });
        }
        
        let sql = `SELECT * FROM wallpaper_image_group WHERE status = 1 AND FIND_IN_SET(?, tags_id)`;
        let params = [tag_id];
        
        // 排除已显示的图片
        if (exclude_ids.length > 0) {
            sql += ` AND id NOT IN (?)`;
            params.push(exclude_ids);
        }
        
        // 随机排序并限制数量
        sql += ` ORDER BY RAND() LIMIT ?`;
        params.push(Number(limit));
        
        const result = await querySql(sql, params);
        const formattedResult = result.map(item => utils.toCamelCase(item));
        
        res.send({
            code: 200,
            msg: "成功",
            data: formattedResult
        });
        
    } catch (error) {
        console.error(`[${formatDateTime()}] 按标签随机查询图片失败:`, error);
        res.status(500).send({
            code: 500,
            msg: "服务器内部错误"
        });
    }
});

// 获取用户收藏的随机图片
router.post("/getRandomFavorites", async (req, res) => {
    try {
        const openid = req.headers['x-wx-openid'];
        const { limit = 10 } = req.body;
        
        if (!openid) {
            return res.status(401).send({
                code: 401,
                msg: "未携带身份凭证"
            });
        }
        
        // 查询用户收藏的图片
        const sql = `
            SELECT i.* FROM wallpaper_image_group i
            INNER JOIN user_favorites f ON i.id = f.image_id
            WHERE f.user_id = ? AND f.status = 1 AND i.status = 1
            ORDER BY RAND()
            LIMIT ?
        `;
        
        const result = await querySql(sql, [openid, Number(limit)]);
        const formattedResult = result.map(item => utils.toCamelCase(item));
        
        res.send({
            code: 200,
            msg: "成功",
            data: formattedResult
        });
        
    } catch (error) {
        console.error(`[${formatDateTime()}] 随机查询收藏图片失败:`, error);
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