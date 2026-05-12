const express = require("express")
const router = express.Router()
const pools = require("../../utils/pools.js")

async function createImageTagRelationsData({ tagId, imageIds, isNewImages = false }) {
	if (!tagId || !Array.isArray(tagId) || tagId.length === 0) {
		return {
			affected: 0,
		}
	}

	if (!imageIds || !Array.isArray(imageIds) || imageIds.length === 0) {
		throw new Error("图片ID参数错误")
	}

	const checkTagsSql = `SELECT id FROM wallpaper_image_tags WHERE id IN (${tagId.join(",")})`
	const {
		result: existingTags
	} = await pools({
		sql: checkTagsSql,
		val: [],
		run: true,
	})

	if (!existingTags || existingTags.length === 0) {
		throw new Error("未找到有效的标签ID")
	}

	const existingTagIds = existingTags.map((tag) => tag.id)
	const missingTags = tagId.filter((id) => !existingTagIds.includes(Number(id)))
	if (missingTags.length > 0) {
		throw new Error(`标签ID不存在: ${missingTags.join(", ")}`)
	}

	const checkImagesSql = `SELECT id FROM wallpaper_image_list WHERE id IN (${imageIds.join(",")})`
	const {
		result: existingImages
	} = await pools({
		sql: checkImagesSql,
		val: [],
		run: true,
	})

	if (!existingImages || existingImages.length === 0) {
		throw new Error("未找到有效的图片ID")
	}

	const existingImageIds = existingImages.map((img) => img.id)
	const missingImages = imageIds.filter((id) => !existingImageIds.includes(Number(id)))
	if (missingImages.length > 0) {
		throw new Error(`图片ID不存在: ${missingImages.join(", ")}`)
	}

	const relationValues = []
	for (const imageId of imageIds) {
		for (const tag of tagId) {
			relationValues.push([imageId, tag])
		}
	}

	if (relationValues.length === 0) {
		return {
			affected: 0,
		}
	}

	if (!isNewImages) {
		await pools({
			sql: `DELETE FROM wallpaper_image_to_tags WHERE image_id IN (${imageIds.join(",")}) AND tag_id IN (${tagId.join(",")})`,
			val: [],
			run: true,
		})
	}

	let affected = 0
	const batchSize = 50
	for (let i = 0; i < relationValues.length; i += batchSize) {
		const batch = relationValues.slice(i, i + batchSize)
		const placeholders = batch.map(() => "(?, ?)").join(", ")
		const sql = `INSERT INTO wallpaper_image_to_tags (image_id, tag_id) VALUES ${placeholders}`
		const {
			result
		} = await pools({
			sql,
			val: batch.flat(),
			run: true,
		})
		affected += result?.affectedRows || 0
	}

	const updateImagesSql = isNewImages
		? `UPDATE wallpaper_image_list SET tags_id = ? WHERE id IN (${imageIds.join(",")})`
		: `
		UPDATE wallpaper_image_list il
		SET tags_id = (
			SELECT GROUP_CONCAT(tag_id)
			FROM wallpaper_image_to_tags it
			WHERE it.image_id = il.id
			GROUP BY it.image_id
		)
		WHERE id IN (${imageIds.join(",")})
	`
	await pools({
		sql: updateImagesSql,
		val: isNewImages ? [tagId.join(",")] : [],
		run: true,
	})

	return {
		affected,
	}
}


/**
 * 图片上传与标签关联API
 *
 * 功能：
 * 2. 批量插入图片数据到wallpaper_image_list表
 * 3. 创建图片与标签的关联关系到wallpaper_image_to_tags表
 */
