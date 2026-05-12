const express = require('express');
const router = express.Router();
const querySql = require("../../utils/query.js");

// 新增资料
router.post("/add_material", async (req, res) => {
	try {
		const {
			category_id,
			sub_category_id,
			content,
			content_raw,
			title,
			description,
			cover_image,
			baidu_pan_url,    // 添加百度网盘链接
			baidu_pan_code,   // 添加百度网盘提取码
			author,
			tags,
			extra_data
		} = req.body;

		// 参数验证
		if (!category_id || !sub_category_id || !title) {
			return res.send({
				code: 400,
				msg: '参数错误：分类ID、二级分类ID和标题不能为空',
				data: null
			});
		}

		// 检查分类是否存在
		const categoryCheck = await querySql(
			'SELECT id FROM material_category WHERE id = ? AND status = 1',
			[category_id]
		);

		if (categoryCheck.length === 0) {
			return res.send({
				code: 400,
				msg: '所选分类不存在或已被禁用',
				data: null
			});
		}


		// 构建插入数据
		const insertData = {
			category_id,
			sub_category_id,
			content,
			content_raw,
			title,
			description: description || null,
			cover_image: cover_image || null,
			baidu_pan_url: baidu_pan_url || null,
			baidu_pan_code: baidu_pan_code || null,
			author: author || null,
			tags: tags || null,
			extra_data: extra_data ? JSON.stringify(extra_data) : null,
			sort_time: new Date()
		};

		// 插入数据
		const result = await querySql(
			'INSERT INTO material_info SET ?',
			insertData
		);

		// 更新分类的资料数量
		await querySql(
			'UPDATE material_category SET count = count + 1 WHERE id = ?',
			[category_id]
		);

		res.send({
			code: 200,
			msg: '添加成功',
			data: {
				id: result.insertId
			}
		});
	} catch (error) {
		console.error('添加资料失败:', error);
		res.send({
			code: 500,
			msg: '添加失败',
			error: error.message
		});
	}
});

// 修改资料
router.post("/update_material", async (req, res) => {
	try {
		const {
			id,
			category_id,
			title,
			content,
			content_raw,
			description,
			status,
			cover_image,
			baidu_pan_url,    // 添加百度网盘链接
			baidu_pan_code,   // 添加百度网盘提取码
			author,
			tags,
			extra_data,
			sort_time
		} = req.body;

		// 参数验证
		if (!id) {
			return res.send({
				code: 400,
				msg: '参数错误：资料ID不能为空',
				data: null
			});
		}

		// 检查资料是否存在
		const materialCheck = await querySql(
			'SELECT category_id FROM material_info WHERE id = ?',
			[id]
		);

		if (materialCheck.length === 0) {
			return res.send({
				code: 404,
				msg: '资料不存在',
				data: null
			});
		}

		const oldCategoryId = materialCheck[0].category_id;

		// 如果更改了分类，检查新分类是否存在
		if (category_id && category_id !== oldCategoryId) {
			const categoryCheck = await querySql(
				'SELECT id FROM material_category WHERE id = ? AND status = 1',
				[category_id]
			);

			if (categoryCheck.length === 0) {
				return res.send({
					code: 400,
					msg: '所选分类不存在或已被禁用',
					data: null
				});
			}
		}

		// 构建更新数据
		let updateData = {};
		if (category_id) updateData.category_id = category_id;
		if (title) updateData.title = title;
		if (content) updateData.content = content;
		if (content_raw) updateData.content_raw = content_raw;
		if (description !== undefined) updateData.description = description;
		if (status !== undefined) updateData.status = status;
		if (cover_image !== undefined) updateData.cover_image = cover_image;
		if (baidu_pan_url !== undefined) updateData.baidu_pan_url = baidu_pan_url;
		if (baidu_pan_code !== undefined) updateData.baidu_pan_code = baidu_pan_code;
		if (author !== undefined) updateData.author = author;
		if (tags !== undefined) updateData.tags = tags;
		if (extra_data !== undefined) updateData.extra_data = JSON.stringify(extra_data);
		if (sort_time) updateData.sort_time = new Date(sort_time);

		if (Object.keys(updateData).length === 0) {
			return res.send({
				code: 400,
				msg: '没有需要更新的字段',
				data: null
			});
		}

		// 更新资料
		await querySql(
			'UPDATE material_info SET ? WHERE id = ?',
			[updateData, id]
		);

		// 如果更改了分类，更新新旧分类的资料数量
		if (category_id && category_id !== oldCategoryId) {
			await Promise.all([
				querySql('UPDATE material_category SET count = count - 1 WHERE id = ?', [oldCategoryId]),
				querySql('UPDATE material_category SET count = count + 1 WHERE id = ?', [category_id])
			]);
		}

		res.send({
			code: 200,
			msg: '更新成功',
			data: null
		});

	} catch (error) {
		console.error('更新资料失败:', error);
		res.send({
			code: 500,
			msg: '更新失败',
			error: error.message
		});
	}
});

