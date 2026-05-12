-- 轮播图表
CREATE TABLE `carousel` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '轮播图标题',
  `image_url` varchar(500) NOT NULL DEFAULT '' COMMENT '图片URL',
  `link_type` tinyint(2) NOT NULL DEFAULT 0 COMMENT '链接类型：0-无链接，1-图片详情，2-专辑，3-外部链接',
  `link_value` varchar(200) NOT NULL DEFAULT '' COMMENT '链接值：图片ID/专辑ID/外部URL',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT '排序权重，数字越大越靠前',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_sort_status` (`sort_order`, `status`),
  KEY `idx_time_range` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图表';

-- 热门专辑表
CREATE TABLE `hot_album` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '专辑ID',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '专辑标题',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '专辑描述',
  `cover_image` varchar(500) NOT NULL DEFAULT '' COMMENT '封面图片URL',
  `image_count` int(11) NOT NULL DEFAULT 0 COMMENT '包含图片数量',
  `view_count` int(11) NOT NULL DEFAULT 0 COMMENT '浏览次数',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT '排序权重，数字越大越靠前',
  `status` tinyint(2) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `category_id` int(11) DEFAULT NULL COMMENT '分类ID（关联图片分类表）',
  `tags` varchar(200) DEFAULT NULL COMMENT '标签，多个用逗号分隔',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_sort_status` (`sort_order`, `status`),
  KEY `idx_category` (`category_id`),
  KEY `idx_view_count` (`view_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='热门专辑表';

-- 轮播图示例数据
INSERT INTO `carousel` (`title`, `image_url`, `link_type`, `link_value`, `sort_order`, `status`) VALUES
('精美壁纸推荐', 'https://example.com/carousel1.jpg', 2, '1', 100, 1),
('热门壁纸合集', 'https://example.com/carousel2.jpg', 2, '2', 90, 1),
('节日专题壁纸', 'https://example.com/carousel3.jpg', 1, '123', 80, 1);

-- 热门专辑示例数据
INSERT INTO `hot_album` (`title`, `description`, `cover_image`, `image_count`, `view_count`, `sort_order`, `status`, `category_id`, `tags`) VALUES
('自然风光专辑', '精选全球最美自然风光壁纸', 'https://example.com/album1.jpg', 50, 1200, 100, 1, 1, '自然,风景,高清'),
('动漫壁纸合集', '热门动漫角色壁纸精选', 'https://example.com/album2.jpg', 80, 2300, 90, 1, 2, '动漫,二次元,角色'),
('简约风格壁纸', '极简主义设计壁纸集合', 'https://example.com/album3.jpg', 30, 800, 85, 1, 3, '简约,现代,设计');
