-- 如果表已存在，先删除
DROP TABLE IF EXISTS `material_info`;

-- 创建资料信息表
CREATE TABLE `material_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `category_id` int(11) NOT NULL COMMENT '关联的资料分类ID',
  `title` varchar(100) NOT NULL COMMENT '资料标题',
  `description` text COMMENT '资料详情/文章介绍',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态(0:下架,1:上架)',
  `view_count` int(11) NOT NULL DEFAULT '0' COMMENT '浏览量',
  `favorite_count` int(11) NOT NULL DEFAULT '0' COMMENT '收藏量',
  `like_count` int(11) NOT NULL DEFAULT '0' COMMENT '喜欢量',
  `sort_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '排序时间（默认创建时间，可手动更新）',
  `extra_data` json DEFAULT NULL COMMENT '扩展数据（JSON格式）',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图片URL',
  `author` varchar(50) DEFAULT NULL COMMENT '作者/来源',
  `tags` varchar(255) DEFAULT NULL COMMENT '标签，多个用逗号分隔',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_sort_time` (`sort_time`),
  KEY `idx_create_time` (`create_time`),
  CONSTRAINT `fk_category` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资料信息表';

-- 插入测试数据
INSERT INTO `material_info` 
(`category_id`, `title`, `description`, `status`, `extra_data`, `cover_image`, `author`, `tags`) 
VALUES 
(1, '测试资料1', '这是一个测试资料的详细描述，包含了资料的主要内容和介绍。', 1, 
  '{"type": "article", "difficulty": "easy", "keywords": ["测试", "示例"]}',
  'https://example.com/images/cover1.jpg', '管理员', '测试,示例'),
(1, '测试资料2', '这是另一个测试资料的详细描述，展示了不同类型的内容。', 1,
  '{"type": "tutorial", "difficulty": "medium", "keywords": ["教程", "指南"]}',
  'https://example.com/images/cover2.jpg', '编辑', '教程,指南');

-- 查询示例
SELECT 
  m.*,
  c.name as category_name,
  c.appids as category_appids
FROM material_info m
LEFT JOIN material_category c ON m.category_id = c.id
WHERE m.status = 1
ORDER BY m.sort_time DESC, m.create_time DESC
LIMIT 10; 