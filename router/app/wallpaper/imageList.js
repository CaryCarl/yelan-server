const express = require("express")
const router = express.Router()
const pools = require("../../../utils/pools.js");
const { convertDbResultToCamelCase } = require("../../../utils/camelCase.js");

/**
 * 根据标签ID分页查询图片分组列表
 * * 接口请求方法: GET
 * 接口请求路由: /get_group_list_by_tag
 * * 请求参数:
 * - tagId: 标签ID (必填)
 * - page: 当前页码 (可选，默认为 1)
 * - pageSize: 每页展示数量 (可选，默认为 10)
 */
router.get("/get_group_list_by_tag", async (req, res) => {
	try {
		// 1. 获取并验证请求参数
		const { tagId, page = 1, pageSize = 10 } = req.query;

		// 验证必填参数
		if (!tagId) {
			return res.status(400).json({
				code: 400,
				mesg: "标签ID不能为空",
			});
		}

		// 2. 处理分页参数
		const currentPage = Number.parseInt(page) || 1;
		const limit = Number.parseInt(pageSize) || 10;
		const offset = (currentPage - 1) * limit;

		if (currentPage < 1 || limit < 1) {
			return res.status(400).json({
				code: 400,
				mesg: "分页参数无效",
			});
		}

		// 3. 查询符合该标签的数据总条数
		// 结合原有的逻辑，假设只查询 status = 1 (启用状态) 的数据
		const countSql = `
			SELECT COUNT(*) AS total
			FROM wallpaper_image_group
			WHERE FIND_IN_SET(?, tags_id) > 0 AND status = 1
		`;

		const { result: countResult } = await pools({
			sql: countSql,
			val: [tagId],
			run: true,
		});

		const total = countResult[0]?.total || 0;

		// 如果没有找到数据，提前返回以减少数据库压力
		if (total === 0) {
			return res.status(200).json({
				code: 200,
				mesg: "查询成功",
				data: {
					list: [],
					pagination: {
						total: 0,
						page: currentPage,
						pageSize: limit,
						totalPages: 0,
					}
				},
			});
		}

		// 4. 查询当前页的详细列表数据
		const listSql = `
			SELECT *
			FROM wallpaper_image_group
			WHERE FIND_IN_SET(?, tags_id) > 0 AND status = 1
			ORDER BY id DESC
			LIMIT ? OFFSET ?
		`;

		const { result: listResult } = await pools({
			sql: listSql,
			val: [tagId, limit, offset],
			run: true,
		});

		// （可选）如果你需要像原有代码一样做驼峰命名转换，可以在这里将 listResult 传给 convertDbResultToCamelCase 

		// 5. 组装分页数据并返回
		const totalPages = Math.ceil(total / limit);

		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: {
				list: listResult,
				pagination: {
					total,
					page: currentPage,
					pageSize: limit,
					totalPages,
				}
			},
		});

	} catch (err) {
		console.error("根据标签查询图片分组分页列表时出错:", err);
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		});
	}
});


/**
 * 根据图片ID查询前一张图片
 *
 * 请求参数:
 * - imageId: 图片ID (必填)
 * - categoryId: 分类ID (可选)
 * - tagId: 标签ID (可选)
 */