router.post("/create_image", async (req, res) => {
	const obj = req.body
	const wxOpenid = req.headers["x-wx-openid"]

	try {
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

		// 1. 验证输入数据
		const {
			title,
			categoryId,
			categoryName,
			tagId,
			file,
			status,
			imagesUrl,
			isWebp
		} = obj

		if (!file) {
			return res.status(400).json({
				code: 400,
				mesg: "文件路径不能为空",
			})
		}

		if (!imagesUrl || !Array.isArray(imagesUrl) || imagesUrl.length === 0) {
			return res.status(400).json({
				code: 400,
				mesg: "图片URL列表不能为空",
			})
		}

		if (tagId && (!Array.isArray(tagId) || tagId.length === 0)) {
			return res.status(400).json({
				code: 400,
				mesg: "标签ID格式不正确",
			})
		}

		try {
			let relationResult = {
				affected: 0,
			}

			// 4. 构建图片数据并插入
			const imageValues = imagesUrl.map((url) => [
				title || "",
				categoryId || null,
				categoryName || "",
				tagId && Array.isArray(tagId) ? tagId.join(",") : "",
				new Date().toISOString(),
				file,
				status !== undefined ? status : true,
				url,
				isWebp,
				imagesUrl.length || 10
			])

			const placeholders = imageValues.map(() => "(?, ?, ?, ?, ?, ?, ?, ?, ?,?)").join(", ")
			const imageSql = `
				INSERT INTO wallpaper_image_list 
				(title, category_id, category_name, tags_id, creation_time, file, status, url, is_webp, group_images_total) 
				VALUES ${placeholders}
			`

			const {result} = await pools({
				sql: imageSql,
				val: imageValues.flat(),
				run: true,
			})

			// 5. 获取插入的图片ID并验证
			const firstInsertId = result?.insertId
			if (!firstInsertId) {
				throw new Error("无法获取插入的图片ID")
			}

			// 验证插入是否成功
			const insertedImageIds = []
			for (let i = 0; i < imagesUrl.length; i++) {
				insertedImageIds.push(firstInsertId + i)
			}

			// 验证插入的记录
			const verifySQL = `SELECT COUNT(*) as count FROM wallpaper_image_list WHERE id IN (${insertedImageIds.join(',')})`
			const {result: verifyResult} = await pools({
				sql: verifySQL,
				val: [],
				run: true,
			})

			if (!verifyResult || verifyResult[0].count !== imagesUrl.length) {
				throw new Error("图片数据插入验证失败")
			}

			if (tagId && Array.isArray(tagId) && tagId.length > 0) {
				relationResult = await createImageTagRelationsData({
					tagId,
					imageIds: insertedImageIds,
					isNewImages: true,
				})
			}

			// 8. 返回成功响应
			return res.status(200).json({
				code: 200,
				mesg: "图片上传成功",
				data: {
					imageIds: insertedImageIds,
					tagId: tagId,
					relationAffected: relationResult.affected,
					count: insertedImageIds.length,
				},
			})
		} catch (error) {
			throw error
		}
	} catch (err) {
		console.error("处理请求时出错:", err)
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		})
	}
})

// 创建图片关联
router.post("/create_image_tagRelations", async (req, res) => {
    try {
        let {tagId, imageIds} = req.body

        // 参数验证
        if (!tagId || !Array.isArray(tagId) || tagId.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "标签ID参数错误",
            })
        }

        if (!imageIds || !Array.isArray(imageIds) || imageIds.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "图片ID参数错误",
            })
        }

        const relationResult = await createImageTagRelationsData({
            tagId,
            imageIds,
        })

        return res.status(200).json({
            code: 200,
            mesg: "图片关联成功",
            data: {
                affected: relationResult.affected,
                imageIds: imageIds,
                tagIds: tagId
            },
        })
    } catch (err) {
        console.error("处理请求时出错:", err)
        return res.status(500).json({
            code: 500,
            mesg: err.message || "服务器处理请求失败",
        })
    }
});

// 删除图片与标签关联
router.post("/delete_image_tagRelations", async (req, res) => {
    try {
        const { tagId, imageIds } = req.body
        
        // 参数验证
        if (!tagId || !Array.isArray(tagId) || tagId.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "标签ID参数错误",
            })
        }
        
        if (!imageIds || !Array.isArray(imageIds) || imageIds.length === 0) {
            return res.status(400).json({
                code: 400,
                mesg: "图片ID参数错误",
            })
        }
        
        // 开始事务
        await pools({
            sql: "START TRANSACTION",
            val: [],
            run: true,
        })
        
        try {
            // 1. 删除关联记录
            const deleteSql = `
                DELETE FROM wallpaper_image_to_tags 
                WHERE image_id IN (${imageIds.join(',')}) 
                AND tag_id IN (${tagId.join(',')})
            `
            
            const { result } = await pools({
                sql: deleteSql,
                val: [],
                run: true,
            })
            
            // 2. 更新wallpaper_image_list表中的tags_id字段
            for (const imageId of imageIds) {
                // 获取图片当前的所有标签
                const { result: currentTagsResult } = await pools({
                    sql: `
                        SELECT GROUP_CONCAT(tag_id) as all_tags
                        FROM wallpaper_image_to_tags 
                        WHERE image_id = ?
                        GROUP BY image_id
                    `,
                    val: [imageId],
                    run: true,
                })
                
                // 更新wallpaper_image_list表
                if (currentTagsResult && currentTagsResult.length > 0) {
                    await pools({
                        sql: "UPDATE wallpaper_image_list SET tags_id = ? WHERE id = ?",
                        val: [currentTagsResult[0].all_tags, imageId],
                        run: true,
                    })
                } else {
                    // 如果没有标签了，设置为空字符串
                    await pools({
                        sql: "UPDATE wallpaper_image_list SET tags_id = '' WHERE id = ?",
                        val: [imageId],
                        run: true,
                    })
                }
            }
            
            // 提交事务
            await pools({
                sql: "COMMIT",
                val: [],
                run: true,
            })
            
            return res.status(200).json({
                code: 200,
                mesg: "图片标签关联删除成功",
                data: {
                    affected: result?.affectedRows || 0,
                    imageIds: imageIds,
                    tagIds: tagId
                },
            })
        } catch (error) {
            // 如果过程中出错，回滚事务
            await pools({
                sql: "ROLLBACK",
                val: [],
                run: true,
            })
            throw error
        }
    } catch (err) {
        console.error("处理请求时出错:", err)
        return res.status(500).json({
            code: 500,
            mesg: err.message || "服务器处理请求失败",
        })
    }
});

module.exports = router