// 删除资料
router.post("/delete_material", async (req, res) => {
	try {
		const { id } = req.body;

		if (!id) {
			return res.send({
				code: 400,
				msg: '参数错误：资料ID不能为空',
				data: null
			});
		}

		// 检查资料是否存在
		const materialCheck = await querySql(
			'SELECT category_id FROM material_info WHERE id = ?',
			[id]
		);

		if (materialCheck.length === 0) {
			return res.send({
				code: 404,
				msg: '资料不存在或已被删除',
				data: null
			});
		}

		// 2. 执行物理删除语句
        await querySql(
            'DELETE FROM material_info WHERE id = ?',
            [id]
        );

		// 更新分类的资料数量
		await querySql(
			'UPDATE material_category SET count = GREATEST(count - 1, 0) WHERE id = ?',
			[materialCheck[0].category_id]
		);

		res.send({
			code: 200,
			msg: '删除成功',
			data: null
		});

	} catch (error) {
		console.error('删除资料失败:', error);
		res.send({
			code: 500,
			msg: '删除失败',
			error: error.message
		});
	}
});

// 修改资料状态为发布
router.post("/update_material_status", async (req, res) => {
	try {
		const { id,status } = req.body;

		if (!id) {
			return res.send({
				code: 400,
				msg: '参数错误：资料ID不能为空',
				data: null
			});
		}

		// 检查资料是否存在
		const materialCheck = await querySql(
			`SELECT category_id FROM material_info WHERE id = ?`,
			[id]
		);

		if (materialCheck.length === 0) {
			return res.send({
				code: 404,
				msg: '资料不存在或已被删除',
				data: null
			});
		}

		// 软删除资料
		await querySql(
			`UPDATE material_info SET status = ${status} WHERE id = ?`,
			[id]
		);

		// 更新分类的资料数量
		await querySql(
			'UPDATE material_category SET count = count - 1 WHERE id = ?',
			[materialCheck[0].category_id]
		);

		res.send({
			code: 200,
			msg: '操作成功',
			data: null
		});

	} catch (error) {
		res.send({
			code: 500,
			msg: '操作失败',
			error: error.message
		});
	}
});

// 获取资料列表
router.get("/get_material_list", async (req, res) => {
	try {
		const {
			pageNumber = 1,
			pageSize = 10,
			status = 1,
			category_id,
			subcategory_id,
			title,
			tags,
			sort = 'sort_time' // 排序字段：sort_time, view_count, favorite_count, like_count
		} = req.query;

		let sql = `
			SELECT 
				m.*,
				c.name as category_name,
				c.appids as category_appids
			FROM material_info m
			LEFT JOIN material_category c ON m.category_id = c.id
			WHERE 1=1
		`;
		let countSql = 'SELECT COUNT(*) as total FROM material_info m WHERE 1=1';
		let params = [];

		// 构建查询条件
		if (!status) {
			sql += ' AND m.status = ?';
			countSql += ' AND m.status = ?';
			params.push(status);
		}

		if (category_id) {
			sql += ' AND m.category_id = ?';
			countSql += ' AND m.category_id = ?';
			params.push(category_id);
		}

		if (subcategory_id) {
			sql += ' AND m.sub_category_id = ?';
			countSql += ' AND m.sub_category_id = ?';
			params.push(subcategory_id);
		}

		if (title) {
			sql += ' AND m.title LIKE ?';
			countSql += ' AND m.title LIKE ?';
			params.push(`%${title}%`);
		}

		if (tags) {
			sql += ' AND m.tags LIKE ?';
			countSql += ' AND m.tags LIKE ?';
			params.push(`%${tags}%`);
		}

		// 添加排序
		switch (sort) {
			case 'view_count':
				sql += ' ORDER BY m.view_count DESC';
				break;
			case 'favorite_count':
				sql += ' ORDER BY m.favorite_count DESC';
				break;
			case 'like_count':
				sql += ' ORDER BY m.like_count DESC';
				break;
			default:
				sql += ' ORDER BY m.sort_time DESC';
		}
		sql += ', m.create_time DESC';

		// 添加分页
		sql += ' LIMIT ? OFFSET ?';
		const offset = (pageNumber - 1) * pageSize;
		params.push(parseInt(pageSize), offset);

		// 执行查询
		const [list, totalResult] = await Promise.all([
			querySql(sql, params),
			querySql(countSql, params.slice(0, -2))
		]);

		// 处理返回数据
		const processedList = list.map(item => ({
			...item,
			category_appids: item.category_appids ? JSON.parse(item.category_appids) : [],
			extra_data: item.extra_data ? JSON.parse(item.extra_data) : null
		}));

		res.send({
			code: 200,
			msg: '查询成功',
			data: processedList,
			total: totalResult[0].total,
			pageNumber: parseInt(pageNumber),
			pageSize: parseInt(pageSize)
		});

	} catch (error) {
		console.error('查询资料列表失败:', error);
		res.send({
			code: 500,
			msg: '查询失败',
			error: error.message
		});
	}
});