router.get("/get_previous_image", async (req, res) => {
	try {
		// 1. 获取并验证请求参数
		const { imageId, categoryId, tagId } = req.query;

		// 验证必填参数
		if (!imageId) {
			return res.status(400).json({
				code: 400,
				mesg: "图片ID不能为空",
			});
		}

		// 2. 构建查询条件
		let queryParams = [imageId];
		let categoryCondition = "";
		let tagCondition = "";

		if (categoryId) {
			categoryCondition = " AND il.category_id = ?";
			queryParams.push(categoryId);
		}

		if (tagId) {
			tagCondition = " AND FIND_IN_SET(?, il.tags_id) > 0";
			queryParams.push(tagId);
		}

		// 3. 查询当前图片的前一张图片
		const previousImageSql = `
      SELECT DISTINCT il.id
      FROM wallpaper_image_group il
      WHERE il.id < ?${categoryCondition}${tagCondition}
      ORDER BY il.id DESC
      LIMIT 1
    `;

		console.log("SQL Query:", previousImageSql);
		console.log("Query Parameters:", queryParams);

		const { result: previousImageResult } = await pools({
			sql: previousImageSql,
			val: queryParams,
			run: true,
		});

		// 如果找到了前一张图片，查询其完整信息
		if (previousImageResult.length > 0) {
			const previousImageId = previousImageResult[0].id;
			const imageInfoSql = `
        SELECT *
        FROM wallpaper_image_group
        WHERE id = ?
      `;

			const { result: imageInfoResult } = await pools({
				sql: imageInfoSql,
				val: [previousImageId],
				run: true,
			});

			if (imageInfoResult.length > 0) {
				const imageInfo = imageInfoResult[0];
				// 转换为驼峰命名
				const camelCaseImage = {
					id: imageInfo.id,
					title: imageInfo.title,
					categoryId: imageInfo.category_id,
					creationTime: imageInfo.creation_time,
					status: imageInfo.status,
					// 添加其他字段的转换
				};

				return res.status(200).json({
					code: 200,
					mesg: "查询成功",
					data: imageInfoResult[0],
				});
			}
		}

		// 4. 如果没有找到前一张图片，返回符合条件的第一条数据
		// 3. 查询符合条件的最大图片ID
		const maxImageSql = `
            SELECT DISTINCT il.*
            FROM wallpaper_image_group il
            WHERE il.category_id = ? 
            AND FIND_IN_SET(?, il.tags_id) > 0
            ORDER BY il.id DESC
            LIMIT 1
        `;

		console.log("SQL Query:", maxImageSql);
		console.log("Query Parameters:", queryParams);

		const { result: maxImageResult } = await pools({
			sql: maxImageSql,
			val: [categoryId, tagId],
			run: true,
		});
		// 如果找到了符合条件的图片，返回结果
		if (maxImageResult.length > 0) {
			return res.status(200).json({
				code: 200,
				mesg: "查询成功",
				data: maxImageResult[0],
			});
		}
		// 如果没有找到符合条件的图片，返回空
		return res.status(200).json({
			code: 201,
			mesg: "没有找到符合条件的图片",
			data: null,
		});
	} catch (err) {
		console.error("查询前一张图片时出错:", err);
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		});
	}
});


/**
 * 根据标签ID分页查询图片列表
 *
 * 请求参数:
 * - tagId: 标签ID (必填)
 * - page: 页码，默认为1
 * - pageSize: 每页数量，默认为10
 * - sortBy: 排序字段，默认为creation_time
 * - sortOrder: 排序方式，asc或desc，默认为desc
 */
