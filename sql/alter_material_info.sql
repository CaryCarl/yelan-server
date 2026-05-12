-- 添加百度网盘链接字段
ALTER TABLE `material_info` 
ADD COLUMN `baidu_pan_url` varchar(255) DEFAULT NULL COMMENT '百度网盘链接' AFTER `cover_image`,
ADD COLUMN `baidu_pan_code` varchar(10) DEFAULT NULL COMMENT '百度网盘提取码' AFTER `baidu_pan_url`;

-- 为资料信息表增加二级分类ID字段
ALTER TABLE `material_info`
ADD COLUMN `sub_category_id` int(11) DEFAULT NULL COMMENT '二级分类ID' AFTER `category_id`,
ADD KEY `idx_sub_category_id` (`sub_category_id`),
ADD CONSTRAINT `fk_subcategory` FOREIGN KEY (`sub_category_id`) REFERENCES `material_subcategory` (`id`) ON DELETE SET NULL ON UPDATE CASCADE; 