// 获取资料详情
router.get("/get_material_detail", async (req, res) => {
	try {
		const { id } = req.query;

		if (!id) {
			return res.send({
				code: 400,
				msg: '参数错误：资料ID不能为空',
				data: null
			});
		}

		// 查询资料详情
		const sql = `
			SELECT 
				m.*,
				c.name as category_name,
				c.appids as category_appids
			FROM material_info m
			LEFT JOIN material_category c ON m.category_id = c.id
			WHERE m.id = ?
		`;

		const [detail] = await querySql(sql, [id]);

		if (!detail) {
			return res.send({
				code: 404,
				msg: '资料不存在',
				data: null
			});
		}

		// 更新浏览量
		await querySql(
			'UPDATE material_info SET view_count = view_count + 1 WHERE id = ?',
			[id]
		);

		// 处理JSON字段
		detail.category_appids = detail.category_appids ? JSON.parse(detail.category_appids) : [];
		detail.extra_data = detail.extra_data ? JSON.parse(detail.extra_data) : null;

		res.send({
			code: 200,
			msg: '查询成功',
			data: detail
		});

	} catch (error) {
		console.error('查询资料详情失败:', error);
		res.send({
			code: 500,
			msg: '查询失败',
			error: error.message
		});
	}
});

// 更新资料计数（收藏/喜欢）
router.post("/update_material_count", async (req, res) => {
	try {
		const { id, type, value } = req.body;

		if (!id || !type || ![-1, 1].includes(value)) {
			return res.send({
				code: 400,
				msg: '参数错误',
				data: null
			});
		}

		let field;
		switch (type) {
			case 'favorite':
				field = 'favorite_count';
				break;
			case 'like':
				field = 'like_count';
				break;
			default:
				return res.send({
					code: 400,
					msg: '不支持的计数类型',
					data: null
				});
		}

		// 更新计数
		await querySql(
			`UPDATE material_info SET ${field} = GREATEST(0, ${field} + ?) WHERE id = ?`,
			[value, id]
		);

		res.send({
			code: 200,
			msg: '更新成功',
			data: null
		});

	} catch (error) {
		console.error('更新资料计数失败:', error);
		res.send({
			code: 500,
			msg: '更新失败',
			error: error.message
		});
	}
});

// 查询资源列表（分页 + sub_category_id + status）
router.post("/get_material_list", async (req, res) => {
	try {
		const {
			page = 1,
			pageSize = 10,
			sub_category_id,
			status
		} = req.body;

		const offset = (Math.max(1, Number(page)) - 1) * Number(pageSize);
		const limit = Number(pageSize);

		let conditions = ['1=1'];
		let values = [];

		if (sub_category_id !== undefined && sub_category_id !== '' && sub_category_id !== null) {
			conditions.push('sub_category_id = ?');
			values.push(sub_category_id);
		}
		if (status !== undefined && status !== '' && status !== null) {
			conditions.push('status = ?');
			values.push(status);
		}

		const where = conditions.join(' AND ');

		const countResult = await querySql(
			`SELECT COUNT(*) AS total FROM material_info WHERE ${where}`,
			values
		);
		const total = countResult[0].total;

		const list = await querySql(
			`SELECT id, category_id, sub_category_id, title, description, cover_image,
			        baidu_pan_url, baidu_pan_code, author, tags, status,
			        view_count, download_count, like_count, sort_time,
			        create_time, update_time
			 FROM material_info
			 WHERE ${where}
			 ORDER BY sort_time DESC, create_time DESC
			 LIMIT ? OFFSET ?`,
			[...values, limit, offset]
		);

		res.send({
			code: 200,
			msg: '查询成功',
			data: {
				list,
				total,
				page: Number(page),
				pageSize: limit,
				totalPages: Math.ceil(total / limit)
			}
		});
	} catch (error) {
		console.error('查询资源列表失败:', error);
		res.send({
			code: 500,
			msg: '查询失败',
			error: error.message
		});
	}
});

module.exports = router;