router.get("/get_images_by_tag", async (req, res) => {
	try {
		// 1. 获取并验证请求参数
		const {
			tagId,
			page = 1,
			pageSize = 10,
			sortBy = "creation_time",
			sortOrder = "desc",
			status // 新增status参数
		} = req.query

		// 验证必填参数
		if (!tagId) {
			return res.status(400).json({
				code: 400,
				mesg: "标签ID不能为空",
			})
		}

		// 验证分页参数
		const currentPage = Number.parseInt(page) || 1
		const limit = Number.parseInt(pageSize) || 10
		if (currentPage < 1 || limit < 1) {
			return res.status(400).json({
				code: 400,
				mesg: "分页参数无效",
			})
		}

		// 验证排序参数
		const validSortFields = ["id", "title", "category_id", "creation_time", "status"]
		const validSortOrders = ["asc", "desc"]

		const orderField = validSortFields.includes(sortBy) ? sortBy : "creation_time"
		const orderDirection = validSortOrders.includes(sortOrder.toLowerCase()) ? sortOrder : "desc"

		// 计算偏移量
		const offset = (currentPage - 1) * limit

		// 准备查询参数
		const queryParams = [tagId]

		// 构建基础SQL查询条件
		let statusCondition = ""
		if (status !== undefined && (status === '0' || status === '1' || status === 0 || status === 1)) {
			statusCondition = " AND il.status = ?"
			queryParams.push(Number(status))
		}

		// 2. 查询与标签关联的图片总数
		const countSql = `
      SELECT COUNT(DISTINCT il.id) as total
      FROM wallpaper_image_group il
      INNER JOIN wallpaper_image_to_tags itt ON il.id = itt.image_id
      WHERE itt.tag_id = ?${statusCondition}
    `

		const {
			result: countResult
		} = await pools({
			sql: countSql,
			val: queryParams,
			run: true,
		})

		const total = countResult[0]?.total || 0

		// 如果没有找到记录，直接返回空数组
		if (total === 0) {
			return res.status(200).json({
				code: 200,
				mesg: "查询成功",
				data: {
					list: [],
					pagination: {
						total: 0,
						page: currentPage,
						pageSize: limit,
						totalPages: 0,
					},
				},
			})
		}

		// 3. 查询图片数据
		const querySql = `
      SELECT DISTINCT il.*
      FROM wallpaper_image_group il
      INNER JOIN wallpaper_image_to_tags itt ON il.id = itt.image_id
      WHERE itt.tag_id = ?${statusCondition}
      ORDER BY il.${orderField} ${orderDirection}
      LIMIT ? OFFSET ?
    `

		// 添加分页参数
		queryParams.push(limit, offset)

		const {
			result: images
		} = await pools({
			sql: querySql,
			val: queryParams,
			run: true,
		})

		// 4. 查询每张图片关联的所有标签
		const imageIds = images.map((img) => img.id)

		if (imageIds.length > 0) {
			const tagsSql = `
        SELECT itt.image_id, it.id as tag_id, it.name as tag_name
        FROM wallpaper_image_to_tags itt
        INNER JOIN wallpaper_image_tags it ON itt.tag_id = it.id
        WHERE itt.image_id IN (${imageIds.join(",")})
      `

			const {
				result: tagResults
			} = await pools({
				sql: tagsSql,
				val: [],
				run: true,
			})

			// 将标签信息添加到对应的图片中
			const imageTagsMap = {}
			tagResults.forEach((tag) => {
				if (!imageTagsMap[tag.image_id]) {
					imageTagsMap[tag.image_id] = []
				}
				imageTagsMap[tag.image_id].push({
					id: tag.tag_id,
					name: tag.tag_name,
				})
			})

			// 将标签信息添加到图片对象中
			images.forEach((image) => {
				image.tags = imageTagsMap[image.id] || []
			})
		}

		// 5. 计算总页数
		const totalPages = Math.ceil(total / limit)

		// 6. 返回结果
		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: images,
			pagination: {
				total,
				page: currentPage,
				pageSize: limit,
				totalPages,
			},
		})
	} catch (err) {
		console.error("查询图片列表时出错:", err)
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		})
	}
})
/**
 * 根据多个标签ID查询图片列表（交集查询）
 *
 * 请求参数:
 * - tagIds: 标签ID数组，以逗号分隔 (必填)
 * - page: 页码，默认为1
 * - pageSize: 每页数量，默认为10
 * - sortBy: 排序字段，默认为creation_time
 * - sortOrder: 排序方式，asc或desc，默认为desc
 * - matchType: 匹配类型，all(交集)或any(并集)，默认为all
 */
router.get("/get_images_by_tags", async (req, res) => {
	try {
		// 1. 获取并验证请求参数
		const {
			tagIds,
			page = 1,
			pageSize = 10,
			sortBy = "creation_time",
			sortOrder = "desc",
			matchType = "all",
		} = req.query

		// 验证必填参数
		if (!tagIds) {
			return res.status(400).json({
				code: 400,
				mesg: "标签ID不能为空",
			})
		}

		// 解析标签ID数组
		const tagIdArray = tagIds
			.split(",")
			.map((id) => Number.parseInt(id))
			.filter((id) => !isNaN(id))

		if (tagIdArray.length === 0) {
			return res.status(400).json({
				code: 400,
				mesg: "无效的标签ID",
			})
		}

		// 验证分页参数
		const currentPage = Number.parseInt(page) || 1
		const limit = Number.parseInt(pageSize) || 10
		if (currentPage < 1 || limit < 1) {
			return res.status(400).json({
				code: 400,
				mesg: "分页参数无效",
			})
		}

		// 验证排序参数
		const validSortFields = ["id", "title", "category_id", "creation_time", "status"]
		const validSortOrders = ["asc", "desc"]

		const orderField = validSortFields.includes(sortBy) ? sortBy : "creation_time"
		const orderDirection = validSortOrders.includes(sortOrder.toLowerCase()) ? sortOrder : "desc"

		// 计算偏移量
		const offset = (currentPage - 1) * limit

		// 2. 根据匹配类型构建不同的SQL查询
		let countSql, querySql

		if (matchType.toLowerCase() === "all") {
			// 交集查询 - 图片必须包含所有指定的标签
			countSql = `
        SELECT COUNT(DISTINCT il.id) as total
        FROM wallpaper_image_group il
        WHERE il.id IN (
          SELECT itt.image_id
          FROM wallpaper_image_to_tags itt
          WHERE itt.tag_id IN (${tagIdArray.join(",")})
          GROUP BY itt.image_id
          HAVING COUNT(DISTINCT itt.tag_id) = ${tagIdArray.length}
        )
      `

			querySql = `
        SELECT DISTINCT il.*
        FROM wallpaper_image_group il
        WHERE il.id IN (
          SELECT itt.image_id
          FROM wallpaper_image_to_tags itt
          WHERE itt.tag_id IN (${tagIdArray.join(",")})
          GROUP BY itt.image_id
          HAVING COUNT(DISTINCT itt.tag_id) = ${tagIdArray.length}
        )
        ORDER BY il.${orderField} ${orderDirection}
        LIMIT ? OFFSET ?
      `
		} else {
			// 并集查询 - 图片包含任意一个指定的标签
			countSql = `
        SELECT COUNT(DISTINCT il.id) as total
        FROM wallpaper_image_group il
        INNER JOIN wallpaper_image_to_tags itt ON il.id = itt.image_id
        WHERE itt.tag_id IN (${tagIdArray.join(",")})
      `

			querySql = `
        SELECT DISTINCT il.*
        FROM wallpaper_image_group il
        INNER JOIN wallpaper_image_to_tags itt ON il.id = itt.image_id
        WHERE itt.tag_id IN (${tagIdArray.join(",")})
        ORDER BY il.${orderField} ${orderDirection}
        LIMIT ? OFFSET ?
      `
		}

		// 3. 查询总数
		const {
			result: countResult
		} = await pools({
			sql: countSql,
			val: [],
			run: true,
		})

		const total = countResult[0]?.total || 0

		// 如果没有找到记录，直接返回空数组
		if (total === 0) {
			return res.status(200).json({
				code: 200,
				mesg: "查询成功",
				data: {
					list: [],
					pagination: {
						total: 0,
						page: currentPage,
						pageSize: limit,
						totalPages: 0,
					},
				},
			})
		}

		// 4. 查询图片数据
		const {
			result: images
		} = await pools({
			sql: querySql,
			val: [limit, offset],
			run: true,
		})

		// 5. 查询每张图片关联的所有标签
		const imageIds = images.map((img) => img.id)

		if (imageIds.length > 0) {
			const tagsSql = `
        SELECT itt.image_id, it.id as tag_id, it.name as tag_name
        FROM wallpaper_image_to_tags itt
        INNER JOIN wallpaper_image_tags it ON itt.tag_id = it.id
        WHERE itt.image_id IN (${imageIds.join(",")})
      `

			const {
				result: tagResults
			} = await pools({
				sql: tagsSql,
				val: [],
				run: true,
			})

			// 将标签信息添加到对应的图片中
			const imageTagsMap = {}
			tagResults.forEach((tag) => {
				if (!imageTagsMap[tag.image_id]) {
					imageTagsMap[tag.image_id] = []
				}
				imageTagsMap[tag.image_id].push({
					id: tag.tag_id,
					name: tag.tag_name,
				})
			})

			// 将标签信息添加到图片对象中
			images.forEach((image) => {
				image.tags = imageTagsMap[image.id] || []
			})
		}

		// 6. 计算总页数
		const totalPages = Math.ceil(total / limit)

		// 7. 返回结果
		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: {
				list: images,
				pagination: {
					total,
					page: currentPage,
					pageSize: limit,
					totalPages,
				},
			},
		})
	} catch (err) {
		console.error("查询图片列表时出错:", err)
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		})
	}
})

/**
 * 获取轮播图列表
 * 
 * 请求参数:
 * - status: 状态筛选 (可选，0-禁用，1-启用，默认为1)
 */
router.get("/get_carousel_list", async (req, res) => {
	try {
		const { status = 1 } = req.query;
		
		let statusCondition = "";
		let queryParams = [];
		
		if (status !== undefined && (status === '0' || status === '1' || status === 0 || status === 1)) {
			statusCondition = "WHERE status = ?";
			queryParams.push(Number(status));
		}
		
		// 查询当前时间内的有效轮播图
		const sql = `
			SELECT id, title, image_url, link_type, link_value, sort_order, status, start_time, end_time
			FROM carousel 
			${statusCondition} 
			AND (start_time IS NULL OR start_time <= NOW()) 
			AND (end_time IS NULL OR end_time >= NOW())
			ORDER BY sort_order DESC, id DESC
		`;
		
		const { result } = await pools({
			sql: sql,
			val: queryParams,
			run: true,
		});
		
		// 转换为驼峰格式
		const camelCaseResult = convertDbResultToCamelCase(result);
		
		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: camelCaseResult,
		});
	} catch (err) {
		console.error("获取轮播图列表时出错:", err);
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		});
	}
});

/**
 * 获取热门专辑列表
 * 
 * 请求参数:
 * - page: 页码，默认为1
 * - pageSize: 每页数量，默认为10
 * - status: 状态筛选 (可选，0-禁用，1-启用，默认为1)
 * - categoryId: 分类ID筛选 (可选)
 */
router.get("/get_hot_album_list", async (req, res) => {
	try {
		const {
			page = 1,
			pageSize = 10,
			status = 1,
			categoryId
		} = req.query;
		
		// 验证分页参数
		const currentPage = Number.parseInt(page) || 1;
		const limit = Number.parseInt(pageSize) || 10;
		if (currentPage < 1 || limit < 1) {
			return res.status(400).json({
				code: 400,
				mesg: "分页参数无效",
			});
		}
		
		// 构建查询条件
		let whereConditions = ["status = ?"];
		let queryParams = [Number(status)];
		
		if (categoryId) {
			whereConditions.push("category_id = ?");
			queryParams.push(Number(categoryId));
		}
		
		const whereClause = "WHERE " + whereConditions.join(" AND ");
		
		// 计算偏移量
		const offset = (currentPage - 1) * limit;
		
		// 查询总数
		const countSql = `
			SELECT COUNT(*) as total 
			FROM hot_album 
			${whereClause}
		`;
		
		const { result: countResult } = await pools({
			sql: countSql,
			val: queryParams,
			run: true,
		});
		
		const total = countResult[0]?.total || 0;
		
		// 如果没有找到记录，直接返回空数组
		if (total === 0) {
			return res.status(200).json({
				code: 200,
				mesg: "查询成功",
				data: {
					list: [],
					pagination: {
						total: 0,
						page: currentPage,
						pageSize: limit,
						totalPages: 0,
					},
				},
			});
		}
		
		// 查询专辑数据
		const querySql = `
			SELECT id, title, description, cover_image, image_count, view_count, 
			       sort_order, status, category_id, tags, create_time, update_time
			FROM hot_album 
			${whereClause}
			ORDER BY sort_order DESC, view_count DESC, id DESC
			LIMIT ? OFFSET ?
		`;
		
		queryParams.push(limit, offset);
		
		const { result: albums } = await pools({
			sql: querySql,
			val: queryParams,
			run: true,
		});
		
		// 转换为驼峰格式
		const camelCaseAlbums = convertDbResultToCamelCase(albums);
		
		// 计算总页数
		const totalPages = Math.ceil(total / limit);
		
		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: {
				list: camelCaseAlbums,
				pagination: {
					total,
					page: currentPage,
					pageSize: limit,
					totalPages,
				},
			},
		});
	} catch (err) {
		console.error("获取热门专辑列表时出错:", err);
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		});
	}
});

/**
 * 根据专辑ID获取专辑详情
 * 
 * 请求参数:
 * - albumId: 专辑ID (必填)
 */
router.get("/get_album_detail", async (req, res) => {
	try {
		const { albumId } = req.query;
		
		if (!albumId) {
			return res.status(400).json({
				code: 400,
				mesg: "专辑ID不能为空",
			});
		}
		
		// 查询专辑详情
		const albumSql = `
			SELECT id, title, description, cover_image, image_count, view_count, 
			       sort_order, status, category_id, tags, create_time, update_time
			FROM hot_album 
			WHERE id = ? AND status = 1
		`;
		
		const { result: albumResult } = await pools({
			sql: albumSql,
			val: [Number(albumId)],
			run: true,
		});
		
		if (albumResult.length === 0) {
			return res.status(404).json({
				code: 404,
				mesg: "专辑不存在或已禁用",
			});
		}
		
		// 更新浏览次数
		const updateViewSql = `
			UPDATE hot_album 
			SET view_count = view_count + 1 
			WHERE id = ?
		`;
		
		await pools({
			sql: updateViewSql,
			val: [Number(albumId)],
			run: true,
		});
		
		// 转换为驼峰格式
		const camelCaseAlbum = convertDbResultToCamelCase(albumResult[0]);
		
		return res.status(200).json({
			code: 200,
			mesg: "查询成功",
			data: camelCaseAlbum,
		});
	} catch (err) {
		console.error("获取专辑详情时出错:", err);
		return res.status(500).json({
			code: 500,
			mesg: err.message || "服务器处理请求失败",
		});
	}
});


module.exports = router