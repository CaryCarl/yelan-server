-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2026-03-10 23:27:04
-- 服务器版本： 5.7.44-log
-- PHP 版本： 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `qushuiyin`
--

DELIMITER $$
--
-- 存储过程
--
$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `files`
--

CREATE TABLE `files` (
  `id` varchar(255) DEFAULT NULL,
  `val` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `update_time` varchar(255) DEFAULT NULL,
  `create_time` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `files`
--

INSERT INTO `files` (`id`, `val`, `type`, `update_time`, `create_time`) VALUES
('1', '[{\"url\":\"http://127.0.0.1:3000/168716330188007431480203391654-微信图片_20221209135913.jpg\",\"name\":\"微信图片_20221209135913\",\"originalname\":\"微信图片_20221209135913.jpg\"}]', '1', '', '2023/06/19 16:28:23'),
('2', '[{\"url\":\"http://iweb-web.oss-cn-shanghai.aliyuncs.com/shoujibizhi/172984703450808703605847081761-1729847034508\",\"name\":\"微信图片_20240304174201\",\"originalname\":\"微信图片_20240304174201.jpg\",\"filename\":\"172984703450808703605847081761-1729847034508\"}]', '1', '', '2024/10/25 17:03:56');

-- --------------------------------------------------------

--
-- 表的结构 `material_category`
--

CREATE TABLE `material_category` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `name` varchar(50) NOT NULL COMMENT '类型名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态(0:禁用,1:启用)',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '该类型下的资料数量',
  `appids` json DEFAULT NULL COMMENT '关联的小程序appid列表，JSON数组格式',
  `sort_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序序号(数字越大越靠前)',
  `sort_field` varchar(20) NOT NULL DEFAULT 'sort_order' COMMENT '排序字段(sort_order:序号排序,count:数量排序,create_time:创建时间排序)',
  `description` varchar(255) DEFAULT NULL COMMENT '类型描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资料分类表';

--
-- 转存表中的数据 `material_category`
--

INSERT INTO `material_category` (`id`, `name`, `status`, `count`, `appids`, `sort_order`, `sort_field`, `description`, `create_time`, `update_time`) VALUES
(2, '设计素材', 1, 4, '[\"wx789012\"]', 80, 'create_time', NULL, '2025-06-02 19:09:12', '2026-03-05 21:16:41'),
(3, 'UI/UX/视觉', 1, -2, '[\"wx123456\"]', 101, 'count', NULL, '2025-06-02 19:09:12', '2026-03-08 16:28:52'),
(7, '休闲', 0, 1, '[\"wxd1a72e6d2c6c4afe\", \"wxe84f994fe3d56f0b\"]', 0, 'sort_order', NULL, '2025-08-25 16:55:09', '2026-03-09 16:35:22'),
(8, '游戏', 0, 1, '[\"wxe84f994fe3d56f0b\"]', 4, 'sort_order', NULL, '2025-11-17 10:45:07', '2026-03-09 16:35:32'),
(9, '调色预设', 1, 15, '[\"wxe84f994fe3d56f0b\", \"wxd1a72e6d2c6c4afe\"]', 100, 'sort_order', NULL, '2026-02-01 21:03:47', '2026-03-06 00:30:44'),
(10, '软件工具', 1, 3, '[\"wxe84f994fe3d56f0b\", \"wxd1a72e6d2c6c4afe\"]', 90, 'sort_order', NULL, '2026-02-03 00:17:52', '2026-03-09 18:19:49'),
(15, '默认分类2', 0, -2, '[\"wx123456\", \"wx789012\"]', 100, 'sort_order', '系统默认分类', '2025-06-02 19:09:12', '2026-03-08 17:35:41');

-- --------------------------------------------------------

--
-- 表的结构 `material_info`
--

CREATE TABLE `material_info` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `category_id` int(11) NOT NULL COMMENT '关联的资料分类ID',
  `sub_category_id` int(11) DEFAULT NULL COMMENT '二级分类ID',
  `title` varchar(100) NOT NULL COMMENT '资料标题',
  `description` text COMMENT '资料详情/文章介绍',
  `content` longtext COMMENT '资料富文本详情',
  `content_raw` json NOT NULL COMMENT '富文本原始格式',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态(0:下架,1:上架)',
  `view_count` int(11) NOT NULL DEFAULT '0' COMMENT '浏览量',
  `favorite_count` int(11) NOT NULL DEFAULT '0' COMMENT '收藏量',
  `like_count` int(11) NOT NULL DEFAULT '0' COMMENT '喜欢量',
  `sort_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '排序时间（默认创建时间，可手动更新）',
  `extra_data` json DEFAULT NULL COMMENT '扩展数据（JSON格式）',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图片URL',
  `baidu_pan_url` varchar(255) DEFAULT NULL COMMENT '百度网盘链接',
  `baidu_pan_code` varchar(10) DEFAULT NULL COMMENT '百度网盘提取码',
  `author` varchar(50) DEFAULT NULL COMMENT '作者/来源',
  `tags` varchar(255) DEFAULT NULL COMMENT '标签，多个用逗号分隔',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资料信息表';

--
-- 转存表中的数据 `material_info`
--

INSERT INTO `material_info` (`id`, `category_id`, `sub_category_id`, `title`, `description`, `content`, `content_raw`, `status`, `view_count`, `favorite_count`, `like_count`, `sort_time`, `extra_data`, `cover_image`, `baidu_pan_url`, `baidu_pan_code`, `author`, `tags`, `create_time`, `update_time`) VALUES
(3, 2, 2, '1234', '3', NULL, 'null', 0, 0, 0, 0, '2025-06-02 21:08:02', 'null', NULL, NULL, NULL, '10', '2', '2025-06-02 21:08:02', '2025-06-29 22:30:29'),
(5, 2, 2, '测试2', NULL, NULL, 'null', 0, 0, 0, 0, '2025-06-22 23:26:28', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-22 23:26:28', '2025-06-29 22:30:34'),
(6, 2, 2, '测试12', NULL, '12', 'null', 0, 0, 0, 0, '2025-06-22 23:28:18', NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-22 23:28:18', '2025-06-29 22:30:06'),
(7, 2, 2, '232', NULL, '<p><strong>1我我</strong></p>', 'null', 0, 0, 0, 0, '2025-06-22 23:43:35', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1750606675100_81cc83bd2516afc3.png', NULL, NULL, NULL, NULL, '2025-06-22 23:43:35', '2025-06-30 00:20:20'),
(17, 3, 3, '加载页loading状态GIF图标UI设计APP动效下拉加载刷新动画AE素材-M001', NULL, '<p></p>\n<p>格式：<strong>GIF、初始文档aep、json脚本</strong></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214414983_4c4599e4a3a01a8d.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214423987_8b42ec507d4f0728.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214432780_de0e7d7fb3adab6a.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214438139_11c967142d08bcdd.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214443383_8e73631f818827fe.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214451488_df61226b219c0874.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214456012_b64d0b83bba5ac68.gif\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214352088_a376a2fab930e1fa.jpg\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214358004_20f2ed4f5b3a147c.jpg\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<p></p>\n', '{\"blocks\": [{\"key\": \"4u46t\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"43nek\", \"data\": {}, \"text\": \"格式：GIF、初始文档aep、json脚本\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": [{\"style\": \"BOLD\", \"length\": 18, \"offset\": 3}]}, {\"key\": \"c0aj6\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"e1d0q\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"a3cf\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"b2fhm\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dgar\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1eljb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"elsvf\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fprh7\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 3, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2jlsc\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dg2fe\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 4, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"cisuc\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9uhl6\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 5, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"1p5ul\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3j2tb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 6, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"eneu4\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"67k63\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"okfv\", \"data\": {}, \"text\": \" \", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [{\"key\": 7, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"a0n4g\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5ci2j\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a02nm\", \"data\": {}, \"text\": \" \", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [{\"key\": 8, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"cm3iu\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"asuhh\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214414983_4c4599e4a3a01a8d.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214423987_8b42ec507d4f0728.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214432780_de0e7d7fb3adab6a.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"3\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214438139_11c967142d08bcdd.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"4\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214443383_8e73631f818827fe.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"5\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214451488_df61226b219c0874.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"6\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214456012_b64d0b83bba5ac68.gif\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"7\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214352088_a376a2fab930e1fa.jpg\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"8\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214358004_20f2ed4f5b3a147c.jpg\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 116, 0, 0, '2025-06-29 21:46:09', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751214308955_4b2b6a2b79235e5c.png', '通过网盘分享的文件：CU-062 gif 链接: https://pan.baidu.com/s/1ZB5LIo0LzOd-cqIIx02SLg?pwd=qvsw 提取码: qvsw  --来自百度网盘超级会员v3的分享', NULL, NULL, '', '2025-06-29 21:46:08', '2025-09-01 19:52:52'),
(27, 15, 2, '测试资料12', '这是一个测试资料的详细描述，包含了资料的主要内容和介绍。', NULL, 'null', 0, 0, 0, 0, '2025-06-02 20:25:36', '{\"type\": \"article\", \"keywords\": [\"测试\", \"示例\"], \"difficulty\": \"easy\"}', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1748875986982_f993890130ef1143.png', NULL, NULL, '管理员', '测试,示例', '2025-06-02 20:25:36', '2025-06-29 22:30:20'),
(28, 15, 2, '测试', '这是另一个测试资料的详细描述，展示了不同类型的内容。', NULL, 'null', 0, 0, 0, 0, '2025-06-02 20:25:36', '{\"type\": \"tutorial\", \"keywords\": [\"教程\", \"指南\"], \"difficulty\": \"medium\"}', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1748877230525_08690246b9f02997.png', '786789', '789', '编辑', '教程,指南', '2025-06-02 20:25:36', '2025-06-29 22:29:55'),
(29, 2, 2, '1234', '3', NULL, 'null', 0, 0, 0, 0, '2025-06-02 21:08:02', 'null', NULL, NULL, NULL, '10', '2', '2025-06-02 21:08:02', '2025-06-29 22:30:02'),
(30, 2, 2, '232', NULL, '<p><strong>1我我</strong></p>', 'null', 0, 0, 0, 0, '2025-06-22 23:43:35', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1750606675100_81cc83bd2516afc3.png', NULL, NULL, NULL, NULL, '2025-06-22 23:43:35', '2025-06-30 00:20:25'),
(34, 2, 4, '9款iPhoneX手机ui界面app设计作品展示效果PSD贴图样机素材PS模型-M002', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301453861_6fe7914c5a52fd85.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301457836_5a4cc88a825cb379.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301462731_962857e47b6f0baf.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301465676_6fdbf158ee3cd67d.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301468396_f59dd05acae12430.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301470956_604291edb49d6d79.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301473842_fc23df341c6d00bd.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301476709_aaaffeb88a7e677c.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301479265_d7271e50eca58ae1.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301482105_77927845a4b632f7.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"3dmro\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9ljvk\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"47ef0\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2kk4j\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"4q47u\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"51phf\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5fmvg\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"eb651\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 3, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"6ejra\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"eupj2\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 4, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ct3ma\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bk90h\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 5, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"b6gcl\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1pti6\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 6, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"1u1uu\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8aavv\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 7, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"1daoa\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"974g9\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 8, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"36m8i\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9kov3\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 9, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"7df0j\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301453861_6fe7914c5a52fd85.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301457836_5a4cc88a825cb379.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301462731_962857e47b6f0baf.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"3\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301465676_6fdbf158ee3cd67d.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"4\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301468396_f59dd05acae12430.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"5\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301470956_604291edb49d6d79.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"6\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301473842_fc23df341c6d00bd.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"7\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301476709_aaaffeb88a7e677c.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"8\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301479265_d7271e50eca58ae1.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"9\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301482105_77927845a4b632f7.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 7, 0, 0, '2025-07-01 00:35:56', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1751301353118_63a07af621e71c2e.png?imageMogr2/format/webp', '通过网盘分享的文件：9款iPhoneX手机ui界面app设计作品展示效果PSD贴图样机素材PS模型 链接: https://pan.baidu.com/s/1iQW0Nfgup-33Kuez0CJQIA?pwd=vgp3 提取码: vgp3  --来自百度网盘超级会员v3的分享', NULL, NULL, 'PSD', '2025-07-01 00:35:56', '2025-11-17 00:30:39'),
(35, 2, 5, '毛玻璃按钮背景PNG+PSD格式', NULL, '<p>透明磨砂玻璃毛玻璃ICON按钮Button背景PSD样式PNG免扣设计UI素材</p>\n<p>两种格式PNG+PSD</p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1752477112763_9e7f21922a26f648.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1752477118104_fb459139effdf686.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"b7f0\", \"data\": {}, \"text\": \"透明磨砂玻璃毛玻璃ICON按钮Button背景PSD样式PNG免扣设计UI素材\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9esd1\", \"data\": {}, \"text\": \"两种格式PNG+PSD\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"d0h0s\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7m1tb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"cb57t\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7slp5\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"33fa0\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1752477112763_9e7f21922a26f648.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1752477118104_fb459139effdf686.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 20, 0, 0, '2025-07-14 15:12:01', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1752476389755_368b6f309419ab2f.png?imageMogr2/format/webp', '通过网盘分享的文件：K0875-毛玻璃按钮背景 链接: https://pan.baidu.com/s/1RCEfmV9Ce-bRpfiZas5rFQ?pwd=nfcb 提取码: nfcb  --来自百度网盘超级会员v3的分享', NULL, NULL, '', '2025-07-14 15:12:00', '2026-03-09 17:35:22'),
(48, 7, 6, '凡人修仙传', NULL, '<p><strong>免费</strong></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756112422677_e6ab738e588e76b4.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756112415982_a8ba1544200c4bd7.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"9eakb\", \"data\": {}, \"text\": \"免费\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": [{\"style\": \"BOLD\", \"length\": 2, \"offset\": 0}]}, {\"key\": \"80nsu\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8lr2k\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"53bes\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7tt01\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dvaqu\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"4uqde\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756112422677_e6ab738e588e76b4.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756112415982_a8ba1544200c4bd7.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 15, 0, 0, '2025-08-25 17:00:28', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756112389779_32c53ca7a4d9fa35.png?imageMogr2/format/webp', '通过网盘分享的文件：FR07#176 凡人修仙传 4K 链接: https://pan.baidu.com/s/1uGcDH4bIejp1wINynmuOyQ?pwd=4ndg 提取码: 4ndg  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2025-08-25 17:00:28', '2025-08-29 19:07:42'),
(49, 2, 5, '光效光晕光斑免扣PNG素材高清-上千张素材', NULL, '<p>上千个光效光晕光斑免扣PNG素材，下载即用</p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190279212_2bd89cf2b1c268d0.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190284052_27d3a4478137153b.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190287541_a7dc444b47e016b0.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190290578_4f7ce0f11d1f5ab2.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190293579_316f71c9365481e7.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"chk4c\", \"data\": {}, \"text\": \"上千个光效光晕光斑免扣PNG素材，下载即用\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a44gb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ancgr\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"50l6e\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8stvm\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"865c1\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"frr62\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2fa20\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 3, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"40ibe\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"72qij\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 4, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"7opo6\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190279212_2bd89cf2b1c268d0.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190284052_27d3a4478137153b.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190287541_a7dc444b47e016b0.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"3\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190290578_4f7ce0f11d1f5ab2.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"4\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190293579_316f71c9365481e7.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 5, 0, 0, '2025-08-26 14:39:02', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756190270611_d878bcc2367509e8.png?imageMogr2/format/webp', '通过网盘分享的文件：M002-光效素材 链接: https://pan.baidu.com/s/136tfHSEHNnRlhSPTZKWsqQ?pwd=76mx 提取码: 76mx  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2025-08-26 14:39:02', '2025-10-24 14:42:38'),
(50, 2, 5, '3D人物头像Emoji表情包插画苹果表情icon图标fig免扣PNG设计素材', NULL, '<p></p>\n<p>3D人物头像Emoji表情包插画苹果表情icon图标fig免扣PNG设计素材</p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728333106_4635008f0fcb91f9.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728338382_30c998dbd7f29846.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"1aoem\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9slhc\", \"data\": {}, \"text\": \"3D人物头像Emoji表情包插画苹果表情icon图标fig免扣PNG设计素材\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"aucmv\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5ejh1\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"3krns\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"6jvml\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5pr1m\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728333106_4635008f0fcb91f9.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728338382_30c998dbd7f29846.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 5, 0, 0, '2025-09-01 20:05:46', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728321425_f21026ff0b69157c.png?imageMogr2/format/webp', '通过网盘分享的文件：M003-3D人物头像表情 链接: https://pan.baidu.com/s/1CKecSfkP2LpxZF6NNDJ_Hg?pwd=7ec8 提取码: 7ec8  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2025-09-01 20:05:46', '2026-01-07 18:41:28'),
(51, 2, 5, 'VIP等级会员中心卡片部分PSD、部分Sketch格式素材', NULL, '<p>VIP等级会员中心卡片APP界面设计模板部分PSD、部分Sketch格式素材</p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728539717_76b2c64988fc41af.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728583407_c1f91c54ddb0e318.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728544060_4e44043794a0829a.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728551564_151037135c1ecf12.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"e7qt5\", \"data\": {}, \"text\": \"VIP等级会员中心卡片APP界面设计模板部分PSD、部分Sketch格式素材\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fqc3o\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"cmo4m\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8ksn9\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ajeit\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"vuer\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5hbk2\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a00d8\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 3, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dp8a4\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728539717_76b2c64988fc41af.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728583407_c1f91c54ddb0e318.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728544060_4e44043794a0829a.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"3\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728551564_151037135c1ecf12.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 6, 0, 0, '2025-09-01 20:10:27', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1756728535008_a0323fc9a9e6c169.png?imageMogr2/format/webp', '通过网盘分享的文件：M006-008-VIP等级会员中心卡片APP界面设计模板部分PSD、部分Sketch格式素材 链接: https://pan.baidu.com/s/15J8nQk5LPya89TEP0boxrg?pwd=jsu2 提取码: jsu2  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2025-09-01 20:10:26', '2026-01-07 18:41:32'),
(52, 8, 7, '红色警戒合集-多款安装包', NULL, '<p>红色警戒合集</p>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1763347775005_6b7b716106020c80.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1763347653539_bb8b5e305ff17ddb.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"2imn1\", \"data\": {}, \"text\": \"红色警戒合集\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9ktr6\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"f2igv\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dq9qc\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"psop\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"cvlrv\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a6fio\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dmrls\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1763347775005_6b7b716106020c80.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1763347653539_bb8b5e305ff17ddb.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 11, 0, 0, '2025-11-17 10:47:47', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1763347659154_cbc8c79c92887ba7.png?imageMogr2/format/webp', '通过网盘分享的文件：红警 链接: https://pan.baidu.com/s/1iahvhFEJR4nfe27TCYXkEg?pwd=8cx7 提取码: 8cx7  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2025-11-17 10:47:47', '2025-11-22 10:01:37'),
(53, 9, 8, 'LR预设PS清新通透人像儿童滤镜室外明亮婚礼像素蛋糕调色胶片预设', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951541315_49260f87ad722f05.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951548445_831e7f50228feb9f.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"4q2rf\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"ch0p5\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dg76i\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bchbj\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"f0f14\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951541315_49260f87ad722f05.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951548445_831e7f50228feb9f.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-01 21:12:42', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951534397_f01faabdeb5d2922.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G02清新通透明亮人像【光年视觉室】 链接: https://pan.baidu.com/s/1DfXGXnN5UexDw3GxaWAr4g?pwd=zxjy 提取码: zxjy  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:12:41', '2026-02-01 21:13:01'),
(54, 9, 8, 'PS颜色查找青绿蓝橙电影LR旅拍德味电脑预设滤镜调色像素蛋糕预设', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951838901_b06accaa6c113c9f.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951851110_517fcf201bb01f00.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"1f5do\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"692d3\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"e2mbm\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fjqqf\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"eb2md\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951838901_b06accaa6c113c9f.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951851110_517fcf201bb01f00.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-01 21:17:36', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769951831997_bbafe941705b1876.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G06青绿蓝橙电影高端色调【光年视觉室】 链接: https://pan.baidu.com/s/1OnpvCUN-UX0sHCexVUwxbQ?pwd=imdq 提取码: imdq  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:17:35', '2026-02-01 21:59:32'),
(55, 9, 8, '像素蛋糕预设PS日系复古文艺胶片怀旧薄荷海边照片LR滤镜剪映调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952081262_4392ed45387061dd.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952108902_c424d3bc6b728d2a.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"3845h\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bo0mg\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"lvam\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1hbbf\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8lf70\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952081262_4392ed45387061dd.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952108902_c424d3bc6b728d2a.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-01 21:21:56', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952077069_b1befe4df80654ca.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G18日系怀旧薄荷24款[光年视觉] 链接: https://pan.baidu.com/s/18_f4oR5JmQOWO8QwULHs9A?pwd=nv4k 提取码: nv4k  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:21:55', '2026-02-01 21:59:28'),
(56, 9, 8, 'PS预设城市夜景赛博朋克科幻摄影后期lr手机Camera Raw调色滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952254194_10a313765075a63b.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952269317_50b7be17f267c6e7.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"3hf2f\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fvug\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"a2nj0\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"b64ao\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"fguoe\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952254194_10a313765075a63b.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952269317_50b7be17f267c6e7.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-01 21:24:36', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952250137_ffb9177f9306a776.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G10赛博朋克科幻50款【光年视觉室】 链接: https://pan.baidu.com/s/1K-8yu_13_U7O3J6SBNhgjw?pwd=nxnr 提取码: nxnr  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:24:35', '2026-02-01 21:24:52');
INSERT INTO `material_info` (`id`, `category_id`, `sub_category_id`, `title`, `description`, `content`, `content_raw`, `status`, `view_count`, `favorite_count`, `like_count`, `sort_time`, `extra_data`, `cover_image`, `baidu_pan_url`, `baidu_pan_code`, `author`, `tags`, `create_time`, `update_time`) VALUES
(57, 9, 8, 'ACR日系小清新忧郁蓝色调 Lightroom人像预设情绪静物PS电脑滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952481171_24bae4dcce1aab45.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952486398_514491ae97972577.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"62cf5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"4bi2e\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"cd5g9\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bj73r\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"92bme\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952481171_24bae4dcce1aab45.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952486398_514491ae97972577.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 21:28:20', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952476393_d64d0ec8518427c3.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G25日系经典蓝色调2款[光年视觉] 链接: https://pan.baidu.com/s/14hNRs7NSr2KpJbc6TWjNzA?pwd=he1c 提取码: he1c  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:28:20', '2026-02-01 21:28:20'),
(58, 9, 8, 'PS滨田英明预设 acr 日系小清新明亮文艺人像滤镜Camera Raw调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952687194_be07ff2a4f4a41e7.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952691896_851675d2e8ed7722.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"77jql\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5kmrb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"q82n\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1vnlh\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"acevk\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952687194_be07ff2a4f4a41e7.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952691896_851675d2e8ed7722.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 21:31:55', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952700502_506b792af172748d.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G15滨田英明风10款【光年视觉室】 链接: https://pan.baidu.com/s/1VYJenbUjcB-Umq5wFPircQ?pwd=ip6c 提取码: ip6c  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:31:54', '2026-02-01 21:31:54'),
(59, 9, 8, 'PS预设文艺静物美食日系lr调色PR/FCPX/达芬奇AE手机LUT剪映滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952899475_16d5d1730a5c2e25.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952904064_e0a7a0a8d12b6c82.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"7jjp9\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3c64p\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"f8o3e\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5u4a3\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"stqa\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952899475_16d5d1730a5c2e25.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952904064_e0a7a0a8d12b6c82.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-01 21:35:26', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769952895650_3ae0fdbdaa23429d.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G38ins文艺美食静物38款[光年视觉] 链接: https://pan.baidu.com/s/1ttl_aT9TIXjXNTUyziEyjQ?pwd=d1vp 提取码: d1vp  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 21:35:26', '2026-02-01 21:38:19'),
(60, 9, 8, '影楼预设儿童人像室外文艺胶片绿PR/FCPX达芬奇LUT手机版LR滤镜PS', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959183263_bd9048f074b68198.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959189259_5e984195f13708b5.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"5no5u\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"4c59u\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"79iov\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"c7btp\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"7fu4m\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959183263_bd9048f074b68198.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959189259_5e984195f13708b5.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:20:06', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959178503_94d17cf99f306f23.jpg?imageMogr2/format/webp', '通过网盘分享的文件：B21森系文艺胶片绿  [光年视觉] 链接: https://pan.baidu.com/s/17fzCIhZ1nWRh5811DTcQiQ?pwd=a545 提取码: a545  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:20:06', '2026-02-01 23:20:06'),
(61, 9, 8, 'PS电脑日系温柔樱花粉风景人像调色手机LR预设Camera Raw胶片滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959559073_2c3675b1ebc77ea9.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959563725_14091de0cde7987c.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"eqo1p\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"6bpoe\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5alv7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2p5ls\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2dfam\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959559073_2c3675b1ebc77ea9.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959563725_14091de0cde7987c.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:26:10', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769959553183_2fc1ea41910f842d.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G07日系温柔樱花粉20款【光年视觉室】 链接: https://pan.baidu.com/s/1RxER4hiXWay8-h0iCb9PRg?pwd=rh7g 提取码: rh7g  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:26:09', '2026-02-01 23:26:09'),
(62, 9, 8, 'LR预设日系清新漫画风PS动漫街拍风光像素蛋糕滤镜PR/FCPX达芬奇', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960012735_5d43f624d0e435bc.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960017048_0880942e79fa2de3.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"346ug\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"d5c52\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"fsf39\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"b1ekb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"gu7p\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960012735_5d43f624d0e435bc.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960017048_0880942e79fa2de3.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:33:48', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960007943_1c3ddb9a9226f436.jpg?imageMogr2/format/webp', '通过网盘分享的文件：B26日系清新漫画风[光年视觉] 链接: https://pan.baidu.com/s/1AOxbCwDgJ-xx5L_1skPTVw?pwd=7p8r 提取码: 7p8r  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:33:47', '2026-02-01 23:33:47'),
(63, 9, 8, '旅行博主粉色日出日落LR预设旅拍风景PS调色滤镜PR/FCPX达芬奇LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960173920_11a2d04f8edad1c1.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960178363_4191501265374481.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"84er6\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7u60u\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"52hf4\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"cmmfh\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ers4s\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960173920_11a2d04f8edad1c1.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960178363_4191501265374481.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:36:26', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960168992_4bc2c119dda490a7.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G97粉调日出日落[光年视觉] 链接: https://pan.baidu.com/s/1kPAIrCmXF3C4HiJIEq0Fag?pwd=ky9s 提取码: ky9s  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:36:25', '2026-02-01 23:36:25'),
(64, 9, 8, 'LR预设调色PS滤镜日系复古风电影胶片人像写真像素蛋糕PS预设LUT', NULL, '<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960281205_8449784b0ab3c7d1.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960465835_4b9318738bb2d538.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960472860_d908b34377466590.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960479037_9bc2c75fe7f20ffe.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960485403_6ed524f4239e4679.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960492162_831bb658c97a938e.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960498650_b1ece8d3295cab42.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"2l7sd\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"b56q5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3qncb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"60r38\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"epjlm\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"6v1vq\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9s9c9\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"ah2d6\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"54d7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fet8e\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 3, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"6bh66\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"44veo\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 4, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9rb4q\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8u63m\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 5, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"aahiq\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"jpme\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 6, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ebmbn\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960281205_8449784b0ab3c7d1.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960465835_4b9318738bb2d538.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960472860_d908b34377466590.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"3\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960479037_9bc2c75fe7f20ffe.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"4\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960485403_6ed524f4239e4679.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"5\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960492162_831bb658c97a938e.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"6\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960498650_b1ece8d3295cab42.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:42:08', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960269053_6d8b819a5295ec4d.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G35日系电影胶片17款[光年视觉] 链接: https://pan.baidu.com/s/1Fz_rbvA3H3IF5iGUEf1vbQ?pwd=rb3n 提取码: rb3n  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:42:07', '2026-02-01 23:42:07'),
(65, 9, 8, 'PS预设青橙都市电影冷暖色调手机lr城市建筑Camera Raw调色滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960611671_cc29e357039a2410.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960616080_656a7213a6a6f132.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"8qo2f\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5jaqu\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"c68lo\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"4vopv\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"6n10p\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960611671_cc29e357039a2410.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960616080_656a7213a6a6f132.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:43:54', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960603912_de398e78f999e669.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G28都市街拍电影冷暖色调7款[光年视觉] 链接: https://pan.baidu.com/s/1axGTXyFpLgowUhN2LfZMfg?pwd=sg26 提取码: sg26  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:43:54', '2026-02-01 23:43:54'),
(66, 9, 8, '法式胶片高级感人像静物PS调色LR复古预设Camera Raw胶片剪映滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960747912_c3a2116f503ca9da.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960751885_be4be810092ad49f.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"8um8\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1uksm\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"22k3h\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"82jhb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"a67fk\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960747912_c3a2116f503ca9da.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960751885_be4be810092ad49f.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-01 23:46:08', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960743409_ffd5bc054ea5e2d3.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G08法式胶片人像8款【光年视觉室】 链接: https://pan.baidu.com/s/1Di8AT3OhYxLVqYi8O-8tjA?pwd=xwah 提取码: xwah  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:46:07', '2026-02-01 23:51:12'),
(67, 9, 8, '暗黑橙金建筑城市电脑手机lr预设滤镜PS色调像素蛋糕街拍夜景预设', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960852113_0bf406f7537f596b.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960856396_dbb3204ac684efca.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"19ol1\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"d3imj\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"d8laa\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8du8b\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dbd88\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960852113_0bf406f7537f596b.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960856396_dbb3204ac684efca.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:47:49', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960845775_7e7e4cd65fca7cc9.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G46暗黑橙金城市建筑12款[光年视觉] 链接: https://pan.baidu.com/s/1GoRpMoYQgYFqpudfNRrylw?pwd=ygnj 提取码: ygnj  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:47:49', '2026-02-01 23:47:49'),
(68, 9, 8, 'LR调色滤镜橙蓝夜景城市风景人像街拍手机电脑PS视频lut预设ACR', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960964717_7cafd7f346ea0a81.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960969686_d2796a327a5f3e40.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"figv9\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bcaem\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"bjpdf\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a1pmm\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9tg4m\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960964717_7cafd7f346ea0a81.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960969686_d2796a327a5f3e40.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:49:53', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769960959420_75174f26fdd3d744.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G67ins高级橙蓝色调[光年视觉] 链接: https://pan.baidu.com/s/1v2doSVp1xuPDmuVbDw4o2A?pwd=b6wa 提取码: b6wa  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:49:52', '2026-02-01 23:49:52'),
(69, 9, 8, 'LR预设日系胶片复古人像写真街拍PR/FCPX调色电影滤镜PS像素蛋糕', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961435498_9f02c2e83e69f8af.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961439833_38b3d2b5553ff32a.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"7imve\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5v6j5\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2n0jb\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"67qmu\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9hs37\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961435498_9f02c2e83e69f8af.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961439833_38b3d2b5553ff32a.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:57:41', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961429495_f8a0554022656dc5.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G60日系复古胶片40款[光年视觉] 链接: https://pan.baidu.com/s/1AlqQxMJNz0kqJ6KsePC25g?pwd=n5dc 提取码: n5dc  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:57:41', '2026-02-01 23:57:41'),
(70, 9, 8, '影楼ps调色滤镜日系通透明亮清新人像摄影PS后期lr预设胶片调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961541529_9758a056eca83390.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961546234_b1ab563062c7117f.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"25stq\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dlfr7\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8rl5p\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"22hsj\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"pfhv\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961541529_9758a056eca83390.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961546234_b1ab563062c7117f.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-01 23:59:39', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961536954_63c647a07a1a3580.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G61日系轻透明亮40款[光年视觉] 链接: https://pan.baidu.com/s/1m7r15wzDGe4XjMA_Nr9Yug?pwd=zd3c 提取码: zd3c  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-01 23:59:39', '2026-02-01 23:59:39'),
(71, 9, 8, 'lr预设淡彩糖果色手机人像风景建筑街拍PS调色像素蛋糕滤镜LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961671116_a6adb2ac3191cfba.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961676623_aa8bf561cd3f5856.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"fk5b1\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"f8luq\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"4i6ql\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"37eom\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"djgh0\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961671116_a6adb2ac3191cfba.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961676623_aa8bf561cd3f5856.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-02 00:01:36', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961664235_81ccbfa4136bc6d1.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G66淡彩糖果色10款[光年视觉] 链接: https://pan.baidu.com/s/1r6_ICJSi02j1GFSczeqMZA?pwd=jtbq 提取码: jtbq  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-02 00:01:35', '2026-02-02 00:01:35'),
(72, 9, 8, 'PS预设小清新儿童室内温暖日系手机LR调色滤镜PS颜色查找剪映LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961765582_367a8e2e287c0b94.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961770190_ab3c4ee7a25838f1.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"bvonl\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"27c2i\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5iobi\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5nssi\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"1a4na\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961765582_367a8e2e287c0b94.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961770190_ab3c4ee7a25838f1.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-02 00:03:00', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961761464_2ccba7d05dd6e8d8.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G68ins儿童温暖清新[光年视觉] 链接: https://pan.baidu.com/s/1Oyx_0XYasI9opXD3yk20pg?pwd=7g3m 提取码: 7g3m  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-02 00:03:00', '2026-02-02 00:03:00'),
(73, 9, 8, 'LR人像预设PS明亮清新宝宝室内外通透FCPX手机滤镜PR调色剪映LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961869210_ef9c7aaf25168f05.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961873869_fe2d9e59754431a2.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"5s5d3\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5i6te\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"6ivic\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"f314r\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"1gu08\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961869210_ef9c7aaf25168f05.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961873869_fe2d9e59754431a2.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-02 00:04:49', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961845497_bb49ee9e8ff41160.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G74明亮清新人像[光年视觉] 链接: https://pan.baidu.com/s/1cHoR4YWEdLaz-WmNUjHTcQ?pwd=ibry 提取码: ibry  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-02 00:04:48', '2026-02-02 00:04:48'),
(74, 9, 8, 'LR预设清新白色静物宜家风旅拍app手机版FCPX滤镜PR调色PS剪映LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961955946_e7493f0f3b03217c.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961960249_21e6f0fdf1200061.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"2n8vl\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bp6k9\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"a83pu\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bro3n\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"d0c8j\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961955946_e7493f0f3b03217c.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961960249_21e6f0fdf1200061.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-02 00:06:10', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769961950458_bd6d97d2a88a257d.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G75清新极简纯白[光年视觉] 链接: https://pan.baidu.com/s/1iPiNsrniav8XXAA-ba-4Rw?pwd=6afk 提取码: 6afk  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-02 00:06:10', '2026-02-02 00:06:10'),
(75, 9, 8, 'LR预设ACR日系电影忧郁蓝紫色滤镜PR/FCPX达芬奇AEPS颜色查找调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962041761_4ac7f94b6f0e997c.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962046663_f43699ad544f9fb8.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"38hil\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3e68h\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"budgn\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5sp0k\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"av7q7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962041761_4ac7f94b6f0e997c.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962046663_f43699ad544f9fb8.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-02 00:07:47', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962037232_6cf5df97e340db23.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G76雾霾忧郁蓝调[光年视觉] 链接: https://pan.baidu.com/s/1lB6qqqSul7zYN-3JdJNYZA?pwd=x4b6 提取码: x4b6  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-02 00:07:47', '2026-02-02 00:07:47');
INSERT INTO `material_info` (`id`, `category_id`, `sub_category_id`, `title`, `description`, `content`, `content_raw`, `status`, `view_count`, `favorite_count`, `like_count`, `sort_time`, `extra_data`, `cover_image`, `baidu_pan_url`, `baidu_pan_code`, `author`, `tags`, `create_time`, `update_time`) VALUES
(76, 9, 8, 'LR预设暗调胶片纪实街拍达芬奇FCPX滤镜PR调色ps颜色查找剪映LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962136408_ed78d32898944048.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962140795_a074141039b4974d.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"ajgtc\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"cg6aq\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2qan5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a60uk\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"bn4ci\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962136408_ed78d32898944048.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962140795_a074141039b4974d.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 2, 0, 0, '2026-02-02 00:09:12', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1769962133225_d0ae8488f4d2c1c3.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G77暗调电影胶片纪实[光年视觉] 链接: https://pan.baidu.com/s/1g3-5ovR4LZ5srn2UE6HrBw?pwd=bmhn 提取码: bmhn  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-02 00:09:12', '2026-02-02 00:11:51'),
(77, 10, 9, '批量修改名图片文件时间重命名编号替换更名文本档属性删除软件', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049312961_91bbd48dd69f0923.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049416860_28a4faca8fa355d0.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049424437_037196eb32a0f4ee.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"9s36e\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2ecb6\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"67kl5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a19iq\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ftg8a\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"730ac\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"f5hhp\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049312961_91bbd48dd69f0923.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049416860_28a4faca8fa355d0.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049424437_037196eb32a0f4ee.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 3, 0, 0, '2026-02-03 00:23:50', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049301302_2d2c82d89b89fd02.png?imageMogr2/format/webp', '通过网盘分享的文件：菲菲批量修改文件名 链接: https://pan.baidu.com/s/1RTCaWoVN8PS12wRb3K-DhQ?pwd=n9mz 提取码: n9mz  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:23:50', '2026-03-09 18:28:09'),
(78, 10, 9, '文件夹文件一键批量改名重命名工具前扩展名添加删除替换修改软件', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049866797_a5521da180b0d893.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049873419_e5ef22c279eb0a71.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049879044_ee2b0b882cb1ca05.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049953056_903e53bb8179a88a.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049969216_5ca0e5ec87d868b1.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049885404_4d306af36a2ef052.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050038630_778fd0e48798b3b7.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050091144_b6db324a2d08ba88.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"2h5v0\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5tabn\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"86gmh\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1e7q2\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"63pue\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"4s3p5\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5ekb8\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2mt4c\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 3, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"74gls\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8ljej\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 4, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"bh14j\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fp6no\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 5, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"6vrcg\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dj01q\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 6, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"39lag\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5ru3s\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 7, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8gibf\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049866797_a5521da180b0d893.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049873419_e5ef22c279eb0a71.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049879044_ee2b0b882cb1ca05.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"3\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049953056_903e53bb8179a88a.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"4\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049969216_5ca0e5ec87d868b1.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"5\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049885404_4d306af36a2ef052.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"6\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050038630_778fd0e48798b3b7.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"7\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050091144_b6db324a2d08ba88.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 2, 0, 0, '2026-02-03 00:35:14', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049857860_660cbcbd624585bf.jpg?imageMogr2/format/webp', '通过网盘分享的文件：文件文件夹重命名软件 链接: https://pan.baidu.com/s/14b9VKWX4DJ-h2U5Ig5k6aw?pwd=uq7u 提取码: uq7u  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:35:13', '2026-02-03 00:37:32'),
(79, 9, 8, 'PS颜色查找预设梅子粉色美食旅拍LR手机FCPX滤镜PR调色LUT剪映', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050402912_e46f63d41874ccb7.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050429406_2149a05d70bf8675.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"1bfn1\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"1vppm\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"7ndh0\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"d8ukb\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8rdf7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050402912_e46f63d41874ccb7.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050429406_2149a05d70bf8675.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:41:20', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050396292_4e29abdb1a5b9899.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G87梅子粉色调[光年视觉] 链接: https://pan.baidu.com/s/1jiK8iTctw3Wv5P6NO9eGlQ?pwd=x2vf 提取码: x2vf  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:41:20', '2026-02-03 00:41:20'),
(80, 9, 8, 'PS颜色查找预设咖啡馆静物美食暗冷色调PR/FCPX达芬奇LUT/LR调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050554396_90e2fcb7af12fbdb.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050558466_15a6a059bdebef31.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"lnj7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"4v0ej\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"7b19p\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7fnag\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"7u5q6\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050554396_90e2fcb7af12fbdb.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050558466_15a6a059bdebef31.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:42:53', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050550065_31e9daf279a5a270.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G88 咖啡静物美食[光年视觉] 链接: https://pan.baidu.com/s/1guhq_-C_T8z9wYk_47PeIA?pwd=nuiv 提取码: nuiv  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:42:53', '2026-02-03 00:42:53'),
(81, 9, 8, 'PS预设港风电影胶片王家卫怀旧LR人像写真像素蛋糕调色滤镜LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050649989_927af0205e084ede.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050654290_55909d8a40336c43.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"edhut\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5aegt\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2j30f\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fvnjh\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"4gepr\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050649989_927af0205e084ede.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050654290_55909d8a40336c43.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:44:28', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050645263_53b6413f11fafe88.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G93王家卫香港电影[光年视觉] 链接: https://pan.baidu.com/s/1C0t9m1QMnWJV0f5BhbwHTA?pwd=87ax 提取码: 87ax  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:44:27', '2026-02-03 00:44:27'),
(82, 9, 8, 'PS预设LR纪实HDR人文金属感高级灰FCPX手机滤镜PR调色剪映LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050736143_07966d181053b0a0.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050741804_c76b6bf3d0aee3bc.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"6kdq1\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"6cpg7\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"d34po\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"25qst\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"3cja5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050736143_07966d181053b0a0.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050741804_c76b6bf3d0aee3bc.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:46:29', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050729665_b5fd30458f9b3341.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G98金属感高级灰色调[光年视觉] 链接: https://pan.baidu.com/s/1ULLl0XkiIvYYTYoZ8OaDoA?pwd=xujn 提取码: xujn  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:46:29', '2026-02-03 00:46:29'),
(83, 9, 8, 'PS胶片滤镜灰棕色低饱和人像静物预设PR/FCPX达芬奇LUT视频调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050860865_bf483b2a0457596d.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"1asig\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2rvts\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2raui\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050860865_bf483b2a0457596d.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:47:54', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050855868_516951b92e31aa01.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G96胶片灰棕低饱和[光年视觉] 链接: https://pan.baidu.com/s/1zE6hbaXU8zreQYRUBP_sHg?pwd=twfu 提取码: twfu  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:47:53', '2026-02-03 00:47:53'),
(84, 9, 8, 'ACR暖粉柔和白色系LR预设室内外人像明亮色调PS颜色查找滤镜调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050968410_8e2aac8a858dff50.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050952607_cdaaa9e6e7121a25.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"92psd\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"945af\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"b7qoq\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"c31nm\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"85l3h\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050968410_8e2aac8a858dff50.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050952607_cdaaa9e6e7121a25.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:49:34', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770050937641_471b5a4fdee20d37.jpg?imageMogr2/format/webp', '通过网盘分享的文件：G103暖粉柔和明亮色调[光年视觉] 链接: https://pan.baidu.com/s/1esBXwffypMK8A1i1fjehAg?pwd=yp6u 提取码: yp6u  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:49:33', '2026-02-03 00:49:33'),
(85, 9, 8, '预设lr高级感PS暗青人文街拍纪实电影质感调色PR/达芬奇/LUT滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051152990_43642068d9043787.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051157004_16de69bb547b06d7.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"clog6\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3hbnl\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9tv3v\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8fsfj\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"58jqa\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051152990_43642068d9043787.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051157004_16de69bb547b06d7.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:52:41', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051148286_b5b13577b199d64b.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A01  暗青人文街拍[光年视觉] 链接: https://pan.baidu.com/s/1QU0Pa_XCsbK2kv4bDckk5Q?pwd=c2w2 提取码: c2w2  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:52:41', '2026-02-03 00:52:41'),
(86, 9, 8, 'LR预设PS城市纪实港风夜景胶片FCPX达芬奇手机版APP滤镜PR调色LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051231842_73a032ae122e3ec6.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051236120_335b803c544181ad.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"andsv\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8icbt\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"6g7mf\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"51ia8\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9c4qj\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051231842_73a032ae122e3ec6.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051236120_335b803c544181ad.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:54:11', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051225019_87171539137c53d1.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A02  城市胶片街拍[光年视觉] 链接: https://pan.baidu.com/s/1YQUv3ZyiVso94RhLhO9ekQ?pwd=72he 提取码: 72he  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:54:10', '2026-02-03 00:54:10'),
(87, 9, 8, 'PS颜色查找像素蛋糕预设青橙色LR人文纪实风景PR/FCPX滤镜LUT调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051336702_018132ca3f90d66d.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051340762_32778d5ea7b3e1a4.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"49lq7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"6enpe\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"1ceu7\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"58hjl\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9ea5a\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051336702_018132ca3f90d66d.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051340762_32778d5ea7b3e1a4.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 00:55:52', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051332812_146b8460de32e51b.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A12青橙人文纪实[光年视觉] 链接: https://pan.baidu.com/s/1vCRJ9NPFn4lsoDmMI0mMRA?pwd=nw27 提取码: nw27  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:55:51', '2026-02-03 00:55:51'),
(88, 9, 8, 'LR人像滤镜PS日系复古小清新写真预设PR/FCPX达芬奇像素蛋糕预设', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051429013_c35b5b35e7aa0309.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051433001_d6089c98764fa366.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"2jrk5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"4sj2p\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"fphdq\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"877q0\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"eb27b\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051429013_c35b5b35e7aa0309.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051433001_d6089c98764fa366.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-03 00:57:43', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051423014_a8679001b83e5dfc.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A13日系复古小清新[光年视觉] 链接: https://pan.baidu.com/s/1C--7vaj6njOLrl8BxSb_sw?pwd=wnat 提取码: wnat  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 00:57:43', '2026-02-03 00:57:54'),
(89, 9, 8, 'LR预设森系复古胶片人像日系小清新PR/FCPX手机调色PS/ACR滤镜LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051633275_2d94365c97512b88.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051637748_fbae2d15892a65ba.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"5ea88\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"fqti9\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5gm9v\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3o4tk\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"103co\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051633275_2d94365c97512b88.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051637748_fbae2d15892a65ba.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 01:00:51', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051627831_2e8577ccbdf1e0a8.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A23复古唯美森系胶片[光年视觉] 链接: https://pan.baidu.com/s/1DTIQ3Nqkf-dMKxX6UNwg_A?pwd=3876 提取码: 3876  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 01:00:51', '2026-02-03 01:00:51'),
(90, 9, 8, 'PS预设夜景弱光人像街拍摄LR/PR/FCPX/达芬奇/LUT电脑调色滤镜', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051730417_5bf5a9c0768008b0.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051734142_0760f38ef3ce47a4.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"ap3u\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"5f5fk\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"9qmib\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"cpo62\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2snip\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051730417_5bf5a9c0768008b0.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051734142_0760f38ef3ce47a4.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 01:02:47', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051721022_0420dfad0dcbcec5.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A35夜景弱光人像[光年视觉] 链接: https://pan.baidu.com/s/1HEmPDesepAbc0lzNOSV1yg?pwd=p42t 提取码: p42t  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 01:02:47', '2026-02-03 01:02:47'),
(91, 9, 8, '像素蛋糕电影情绪室内人像PR/FCPX达芬奇LUT/PS手机LR滤镜视频', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051825564_3f7ad8141876920f.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051829738_c54e81e3ed196d8e.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"1a1en\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"8lqgh\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5ivct\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"cjm0r\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8j2vq\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051825564_3f7ad8141876920f.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051829738_c54e81e3ed196d8e.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 01:04:06', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051813832_b93041682af9afde.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A19电影情绪人像[光年视觉] 链接: https://pan.baidu.com/s/1ABceoLkf3R7iLvImR8ghdg?pwd=cwh5 提取码: cwh5  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 01:04:05', '2026-02-03 01:04:05'),
(92, 9, 8, 'LR预设PS日系清新明亮暖色胶片人像儿童通透手机滤镜视频调色LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051937736_0b0a91daf17ef9dd.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"7k8ea\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3u4r2\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2mlkb\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051937736_0b0a91daf17ef9dd.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 0, 0, 0, '2026-02-03 01:05:59', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770051932557_3b31d544eb152ee4.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A21明亮清新暖色[光年视觉] 链接: https://pan.baidu.com/s/1NOLc508SFzW474DcMO3cyA?pwd=7ih3 提取码: 7ih3  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 01:05:58', '2026-02-03 01:05:58'),
(93, 9, 8, 'PS颜色查找预设暗墨茶橙旅拍航拍风景人像街拍手机LR调色滤镜LUT', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052011664_ae1ff1ac8caba14c.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"cmbqn\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3g438\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dhste\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052011664_ae1ff1ac8caba14c.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 2, 0, 0, '2026-02-03 01:07:10', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052014990_9c9c310bb2b70286.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A28暗墨茶橙色调[光年视觉] 链接: https://pan.baidu.com/s/1SeN1oWbKwBlhhjP_3g-OeA?pwd=ppp5 提取码: ppp5  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 01:07:09', '2026-03-10 11:08:36'),
(94, 9, 8, 'Lr预设日系情绪胶片PS婚礼人像滤镜Fcpx达芬奇Pr Lut视频手机调色', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052103914_5050256ec96761a0.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"10k7k\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dejrt\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"2bnr2\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052103914_5050256ec96761a0.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 4, 0, 0, '2026-02-03 01:08:36', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052098504_2719d4fe504b9748.jpg?imageMogr2/format/webp', '通过网盘分享的文件：A36日系情绪胶片[光年视觉] 链接: https://pan.baidu.com/s/1BmzGO7yjmx8uifNvtKui1w?pwd=4haa 提取码: 4haa  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-03 01:08:36', '2026-03-09 23:49:06'),
(95, 3, 2, '健康饮食APP小程序UI界面作业figma/psd/xd设计素材模板源文件', NULL, '<p></p>\n<p></p>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569288495_644dff336350c556.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"a94k5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"3doa8\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"6dagn\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bcj8o\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"d5e5p\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569288495_644dff336350c556.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 5, 0, 0, '2026-02-09 00:29:39', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569281628_2706fc7a65dac494.jpg?imageMogr2/format/webp', '通过网盘分享的文件：00008健康饮食app 链接: https://pan.baidu.com/s/1Qmn32uaq4YXll44r3rxzBQ?pwd=53hc 提取码: 53hc  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2026-02-09 00:29:38', '2026-03-09 18:28:41'),
(96, 3, 2, '健身运动锻炼饮食管理APP小程序UI界面PSD/figma/xd设计素材模板', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569689864_05eb9e1451737524.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"fu5jt\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7ghkg\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"sp05\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569689864_05eb9e1451737524.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 4, 0, 0, '2026-02-09 00:54:55', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569682744_bd05009e93fbcff6.jpg?imageMogr2/format/webp', '通过网盘分享的文件：00010健身应用 链接: https://pan.baidu.com/s/1Yc6Xv907xZAlD-X-T0eDaw?pwd=gghf 提取码: gghf  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-09 00:54:55', '2026-03-09 18:28:37');
INSERT INTO `material_info` (`id`, `category_id`, `sub_category_id`, `title`, `description`, `content`, `content_raw`, `status`, `view_count`, `favorite_count`, `like_count`, `sort_time`, `extra_data`, `cover_image`, `baidu_pan_url`, `baidu_pan_code`, `author`, `tags`, `create_time`, `update_time`) VALUES
(97, 3, 2, '100页整套人工智能生成式AI艺术绘画图片App界面UI/Figma设计素材', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570816795_e1947e7d8adeb9f8.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570824513_20b6b37b2775dd87.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570036825_d21f2404c523e0e2.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"3n6u4\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7gnem\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"51f77\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"bfrjo\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"295de\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"595ro\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 2, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"c01oc\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570816795_e1947e7d8adeb9f8.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570824513_20b6b37b2775dd87.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"2\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570036825_d21f2404c523e0e2.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 3, 0, 0, '2026-02-09 01:01:22', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770570029178_f84c31fb2dcdfa31.jpg?imageMogr2/format/webp', '通过网盘分享的文件：00956 人工智能艺术绘画图片在线生成 UI 套件 链接: https://pan.baidu.com/s/1CDq54aNwZ2UCh8dEiOQkOg?pwd=74ak 提取码: 74ak  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2026-02-09 01:01:22', '2026-03-09 16:04:11'),
(99, 3, 2, '人工智能管理平台网站官网PC端+App移动端UI界面Figma设计素材', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571135308_885516f274894386.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"1pdiu\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a22d0\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"bgpsn\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571135308_885516f274894386.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 2, 0, 0, '2026-02-09 01:17:23', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571022450_40f948563a15d88f.jpg?imageMogr2/format/webp', '通过网盘分享的文件：01588人工智能管理平台网站 链接: https://pan.baidu.com/s/1_fEIHAKynxs8RfdHbfwYNQ?pwd=qjuh 提取码: qjuh  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2026-02-09 01:17:22', '2026-02-09 01:19:02'),
(100, 3, 2, '中世纪手机纸牌卡牌游戏组件APP手机UI界面套件Figma设计素材模板', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571321695_f96aa5ab342f0157.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"f2028\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"a731a\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"8ek84\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571321695_f96aa5ab342f0157.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 1, 0, 0, '2026-02-09 01:22:13', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571389026_ac122c0c1f898638.jpg?imageMogr2/format/webp', '通过网盘分享的文件：02191中世纪手机纸牌卡牌游戏APP 链接: https://pan.baidu.com/s/1G2YMkneSCG7abDgQvDny9w?pwd=th1j 提取码: th1j  --来自百度网盘超级会员v4的分享', NULL, NULL, '', '2026-02-09 01:22:13', '2026-02-09 01:23:15'),
(101, 3, 2, '37页整套交友社交短视频直播App界面UI设计套件Figma设计素材模板', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571558575_e4dded3cef8b2c85.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"akk1n\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"7gl5c\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"5davj\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571558575_e4dded3cef8b2c85.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 3, 0, 0, '2026-02-09 01:26:42', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571562311_edc1cf92cb378dcc.jpg?imageMogr2/format/webp', '通过网盘分享的文件：01286 约会交友社交短视频 UI 套件 链接: https://pan.baidu.com/s/11Y4viy59I33WYgvlG_AqGw?pwd=xwuy 提取码: xwuy  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-09 01:26:41', '2026-03-09 15:54:25'),
(102, 3, 2, '音频电子书在线阅读收听移动端APP界面UI设计素材模板figma/PSD', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571787820_9663612d0e14089e.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571797613_7931b9fe3c0a2367.png?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"f4rui\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"9hkvd\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"a4gr9\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"2ipul\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 1, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"ekq4m\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571787820_9663612d0e14089e.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}, \"1\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571797613_7931b9fe3c0a2367.png?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 2, 0, 0, '2026-02-09 01:31:22', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770571868109_2e231c473e4b3b95.jpg?imageMogr2/format/webp', '通过网盘分享的文件：01181 电子书音频App 链接: https://pan.baidu.com/s/1mq4_v0DFImp2LJ4_B7nZqA?pwd=ukd6 提取码: ukd6  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-09 01:31:22', '2026-03-09 16:11:03'),
(103, 3, 2, '在线教育APP小程序线上课程讲师培训UI界面sketch/xd设计素材模板', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572088989_016aea4cd212ac0e.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"13i3o\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"dnebl\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"dcsq5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572088989_016aea4cd212ac0e.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 3, 0, 0, '2026-02-09 01:35:19', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572103251_7471a6c82b5bb153.jpg?imageMogr2/format/webp', '通过网盘分享的文件：00633在线教育APP 链接: https://pan.baidu.com/s/1IQOlRU7mGP3r0BYlyDaKhw?pwd=3uhb 提取码: 3uhb  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-09 01:35:18', '2026-03-09 18:28:32'),
(104, 3, 2, '潮流音乐播放APP移动端界面UI作业面试Figma/PSD/XD设计素材模板', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572273378_40a56abdd21e95c0.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"4i4n5\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"b0863\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"cclb\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572273378_40a56abdd21e95c0.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 8, 0, 0, '2026-02-09 01:38:14', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572277825_2cd897362e83e4f9.jpg?imageMogr2/format/webp', '通过网盘分享的文件：00628 音乐APP 链接: https://pan.baidu.com/s/1cJ4gcnQ4gfAG0vijAdjfPw?pwd=texy 提取码: texy  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-09 01:38:14', '2026-03-10 11:07:04'),
(105, 3, 2, '60页健身房运动锻炼数据统计分析App界面UI套件Figma设计素材模板', NULL, '<p></p>\n<img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572466141_c08046ad145f6bf7.jpg?imageMogr2/format/webp\" alt=\"\" style=\"height: auto;width: 100%\"/>\n<p></p>\n', '{\"blocks\": [{\"key\": \"fhcdi\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}, {\"key\": \"b2jls\", \"data\": {}, \"text\": \" \", \"type\": \"atomic\", \"depth\": 0, \"entityRanges\": [{\"key\": 0, \"length\": 1, \"offset\": 0}], \"inlineStyleRanges\": []}, {\"key\": \"f18l3\", \"data\": {}, \"text\": \"\", \"type\": \"unstyled\", \"depth\": 0, \"entityRanges\": [], \"inlineStyleRanges\": []}], \"entityMap\": {\"0\": {\"data\": {\"alt\": \"\", \"src\": \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572466141_c08046ad145f6bf7.jpg?imageMogr2/format/webp\", \"width\": \"100%\", \"height\": \"auto\", \"margin\": \"16px 0\", \"borderRadius\": \"4px\"}, \"type\": \"IMAGE\", \"mutability\": \"IMMUTABLE\"}}}', 1, 59, 0, 0, '2026-02-09 01:41:28', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572470215_56326124c70206b7.jpg?imageMogr2/format/webp', '通过网盘分享的文件：01130 健身房运动锻炼数据统计分析 UI 套件 链接: https://pan.baidu.com/s/13S7ryhH1qtiq6m4yvSnYXQ?pwd=is2c 提取码: is2c  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-02-09 01:41:27', '2026-03-10 22:50:43'),
(106, 10, 10, 'Clawbot部署教程电子版', NULL, '<p><img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051481784_eec4c414bb96578d.png\" alt=\"图片描述\" data-href=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051481784_eec4c414bb96578d.png\" style=\"\"/></p><p><img src=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051546354_ae8fb001e5022cab.png\" alt=\"图片描述\" data-href=\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051546354_ae8fb001e5022cab.png\" style=\"\"/></p><p>✅ 1. Clawbot部署教程电子版，主打AI私人助理搭建与自动化办公，适配Mac/Windows/Linux系统，支持Telegram/WhatsApp/Slack/Discord等多端使用，操作简单小白也能轻松上手，30分钟即可完成部署；</p><p><br></p><p>✅ 2. 教程核心干货：一键安装仅需复制粘贴命令，无需复杂操作；支持Claude/Gemini/Ollama等多模型，可灵活选择适配需求；多端同步实现消息秒回，是办公效率提升神器；</p><p><br></p><p>✅ 3. 涵盖Clawdbot快速部署、全天自动任务设置、远程配置、AI Agent智能体搭建全流程内容，Clawdbot平台实用Skills工具包，实操性拉满；</p><p><br></p><p>✅ 4. 适配人群：AI私人助理搭建需求者、自动化办公从业者、效率工具爱好者，轻松实现办公与任务的智能自动化。</p>', '{\"html\": \"<p><img src=\\\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051481784_eec4c414bb96578d.png\\\" alt=\\\"图片描述\\\" data-href=\\\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051481784_eec4c414bb96578d.png\\\" style=\\\"\\\"/></p><p><img src=\\\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051546354_ae8fb001e5022cab.png\\\" alt=\\\"图片描述\\\" data-href=\\\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051546354_ae8fb001e5022cab.png\\\" style=\\\"\\\"/></p><p>✅ 1. Clawbot部署教程电子版，主打AI私人助理搭建与自动化办公，适配Mac/Windows/Linux系统，支持Telegram/WhatsApp/Slack/Discord等多端使用，操作简单小白也能轻松上手，30分钟即可完成部署；</p><p><br></p><p>✅ 2. 教程核心干货：一键安装仅需复制粘贴命令，无需复杂操作；支持Claude/Gemini/Ollama等多模型，可灵活选择适配需求；多端同步实现消息秒回，是办公效率提升神器；</p><p><br></p><p>✅ 3. 涵盖Clawdbot快速部署、全天自动任务设置、远程配置、AI Agent智能体搭建全流程内容，Clawdbot平台实用Skills工具包，实操性拉满；</p><p><br></p><p>✅ 4. 适配人群：AI私人助理搭建需求者、自动化办公从业者、效率工具爱好者，轻松实现办公与任务的智能自动化。</p>\"}', 1, 15, 0, 0, '2026-03-09 18:19:49', NULL, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051458097_5f44f4507c0774ad.png', '通过网盘分享的文件：Clawdbot保姆级部署.zip 链接: https://pan.baidu.com/s/1VFXw3MOJ0cgmGssajGFxxw?pwd=2jf3 提取码: 2jf3  --来自百度网盘超级会员v4的分享', NULL, NULL, NULL, '2026-03-09 18:19:49', '2026-03-10 14:43:06');

-- --------------------------------------------------------

--
-- 表的结构 `material_subcategory`
--

CREATE TABLE `material_subcategory` (
  `id` int(11) NOT NULL COMMENT '主键ID',
  `category_id` int(11) NOT NULL COMMENT '所属一级分类ID',
  `name` varchar(100) NOT NULL COMMENT '二级分类名称',
  `sort_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态(0:禁用,1:启用)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资料二级分类表';

--
-- 转存表中的数据 `material_subcategory`
--

INSERT INTO `material_subcategory` (`id`, `category_id`, `name`, `sort_order`, `description`, `status`, `create_time`, `update_time`) VALUES
(1, 2, '背景图', 0, NULL, 1, '2025-06-22 22:18:09', '2026-03-08 17:20:42'),
(2, 3, 'APP小程序', 5, NULL, 1, '2025-06-22 22:42:40', '2026-03-08 17:13:50'),
(3, 3, 'UI素材', 0, NULL, 1, '2025-06-22 23:29:16', '2026-02-09 01:46:54'),
(4, 2, '样机', 0, NULL, 1, '2025-07-01 11:43:15', '2025-07-01 11:43:15'),
(5, 2, '素材', 0, NULL, 1, '2025-07-14 14:59:02', '2025-07-14 14:59:02'),
(6, 7, '动漫', 0, NULL, 1, '2025-08-25 16:55:20', '2025-08-25 16:55:20'),
(7, 7, '红警合集', 0, NULL, 1, '2025-11-17 10:45:27', '2026-03-09 12:51:44'),
(8, 9, '预设', 2, '', 1, '2026-02-01 21:04:41', '2026-03-05 16:57:01'),
(9, 10, '文件处理', 0, NULL, 1, '2026-02-03 00:18:13', '2026-02-03 00:18:13'),
(10, 10, 'AI工具', 0, '', 1, '2026-03-09 18:16:53', '2026-03-09 18:16:53');

-- --------------------------------------------------------

--
-- 表的结构 `material_user_collection_list`
--

CREATE TABLE `material_user_collection_list` (
  `id` int(255) NOT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `material_id` int(11) DEFAULT NULL COMMENT '资料ID',
  `category_id` int(11) DEFAULT NULL COMMENT '分类ID',
  `sub_category_id` int(11) DEFAULT NULL COMMENT '二级分类ID',
  `title` varchar(255) DEFAULT NULL,
  `cover_image` varchar(255) DEFAULT NULL,
  `category_time` datetime DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `material_user_collection_list`
--

INSERT INTO `material_user_collection_list` (`id`, `user_id`, `material_id`, `category_id`, `sub_category_id`, `title`, `cover_image`, `category_time`, `tags`, `status`) VALUES
(1, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 106, 10, 10, 'Clawbot部署教程电子版', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1773051458097_5f44f4507c0774ad.png', '2026-03-09 18:20:33', NULL, 1),
(2, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 77, 10, 9, '批量修改名图片文件时间重命名编号替换更名文本档属性删除软件', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770049301302_2d2c82d89b89fd02.png?imageMogr2/format/webp', '2026-03-09 18:28:12', NULL, 1),
(3, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 93, 9, 8, 'PS颜色查找预设暗墨茶橙旅拍航拍风景人像街拍手机LR调色滤镜LUT', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052014990_9c9c310bb2b70286.jpg?imageMogr2/format/webp', '2026-03-09 18:28:18', NULL, 1),
(4, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 94, 9, 8, 'Lr预设日系情绪胶片PS婚礼人像滤镜Fcpx达芬奇Pr Lut视频手机调色', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770052098504_2719d4fe504b9748.jpg?imageMogr2/format/webp', '2026-03-09 18:28:22', NULL, 1),
(5, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 103, 3, 2, '在线教育APP小程序线上课程讲师培训UI界面sketch/xd设计素材模板', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770572103251_7471a6c82b5bb153.jpg?imageMogr2/format/webp', '2026-03-09 18:28:34', NULL, 1),
(7, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 95, 3, 2, '健康饮食APP小程序UI界面作业figma/psd/xd设计素材模板源文件', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/material-img/1770569281628_2706fc7a65dac494.jpg?imageMogr2/format/webp', '2026-03-09 18:28:42', NULL, 1);

-- --------------------------------------------------------

--
-- 表的结构 `miniprogram_info`
--

CREATE TABLE `miniprogram_info` (
  `id` bigint(20) NOT NULL COMMENT '主键ID',
  `name` varchar(100) DEFAULT NULL COMMENT '小程序名称',
  `appid` varchar(50) NOT NULL COMMENT '小程序AppID',
  `app_secret` varchar(100) NOT NULL COMMENT '小程序AppSecret',
  `ad_template_list` json DEFAULT NULL COMMENT '广告ID列表',
  `description` varchar(500) DEFAULT NULL COMMENT '小程序描述',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-禁用 1-启用',
  `is_download` tinyint(1) DEFAULT '1' COMMENT '是否开启下载时激励广告',
  `is_ad` tinyint(1) DEFAULT '1' COMMENT '是否开启广告',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='小程序信息表';

--
-- 转存表中的数据 `miniprogram_info`
--

INSERT INTO `miniprogram_info` (`id`, `name`, `appid`, `app_secret`, `ad_template_list`, `description`, `status`, `is_download`, `is_ad`, `create_time`, `update_time`) VALUES
(1, '光年视觉', 'wxd1a72e6d2c6c4afe', '', '{\"ad1\": \"adunit-20824b2ebe61e45d\", \"ad2\": \"adunit-eab2d7ee723a734c\", \"ad3\": \"adunit-d345258e4e808ce1\", \"ad4\": \"adunit-4f42c404618e6d43\", \"ad5\": \"adunit-f5be82444d63e022\", \"ad6\": \"adunit-e29b3473c4f3a324\", \"ad7\": \"adunit-abc87bab70b2ff81\", \"ad8\": \"adunit-65cfe697de9d45ad\"}', NULL, 1, 1, 1, '2025-05-25 19:26:00', '2026-03-10 20:04:21'),
(3, '123小橘去水印新', 'wxe84f994fe3d56f0b', '', '{\"ad1\": \"1111000\", \"ad2\": \"2\", \"ad3\": \"3\", \"ad4\": \"4\", \"ad5\": \"5\", \"ad6\": \"6\", \"ad7\": \"7111\", \"ad8\": \"8\"}', '1', 0, 1, 0, '2025-06-19 22:03:55', '2026-03-10 19:49:18');

-- --------------------------------------------------------

--
-- 表的结构 `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL COMMENT '编号',
  `name` varchar(225) NOT NULL DEFAULT '' COMMENT '名称',
  `roles` varchar(10000) NOT NULL DEFAULT '' COMMENT '权限标识',
  `checked_roles` varchar(255) NOT NULL DEFAULT '' COMMENT '权限默认选中标识',
  `role_key` varchar(10000) DEFAULT '' COMMENT '权限字符',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `roles`
--

INSERT INTO `roles` (`id`, `name`, `roles`, `checked_roles`, `role_key`, `update_time`, `create_time`) VALUES
(1, 'admin', '8,9,10,2,5,11,17,1', '8,9,10,5,11,17', 'admin', NULL, '2023-04-06 07:39:40'),
(12, '中级管家2', '49,30,43,31,122,121,123,128,125,124,1,10,8,26,27,69,76,32,113,44,65,68', '49,43,31,32,68', 'middle', '2023-06-16 07:45:04', '2023-04-06 07:39:40'),
(13, '初级管家1', '30,43,31,122,121,123,125,124,1,10,8,26,27,69,76,32,113,44,65,66', '49,43,31,10,8,26,27,76,32,113,110,109,108,107,105,104,103,102,100,99,98,97,96,92,91,90,89,66,68', 'primary', '2023-06-16 07:45:11', '2023-04-06 07:39:40');

-- --------------------------------------------------------

--
-- 表的结构 `router_menu`
--

CREATE TABLE `router_menu` (
  `id` int(11) NOT NULL COMMENT '编号',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级id',
  `title` varchar(255) DEFAULT '' COMMENT '标题',
  `icon` varchar(255) DEFAULT '' COMMENT '图标',
  `no_cache` int(11) DEFAULT '1' COMMENT '是否缓存',
  `meta` varchar(255) NOT NULL DEFAULT '' COMMENT '其他对象',
  `path` varchar(255) NOT NULL DEFAULT '/' COMMENT '路由地址',
  `hidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT ' 当设置 true 的时候该路由不会在侧边栏出现 如401，login等页面',
  `redirect` varchar(255) NOT NULL DEFAULT '' COMMENT '当设置 noRedirect 的时候该路由在面包屑导航中不可被点击',
  `always_show` tinyint(1) NOT NULL DEFAULT '0' COMMENT '你可以设置 alwaysShow: true，这样它就会忽略之前定义的规则，一直显示根路由',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '设定路由的名字，一定要填写不然使用<keep-alive>时会出现各种问题',
  `layout` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否需要含导航栏，只需一级才设置这个（默认为false）',
  `parent_view` tinyint(1) NOT NULL DEFAULT '0' COMMENT '如果第二级里面还需要套级，需在当前级设置为true',
  `component` varchar(255) NOT NULL DEFAULT '/' COMMENT '对应的页面路径',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `alone` int(11) NOT NULL DEFAULT '0' COMMENT '是否独立的（一级）',
  `role_key` varchar(255) DEFAULT '' COMMENT '权限字符',
  `menu_type` varchar(255) NOT NULL DEFAULT 'C' COMMENT '菜单类型区分',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `router_menu`
--

INSERT INTO `router_menu` (`id`, `parent_id`, `title`, `icon`, `no_cache`, `meta`, `path`, `hidden`, `redirect`, `always_show`, `name`, `layout`, `parent_view`, `component`, `sort`, `alone`, `role_key`, `menu_type`, `update_time`, `create_time`) VALUES
(1, 0, '系统设置', 'international', 1, '{}', '/menus', 0, '', 0, '', 1, 0, '/', 11, 0, '', 'M', '2023-06-15 06:48:47', '2023-05-26 03:11:07'),
(26, 1, '用户管理', 'user', 1, '{}', '/user', 0, '', 0, 'user', 0, 0, 'admin/user', 2, 0, '', 'C', '2023-04-10 01:40:38', '2023-05-26 03:11:07'),
(27, 1, '多账号管理', 'peoples', 1, '{}', '/more', 0, '', 0, 'more', 0, 0, 'admin/more', 3, 0, '', 'C', '2023-04-10 01:40:51', '2023-05-26 03:11:07'),
(49, 0, '图标', 'icon', 1, '{}', '/icon', 0, '', 0, 'Icon', 1, 0, 'icons/index', 2, 0, NULL, 'C', '2025-04-19 11:03:53', '2023-05-26 03:11:07'),
(8, 1, '角色管理', 'role', 1, '{}', '/role', 0, '', 0, 'Role', 0, 0, 'admin/role', 1, 0, '', 'C', '2023-05-25 03:20:21', '2023-05-26 03:11:07'),
(30, 0, '测试数据', 'bug', 1, '{}', '/test', 0, '', 0, '', 1, 0, '/', 2, 0, '', 'M', '2025-04-20 10:29:48', '2023-05-26 03:11:07'),
(10, 1, '菜单管理', 'list', 1, '{}', '/menu', 0, '', 0, 'Menu', 0, 0, 'admin/menu', 0, 0, '', 'C', '2023-05-26 03:14:37', '2023-05-26 03:11:07'),
(31, 30, '多账号测试', 'bug', 1, '{}', '/index', 0, '', 0, 'testMore', 0, 0, 'test/index', 1, 0, '', 'C', '2023-03-30 08:17:06', '2023-05-26 03:11:07'),
(32, 0, 'Gitee直达', 'link', 1, '{}', 'https://gitee.com/MMinter/vue_node', 0, '', 0, 'link', 1, 0, '/', 14, 0, '', 'C', '2023-04-11 03:23:33', '2023-05-26 03:11:07'),
(65, 44, '测试数据', 'eye', 1, '{}', '', 1, '', 0, '', 0, 0, '/', 0, 0, NULL, 'F', '2023-03-27 07:18:34', '2023-05-26 03:11:07'),
(44, 0, '菜单权限字符', 'eye', 1, '{}', '', 1, '', 0, '', 1, 0, '/', 100, 0, NULL, 'F', '2023-04-11 03:24:29', '2023-05-26 03:11:07'),
(66, 65, '权限测试1', 'form', 1, '{}', '', 1, '', 0, '', 0, 0, '/', 0, 0, 'roleKey2', 'F', '2023-06-07 08:44:24', '2023-05-26 03:11:07'),
(43, 30, '权限隐藏API测试', 'eye', 1, '{}', '/RoleApi', 0, '', 0, 'RoleApi', 0, 0, 'test/roleApi', 0, 0, '', 'C', '2023-03-15 07:52:16', '2023-05-26 03:11:07'),
(68, 65, '权限测试2', 'example', 1, '{}', '', 1, '', 0, '', 0, 0, '/', 1, 0, 'roleKey2', 'F', '2023-03-27 07:23:59', '2023-05-26 03:11:07'),
(69, 1, '字典管理', 'dashboard', 1, '{}', '/dict', 0, '', 0, 'Dict', 0, 0, 'admin/dict', 4, 0, NULL, 'C', '2023-03-30 08:58:47', '2023-05-26 03:11:07'),
(97, 95, '用户新增', 'user', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'user_add', 'F', '2023-04-03 08:47:22', '2023-05-26 03:11:07'),
(85, 44, '系统设置', 'lock', 1, '{}', '/', 1, '', 0, '', 0, 0, '/', 0, 0, '', 'F', '2023-04-03 07:21:17', '2023-05-26 03:11:07'),
(88, 85, '菜单管理', 'documentation', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, NULL, 'F', '2023-04-03 07:21:49', '2023-05-26 03:11:07'),
(89, 88, '菜单查询', 'example', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'menu_query', 'F', '2023-04-03 07:22:46', '2023-05-26 03:11:07'),
(90, 88, '菜单新增', 'example', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'menu_add', 'F', '2023-04-03 07:35:28', '2023-05-26 03:11:07'),
(91, 88, '菜单修改', 'example', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'menu_up', 'F', '2023-04-03 07:36:06', '2023-05-26 03:11:07'),
(92, 88, '菜单删除', 'example', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'menu_delete', 'F', '2023-04-03 07:36:19', '2023-05-26 03:11:07'),
(76, 69, '字典项目', 'form', 1, '{}', '/dictItem', 0, '', 0, 'DictItem', 0, 0, 'admin/dictItem', 0, 0, '', 'C', '2023-03-30 07:55:52', '2023-05-26 03:11:07'),
(95, 85, '用户管理', 'user', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, NULL, 'F', '2023-04-03 08:46:18', '2023-05-26 03:11:07'),
(96, 95, '用户查询', 'user', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'user_query', 'F', '2023-04-03 08:46:56', '2023-05-26 03:11:07'),
(98, 95, '用户修改', 'user', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'user_up', 'F', '2023-04-03 08:52:31', '2023-05-26 03:11:07'),
(99, 95, '用户删除', 'user', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'user_delete', 'F', '2023-04-03 08:52:47', '2023-05-26 03:11:07'),
(100, 95, '用户修改密码', 'eye', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'user_pwd', 'F', '2023-04-03 08:56:33', '2023-05-26 03:11:07'),
(101, 85, '角色管理', 'peoples', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, NULL, 'F', '2023-04-03 08:59:20', '2023-05-26 03:11:07'),
(102, 101, '角色查询', 'peoples', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'role_query', 'F', '2023-04-03 08:59:33', '2023-05-26 03:11:07'),
(103, 101, '角色新增', 'peoples', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'role_add', 'F', '2023-04-03 08:59:46', '2023-05-26 03:11:07'),
(104, 101, '角色修改', 'peoples', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'role_up', 'F', '2023-04-03 09:00:04', '2023-05-26 03:11:07'),
(105, 101, '角色删除', 'peoples', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'role_delete', 'F', '2023-04-03 09:00:24', '2023-05-26 03:11:07'),
(106, 85, '多账户管理', 'nested', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, NULL, 'F', '2023-04-03 09:12:25', '2023-05-26 03:11:07'),
(107, 106, '多账户查询', 'people', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'more_query', 'F', '2023-04-03 09:31:07', '2023-05-26 03:11:07'),
(108, 106, '多账户新增', 'people', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'more_add', 'F', '2023-04-03 09:31:30', '2023-05-26 03:11:07'),
(109, 106, '多账户修改', 'people', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'more_up', 'F', '2023-04-03 09:31:47', '2023-05-26 03:11:07'),
(110, 106, '多账户删除', 'people', 1, '{}', '/', 0, '', 0, '', 0, 0, '/', 0, 0, 'more_delete', 'F', '2023-04-03 09:32:07', '2023-05-26 03:11:07'),
(113, 0, 'GitHub直达', 'link', 1, '{}', 'https://github.com/MingMinter/vue_node_admin', 0, '', 0, 'GitHub', 1, 0, '/', 16, 0, NULL, 'C', '2023-06-15 06:50:55', '2023-05-26 03:11:07'),
(121, 122, '上传图片', 'education', 1, '{}', '/img', 0, '', 0, 'Img', 0, 0, 'components/img', 0, 0, NULL, 'C', '2023-05-29 06:35:29', '2023-05-26 08:18:37'),
(122, 0, '文件管理', 'zip', 1, '{}', '/file', 0, '', 0, '', 1, 0, '/', 3, 0, NULL, 'M', '2025-04-20 10:29:54', '2023-05-29 06:35:16'),
(123, 122, '上传文件', 'zip', 1, '{}', '/file', 0, '', 0, 'File', 0, 0, 'components/file', 0, 0, NULL, 'C', NULL, '2023-05-30 07:13:26'),
(124, 0, '我的信息', 'user', 1, '{}', '/info', 0, '', 0, 'Info', 1, 0, 'admin/info', 10, 0, 'www1', 'C', '2023-06-15 06:37:57', '2023-05-31 07:09:24'),
(125, 0, '富文本编辑', 'form', 1, '{}', '/ditor', 0, '', 0, 'Ditor', 1, 0, 'components/ditor', 1, 0, NULL, 'C', '2023-06-15 06:38:54', '2023-06-02 02:00:59'),
(128, 0, '大屏展示', 'chart', 1, '{}', '/echart', 0, '', 0, 'Echart', 1, 0, 'components/echart', 4, 0, NULL, 'C', '2025-04-20 10:29:58', '2023-06-13 02:24:44'),
(130, 0, '图片管理', 'documentation', 1, '{}', '/img', 0, '', 0, '', 1, 0, '/', 1, 0, NULL, 'M', '2025-04-19 11:03:36', '2024-10-24 09:09:30'),
(131, 130, '分类管理', 'tab', 1, '{}', '/type', 0, '', 0, 'type', 0, 0, 'imgMgmt/type/index', 1, 0, NULL, 'C', '2025-04-20 10:30:41', '2024-10-24 09:13:15'),
(133, 130, '图片列表', 'education', 1, '{}', '/image-groups', 0, '', 0, 'image-groups', 0, 0, 'imgMgmt/imageGroups/index', 0, 0, NULL, 'C', '2025-04-20 10:31:26', '2025-02-09 16:34:22'),
(134, 130, '标签', 'documentation', 1, '{}', '/tags', 0, '', 0, 'tags', 0, 0, 'imgMgmt/tags/index', 2, 0, NULL, 'C', '2025-05-06 14:48:10', '2025-04-19 09:36:20');

-- --------------------------------------------------------

--
-- 表的结构 `theme`
--

CREATE TABLE `theme` (
  `1` varchar(255) DEFAULT NULL,
  `11` varchar(255) DEFAULT NULL,
  `#304156` varchar(255) DEFAULT NULL,
  `#3041561` varchar(255) DEFAULT NULL,
  `#bfcad5` varchar(255) DEFAULT NULL,
  `#409eff` varchar(255) DEFAULT NULL,
  `#fff` varchar(255) DEFAULT NULL,
  `#001528` varchar(255) DEFAULT NULL,
  `2023/6/21 15:07:08` varchar(255) DEFAULT NULL,
  `2023/5/26 11:30:29` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `theme`
--

INSERT INTO `theme` (`1`, `11`, `#304156`, `#3041561`, `#bfcad5`, `#409eff`, `#fff`, `#001528`, `2023/6/21 15:07:08`, `2023/5/26 11:30:29`) VALUES
('25', '53', '#304156', '#304156', '#bfcad5', '#409eff', '#fff', '#001528', '', '2023/6/16 15:18:24'),
('26', '54', '#304156', '#304156', '#bfcad5', '#409eff', '#fff', '#001528', '', '2023/6/16 15:18:55');

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL COMMENT '编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `url` varchar(1000) DEFAULT NULL COMMENT '头像',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态',
  `roles_id` varchar(255) NOT NULL DEFAULT '' COMMENT '角色编号',
  `remark` varchar(255) DEFAULT '' COMMENT '备注',
  `admin` int(11) NOT NULL DEFAULT '0' COMMENT '管理员',
  `pwd` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `more_id` int(11) NOT NULL DEFAULT '0' COMMENT '账号编号',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `name`, `url`, `status`, `roles_id`, `remark`, `admin`, `pwd`, `more_id`, `update_time`, `create_time`) VALUES
(1, 'admin', 'http://127.0.0.1:3000/168733128710103334278761577498-bg.2fa5cb09.jpg', 1, '1', '管理员', 1, '8fe076af82114ecfe8479440ff4d1af4', 5, '2025-05-14 17:07:51', '2023-04-05 07:32:33');

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_app_img_list`
--

CREATE TABLE `wallpaper_app_img_list` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL COMMENT '所属分类',
  `category_name` varchar(100) DEFAULT NULL COMMENT '所属分类名称',
  `create_time` datetime DEFAULT NULL COMMENT '上传时间',
  `url` text COMMENT '图片路径',
  `file_path` text COMMENT '保存的文件夹名称',
  `status` tinyint(4) DEFAULT NULL COMMENT '显示：1，隐藏：0',
  `group_name` varchar(100) DEFAULT NULL COMMENT '所属分组名称',
  `group_id` int(11) NOT NULL COMMENT '所属分组ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wallpaper_app_img_list`
--

INSERT INTO `wallpaper_app_img_list` (`id`, `category_id`, `category_name`, `create_time`, `url`, `file_path`, `status`, `group_name`, `group_id`) VALUES
(3, 2, '电脑', '2024-10-25 18:44:27', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/diannao/172985306761608107733485497897-1729853067616', 'diannao', NULL, NULL, 0),
(5, 1, '手机2', '2024-10-26 11:31:53', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/shoujibizhi/172991351371306564340387243386-1729913513713.jpg', 'shoujibizhi', NULL, NULL, 0),
(7, 1, '手机2', '2024-10-26 11:31:54', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/shoujibizhi/17299135137390267833132537868-1729913513739.png', 'shoujibizhi', NULL, NULL, 0),
(9, 1, '手机2', '2024-10-26 11:31:53', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/shoujibizhi/172991351371306564340387243386-1729913513713.jpg', 'shoujibizhi', NULL, NULL, 0),
(10, 1, '手机2', '2024-10-26 11:31:53', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/shoujibizhi/17299135137190765991746546109-1729913513719.png', 'shoujibizhi', NULL, NULL, 0),
(11, 1, '手机2', '2024-10-26 11:31:54', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/shoujibizhi/17299135137390267833132537868-1729913513739.png', 'shoujibizhi', NULL, NULL, 0),
(12, 10, '风景', '2024-10-26 11:34:52', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/172991369276108976810744280306-1729913692761.jpg', 'fengjing', NULL, NULL, 0),
(13, 10, '风景', '2024-10-26 11:34:52', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/1729913692739011972102161005238-1729913692739.png', 'fengjing', NULL, NULL, 0),
(14, 10, '风景', '2024-10-26 11:34:52', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/172991369278304986332382324019-1729913692783.jpg', 'fengjing', NULL, NULL, 0),
(15, 10, '风景', '2024-10-26 11:34:53', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/172991369276003715256293589564-1729913692760.png', 'fengjing', NULL, NULL, 0),
(16, 10, '风景', '2024-10-26 11:34:52', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/172991369276108976810744280306-1729913692761.jpg', 'fengjing', NULL, NULL, 0),
(17, 10, '风景', '2024-10-26 11:34:52', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/1729913692739011972102161005238-1729913692739.png', 'fengjing', NULL, NULL, 0),
(18, 10, '风景', '2024-10-26 11:34:52', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/172991369278304986332382324019-1729913692783.jpg', 'fengjing', NULL, NULL, 0),
(19, 10, '风景', '2024-10-26 11:34:53', 'http://iweb-web.oss-cn-shanghai.aliyuncs.com/fengjing/172991369276003715256293589564-1729913692760.png', 'fengjing', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_image_categories`
--

CREATE TABLE `wallpaper_image_categories` (
  `id` int(11) NOT NULL,
  `name` text COMMENT '分类名称',
  `status` tinyint(1) DEFAULT NULL COMMENT '启用状态',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `img_total` int(11) DEFAULT NULL COMMENT '图片总数量',
  `file` text COMMENT 'OSS文件夹路径'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wallpaper_image_categories`
--

INSERT INTO `wallpaper_image_categories` (`id`, `name`, `status`, `update_time`, `create_time`, `img_total`, `file`) VALUES
(11, '美女', 0, '2026-03-08 23:36:57', '2025-02-24 17:02:47', NULL, 'dajuzi/gufeng/'),
(15, '卡通', 1, '2025-04-26 00:25:01', '2025-04-06 19:57:34', NULL, 'dajuzi/xiantiaodog/'),
(21, '风光', 1, NULL, '2025-04-26 00:40:35', NULL, 'dajuzi/xiantiaodog/'),
(22, '穿搭', 0, '2026-03-08 23:37:39', '2025-06-01 07:34:20', NULL, 'dajuzi/chuanda/');

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_image_groups`
--

CREATE TABLE `wallpaper_image_groups` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL COMMENT '外键，关联分类表',
  `category_name` varchar(100) NOT NULL COMMENT '分类名称',
  `title` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '图片组标题',
  `file` varchar(255) NOT NULL COMMENT '文件路径',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '首图URL',
  `images_url` json NOT NULL COMMENT '图片url列表',
  `create_time` varchar(255) DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `featured` tinyint(1) NOT NULL COMMENT '是否推荐'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wallpaper_image_groups`
--

INSERT INTO `wallpaper_image_groups` (`id`, `category_id`, `category_name`, `title`, `file`, `cover_image`, `images_url`, `create_time`, `update_time`, `status`, `featured`) VALUES
(29, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551695976.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389816316_5cee74d63b60fcee.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389816555_b7f48880684bd8f0.png\"]', '2025-02-24 17:37:11', '2025-03-02 23:51:45', 1, 0),
(30, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551717569.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389864059_3eaa66670d0070ff.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389864229_c2b0999094a5296c.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389864192_4d06b14dbfde0215.png\"]', '2025-02-24 17:37:57', NULL, 1, 1),
(31, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551732881.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740705872235_22ed5de4f429db6a.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740705872227_941a5d3ec8e7e6d9.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740706603613_fcdebdc81a5f5a2c.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740706603769_0194ee83a7a92023.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740706603844_086aebbde7d65a42.png\"]', '2025-02-28 09:24:46', '2025-02-28 09:37:08', 1, 0),
(32, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551782607.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740705902390_639c38482789e363.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740705902419_77a065caef32c138.png\"]', '2025-02-28 09:25:18', '2025-03-01 11:42:48', 1, 0),
(33, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551788495.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715005176_9317314419e37af6.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715005210_33f785c1f1b46f08.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715005303_ab8dd0eae0a54714.png\"]', '2025-02-28 11:57:05', NULL, 1, 1),
(34, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551792892.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715043136_d43766f390a128b2.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715044066_d989a3e22e087675.png\"]', '2025-02-28 11:57:47', '2025-03-02 23:50:37', 1, 0),
(36, 11, '古风', '', 'dajuzi/gufeng/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744546053112.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740935126260_2e4421b2ff1ac5b0.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740935704103_4bcd6c140bb6b582.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740935705157_aab1d146c5ec969e.png\"]', '2025-03-03 01:05:36', '2025-03-03 01:15:22', 1, 1),
(37, 13, '田园', '', 'dajuzi/tianyuan/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744546061433.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054796742_c5f8a4ef03d8e842.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054797230_caec31da949cf3c2.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054797233_7798825534f23405.png\"]', '2025-03-04 10:20:17', NULL, 1, 0),
(38, 13, '田园', '', 'dajuzi/tianyuan/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744544981885.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054840632_aa6bcad9a56d5c80.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054840777_f47d80485d997d5c.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054840835_a78432fc328c36cf.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/tianyuan/1741054841305_1cb7f08475fb3f8e.png\"]', '2025-03-04 10:21:06', NULL, 1, 0),
(39, 10, '生活', '', 'dajuzi/shenghuo/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/app-img/1741054895792_5ea50ef629b08f3e.png?imageMogr2/thumbnail/!50p?imageMogr2/thumbnail/!50p?imageMogr2/thumbnail/!50p?imageMogr2/thumbnail/!50p?imageMogr2/thumbnail/!50p', '[\"http://iweb-web.oss-cn-shanghai.aliyuncs.com/dajuzi/shenghuo/1744736140758_c1d109da9dac7ef5.png\"]', '2025-03-04 10:22:27', '2025-04-16 00:56:48', 0, 0),
(40, 14, '光影', '', 'dajuzi/guangying/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744546103854.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/guangying/1741515346193_e8d166a2b0a98f01.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/guangying/1741515346243_2708cf8eca56c8e8.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/guangying/1741515346218_1b74f62c0d35cf88.png\"]', '2025-03-09 18:29:07', NULL, 1, 1),
(41, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551807838.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940683937_5bb1f4b4bb440296.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940684032_7c7857c3940965cf.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940684052_d58340282f1f6e7d.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940683953_0b2964bd33c0b368.jpg\"]', '2025-04-06 19:58:38', NULL, 1, 0),
(42, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551819891.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424292_a471ca5e0b8010b4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424553_917cad1c879e1070.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424592_c3f4e14ef4139e8d.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424425_2d3e4e45960a5cd1.jpg\"]', '2025-04-06 20:11:03', NULL, 1, 0),
(44, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551827292.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942113980_b574a4f0a551748d.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942115190_a70f6e52f80e6aea.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942116665_20636c57c7652016.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942116695_3f3eafd3e1a1dbf0.jpg\"]', '2025-04-06 20:22:28', NULL, 1, 0),
(45, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551844973.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205045_20fd625b2f682b40.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205139_8f01879fc9fae634.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205044_95980d96a494d9fe.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205137_d7343b0606b0868f.jpg\"]', '2025-04-06 20:24:13', NULL, 1, 0),
(47, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551840217.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942551426_82733d22b11e27ef.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942550824_bc89985a0035de48.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942550829_de0f80f481cc0028.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942551313_f46693c0f3b58407.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942551143_dc730dcf01ac00bb.jpg\"]', '2025-04-06 20:31:04', NULL, 1, 0),
(48, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551864912.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942680978_cc0d20cf12746626.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942681006_63577d9b385c22f6.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942680981_f8972bd6a9079d47.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942681004_cb6db75461f86149.jpg\"]', '2025-04-06 20:31:55', NULL, 1, 0),
(49, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551860100.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732673_c6101b89d2363755.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732696_1a95e7d30d9c90d1.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732518_4ff2292fe3a23e09.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732698_841b8daa4c21be11.jpg\"]', '2025-04-06 20:33:07', NULL, 1, 0),
(50, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551855298.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942802632_e9f231f856ecbee4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942803122_6f3d8e282ebe64d9.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942802748_6cd56b8812f57206.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942802951_7fe75f42fdb1c4b1.jpg\"]', '2025-04-06 20:34:06', NULL, 1, 0),
(51, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551850247.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859330_cc9133a4d449b09f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859275_20b6bd2a9152e4ce.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859352_6e709ee3905724eb.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859417_3851a05d870efefc.jpg\"]', '2025-04-06 20:35:22', NULL, 1, 0),
(52, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551872292.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937383_b93d5b3182431778.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937315_eb549132322db695.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937381_f7cea9457a8cae0f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937492_755f2d739e508481.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937497_aa0b38a196da77c5.jpg\"]', '2025-04-06 20:36:28', NULL, 1, 0),
(53, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551876892.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011134_ba35ad270ce081ff.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011234_292c8da32b76da33.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011066_6b50499e660ad7a7.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011226_95723a8a10811a56.jpg\"]', '2025-04-06 20:37:28', NULL, 1, 0),
(54, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551881755.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060697_7eeb7e748f809f73.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060487_dd4ecfe123c3cbca.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060675_47b68156dc524469.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060695_b2c6c7bf34f1a7f5.jpg\"]', '2025-04-06 20:38:28', NULL, 1, 0),
(55, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551886067.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117259_048393a970bf4d3a.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117338_927ba3f1f68bdab8.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117569_d99bb7669dc27827.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117744_0b8feed415d88aea.jpg\"]', '2025-04-06 20:39:21', NULL, 1, 0),
(56, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551891319.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173390_820d2e6f1b979d86.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173442_cbc6b1449f61bbca.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173625_c9aa16a988385dd4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173808_bbeef7761244440d.jpg\"]', '2025-04-06 20:40:12', NULL, 1, 0),
(57, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551898559.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943223976_b71f60130e3f5893.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943224938_d6b24af24f2a5600.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943224077_04eded743c2d1b2e.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943224675_4726c3e07b2c6022.jpg\"]', '2025-04-06 20:41:03', NULL, 1, 0),
(58, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551904105.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943273924_881d32931032bc5f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943274140_e49aaad37832fd6d.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943274135_d9715ee725e29ed8.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943273926_c94520cfb476930c.jpg\"]', '2025-04-06 20:41:45', NULL, 1, 0),
(59, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551908853.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316135_129f08314e03e980.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316145_4d49692248bce9f2.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316920_899ff3e8dd6d8493.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316384_7d453911f84296cf.jpg\"]', '2025-04-06 20:42:30', NULL, 1, 0),
(60, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551913327.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762623_e55b39fd18185dd2.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762778_8f3d99a3851556e5.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762654_f786bec299bf39cf.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762730_895bb09dfc793ac2.jpg\"]', '2025-04-06 20:51:12', NULL, 1, 0),
(61, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551958976.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882175_73143530d4929447.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882134_802f22ddf74170f6.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882226_ed89dfbb4ae4daef.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882257_f4a6b6dbe3874580.jpg\"]', '2025-04-06 20:51:58', NULL, 1, 0),
(62, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551971985.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930156_621071e62fc14b5a.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930097_ea9b6c3900ee7929.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930012_a767c318434ca8c0.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930098_d61a76ab4aaa323b.jpg\"]', '2025-04-06 20:52:52', NULL, 1, 0),
(63, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551984374.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985216_7701455d9feecd6e.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985523_f6c260b62d1bb104.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985520_699ba0e20077aa3c.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985414_d0319b1ea617b99d.jpg\"]', '2025-04-06 20:53:49', NULL, 1, 0),
(64, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744551997165.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944036353_a8460a5185b1f454.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944037270_846f54774c6a1344.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944037036_2e01c4de35dd984f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944037004_d50ea9d09e7586d0.jpg\"]', '2025-04-06 20:57:24', NULL, 1, 0),
(65, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552005757.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944257991_aa950a0bdd0b6914.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944258024_28bd8edc7cbc92f6.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944258180_f38be3cc2e29f8a8.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944258173_3f7d4c97107e54e2.jpg\"]', '2025-04-06 20:59:22', NULL, 1, 0),
(66, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552010510.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372437_c518d71ab571874e.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372560_a99e6c690888c067.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372901_e8c86671b30af982.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372896_c98e6ca13f1bee28.jpg\"]', '2025-04-06 21:00:07', NULL, 1, 0),
(67, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552015725.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944420027_f1c5cb479be47e13.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944419978_d8d052e19e58528f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944420262_0e10ae1aa9efdf71.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944420261_2c6b9c23af28687f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944515979_a1d818f81d2274fe.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944520687_ca771ce443ecaae2.jpg\"]', '2025-04-06 21:02:38', NULL, 1, 0),
(68, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552020810.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944567987_e3c30e6a94701cc4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944568801_b5ff7362b91f219e.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944567948_6377407a8462e02a.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944568811_652840e83382b3df.jpg\"]', '2025-04-06 21:03:27', NULL, 1, 0),
(69, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552025643.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638381_e466f49668bb7499.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638450_92460f9bafef413c.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638248_8cb5c20eb9c836aa.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638465_2fd12beefb185590.jpg\"]', '2025-04-06 21:04:55', NULL, 1, 0),
(70, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552031014.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944707748_82f7a13f9f7fc8a6.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944707749_4778dcb808e9649c.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944727537_c1d3266ce044f8ad.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944727446_d7fd3a6113f85cd9.jpg\"]', '2025-04-06 21:05:55', NULL, 1, 0),
(71, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552035758.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944765523_364527b33621b901.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944766012_1e4bd2f4f37d093f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944766121_545abfb37e980877.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944765598_218bd50fd06645ab.jpg\"]', '2025-04-06 21:07:12', NULL, 1, 0),
(72, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552043203.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944848683_146154d28c33e6c3.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944848673_8f7ba8d5c05b1a50.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944849155_2f59e3400946410f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944848925_e5a32f5b5706cb3f.jpg\"]', '2025-04-06 21:08:25', NULL, 1, 0),
(73, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552048014.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923705_7d28c19fd6c7faf0.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923721_05e9a4f621151fb0.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923723_9227679d6e38b3e2.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923720_0eddaeac55f96b43.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944961984_2599748e35b8019d.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944961974_f466bd5bf6cbdb67.jpg\"]', '2025-04-06 21:09:56', NULL, 1, 0),
(74, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552109339.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945004842_65ed6cbd3f963747.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945004915_ae81a5c543003ac1.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945005002_476f65089c1e4d15.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945005021_9add3f4ee19494d2.jpg\"]', '2025-04-06 21:11:08', NULL, 1, 0),
(75, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552116340.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945083534_7cfc56682124d0b5.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945083634_998caafed0d2fcb8.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945083632_efe1a8578b0aa03b.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945105934_5c474d8470fd01b6.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945105935_627fc0ed434351b5.jpg\"]', '2025-04-06 21:12:28', NULL, 1, 0),
(76, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552121371.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161386_b7ba13ee8b3b2297.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161771_104dfa29559670e3.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161248_3bb25ba249f1a3df.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161769_7c7babcecd0853cd.jpg\"]', '2025-04-06 21:13:49', NULL, 1, 0),
(77, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552125996.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945247052_6e56d0829e21a29f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945247054_dac6c4974cabb29b.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945247063_3320b4f758ffe83f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945301760_a5f581eab7fd7770.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945301846_2240695f16725173.jpg\"]', '2025-04-06 21:15:21', NULL, 1, 0),
(78, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552131607.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346449_9f086062f28828f4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346335_75dc54288a086fdc.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346560_3fd1e6719f6bc986.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346577_881400554e0ceabd.jpg\"]', '2025-04-06 21:16:25', NULL, 1, 0),
(79, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552136408.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395423_af6332bb8ace5605.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395425_1eb62fa7da6e8305.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395579_5d3259fb7db879a1.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395577_4b46c195897d49fb.jpg\"]', '2025-04-06 21:17:01', NULL, 1, 0),
(80, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552141520.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945431600_cc83a26de26accaa.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945431662_c62aaf6f2ed6ce52.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945431771_68d29cc872390570.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945432065_8e89cebf65c87e82.jpg\"]', '2025-04-06 21:18:00', NULL, 1, 0),
(81, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552146454.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945489735_42a78c764a5327c9.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945490228_87c48ffdfb619f96.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945489782_5795f7ea66eb5a11.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945490228_2b16213a6bc62a14.jpg\"]', '2025-04-06 21:19:01', NULL, 1, 0),
(82, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552153502.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945550803_a478398f4e961bff.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945551017_7ba412d1940e65c7.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945550987_ea771da1d65cc750.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945551093_22dafb8b61ed429a.jpg\"]', '2025-04-06 21:19:59', NULL, 1, 0),
(83, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552157995.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609745_41e30e7feb5d4a81.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609746_8a5a326eccbe2aa4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609824_2774ea5219b1eded.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609835_afe26bc9e2bcc1b2.jpg\"]', '2025-04-06 21:20:48', NULL, 1, 0),
(84, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552163265.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945657623_fbb87274b177e06b.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945657809_7dd9826617a37f01.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945657701_bb037fac7442aff8.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945658012_e91c18ce046ae91e.jpg\"]', '2025-04-06 21:21:29', NULL, 1, 0),
(85, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552168609.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945699282_f51deca979035f8a.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945699279_bc3830f7d2778d1f.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945699279_5faf1309700bdd36.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945731522_682ea842e4e75344.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945731524_5995e6fbf9ea3fda.jpg\"]', '2025-04-06 21:22:41', NULL, 1, 0),
(86, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552173769.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772150_8a29eeb52bbb568a.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772319_3d146cea4b265c17.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772865_990db87a246d4478.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772874_51b629e682745817.jpg\"]', '2025-04-06 21:24:13', NULL, 1, 0),
(87, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552178475.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862640_bb96c1a929ebe6c2.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862574_4c288d83f9f5150c.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862646_550ecf7f25ff66f9.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862643_15064d6027452aec.jpg\"]', '2025-04-06 21:25:44', NULL, 1, 0),
(88, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552197689.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958296_474cc7d278c0041b.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958428_d2671acf36ce63bf.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958318_dd4fe034adb831b5.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958468_df0c337928fab1e0.jpg\"]', '2025-04-06 21:26:44', NULL, 1, 0),
(89, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552192688.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017269_4b3bb98cbf74de4d.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017399_63bdab386dd98b2c.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017498_d2bbbd64d90d4fd0.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017582_f6f8afb87451294d.jpg\"]', '2025-04-06 21:27:36', NULL, 1, 0),
(90, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552187975.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066004_19e111c18e15e084.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066480_7b20df1b89bd6164.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066887_2fb33fa92cc94bed.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066589_eec92dc487e06d83.jpg\"]', '2025-04-06 21:28:41', NULL, 1, 0),
(91, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552183406.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134350_803b71ba4a15de87.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134501_46ac9ab1ae7ec405.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134780_f3ed92cd92184fd1.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134789_eedf1f788b221abe.jpg\"]', '2025-04-06 21:29:51', NULL, 1, 0),
(92, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552217758.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946239805_27a287a6099cb1b8.png\"]', '2025-04-06 21:32:00', NULL, 1, 0),
(93, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552231160.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946335917_856f2f33f268618d.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946368027_c3b413f6229484b8.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946379662_5fd386f16ee539d5.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946414742_4e297495b8166cc9.png\"]', '2025-04-06 21:34:06', NULL, 1, 0),
(94, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552238790.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946453335_a6ccc35e23899a4e.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946453767_788f9274570191a6.png\"]', '2025-04-06 21:34:45', NULL, 1, 0),
(95, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552246642.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946496818_e56f6ef610a63833.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946496950_b75b67944515facc.jpg\"]', '2025-04-06 21:35:07', NULL, 1, 0),
(96, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552252015.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946521900_22759d504032a1ad.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946522050_97cb18d6bbe20818.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946522293_40235a079dde313b.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946522454_e9c51f980d9753e5.jpg\"]', '2025-04-06 21:35:57', NULL, 1, 0),
(97, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552258661.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946572157_7de3abd61bf1a0c4.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946572378_984f5dd199785ffb.jpg\"]', '2025-04-06 21:36:28', NULL, 1, 0),
(98, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552269997.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946602262_dbf44cb43e82a283.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946605897_7b14b4774f117da7.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946605894_f011285afc63e203.png\"]', '2025-04-06 21:37:28', NULL, 1, 0),
(99, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552277005.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946661059_a3302a64644803a1.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946661861_83fb0866bbfe7bc5.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946662154_ef15ce674756afdd.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946661996_69ff1a06e4b5556e.png\"]', '2025-04-06 21:38:35', NULL, 1, 0),
(100, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552281963.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947009809_80e129a4a558d576.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947009651_7371789c150e3c52.jpg\"]', '2025-04-06 21:43:58', NULL, 1, 0),
(101, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552287856.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947050310_25512d189d7cdd34.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947050295_a723ae9d44ac8598.jpg\"]', '2025-04-06 21:44:48', NULL, 1, 0),
(102, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552296656.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947102802_caedaf5dc28ea6c8.png\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947150201_9373bbdd96d40045.png\"]', '2025-04-06 21:46:25', NULL, 1, 0),
(103, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552302823.jpg', '[\"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947196789_25beb1ed999b1c3e.jpg\", \"https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947196792_7edf233afc0dd8e3.jpg\"]', '2025-04-06 21:47:04', NULL, 1, 0),
(104, 15, '线条小狗', '', 'dajuzi/xiantiaodog/', 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/covers/compressed_1744552309198.jpg', '[\"https://pub-6d228a7c3aca4c8da42af70a2592d154.r2.dev/dajuzi/xiantiaodog/1743947234033_1bb36df767398224.jpg\", \"https://pub-6d228a7c3aca4c8da42af70a2592d154.r2.dev/dajuzi/xiantiaodog/1743947234138_268fea25bd39bac7.jpg\"]', '2025-04-06 21:48:54', NULL, 1, 0);

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_image_list`
--

CREATE TABLE `wallpaper_image_list` (
  `id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '图片标题',
  `tags_id` varchar(255) NOT NULL COMMENT '标签ID',
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `creation_time` varchar(100) NOT NULL,
  `file` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `favorite_count` int(10) NOT NULL DEFAULT '0' COMMENT '收藏总数',
  `is_webp` int(10) NOT NULL DEFAULT '1' COMMENT '是否开启webp压缩'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wallpaper_image_list`
--

INSERT INTO `wallpaper_image_list` (`id`, `title`, `tags_id`, `category_id`, `category_name`, `creation_time`, `file`, `status`, `url`, `favorite_count`, `is_webp`) VALUES
(314, '', '6,7', 15, '壁纸', '2025-04-20T16:10:56.508Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940683937_5bb1f4b4bb440296.jpg', 2, 1),
(315, '', '6,7', 15, '壁纸', '2025-04-20T16:10:56.508Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940684032_7c7857c3940965cf.jpg', 1, 1),
(316, '', '6,7', 15, '壁纸', '2025-04-20T16:10:56.508Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940684052_d58340282f1f6e7d.jpg', 1, 1),
(317, '', '6,7', 15, '壁纸', '2025-04-20T16:10:56.508Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743940683953_0b2964bd33c0b368.jpg', 2, 1),
(318, '', '6,7', 15, '壁纸', '2025-04-20T16:13:31.647Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424292_a471ca5e0b8010b4.jpg', 3, 1),
(319, '', '6,7', 15, '壁纸', '2025-04-20T16:13:31.647Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424553_917cad1c879e1070.jpg', 0, 1),
(320, '', '6,7', 15, '壁纸', '2025-04-20T16:13:31.647Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424592_c3f4e14ef4139e8d.jpg', 1, 1),
(321, '', '6,7', 15, '壁纸', '2025-04-20T16:13:31.647Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743941424425_2d3e4e45960a5cd1.jpg', 1, 1),
(322, '', '6,7', 15, '壁纸', '2025-04-20T16:15:49.601Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942113980_b574a4f0a551748d.jpg', 0, 1),
(323, '', '6,7', 15, '壁纸', '2025-04-20T16:15:49.601Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942115190_a70f6e52f80e6aea.jpg', 0, 1),
(324, '', '6,7', 15, '壁纸', '2025-04-20T16:15:49.601Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942116665_20636c57c7652016.jpg', 0, 1),
(325, '', '6,7', 15, '壁纸', '2025-04-20T16:15:49.601Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942116695_3f3eafd3e1a1dbf0.jpg', 1, 1),
(326, '', '6,7', 15, '壁纸', '2025-04-20T16:16:01.585Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205045_20fd625b2f682b40.jpg', 1, 1),
(327, '', '6,7', 15, '壁纸', '2025-04-20T16:16:01.585Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205139_8f01879fc9fae634.jpg', 1, 1),
(328, '', '6,7', 15, '壁纸', '2025-04-20T16:16:01.585Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205044_95980d96a494d9fe.jpg', 1, 1),
(329, '', '6,7', 15, '壁纸', '2025-04-20T16:16:01.585Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942205137_d7343b0606b0868f.jpg', 2, 1),
(330, '', '6,7', 15, '壁纸', '2025-04-20T16:16:08.364Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942551426_82733d22b11e27ef.jpg', 0, 1),
(331, '', '6,7', 15, '壁纸', '2025-04-20T16:16:08.364Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942550824_bc89985a0035de48.jpg', 1, 1),
(332, '', '6,7', 15, '壁纸', '2025-04-20T16:16:08.364Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942550829_de0f80f481cc0028.jpg', 0, 1),
(333, '', '6,7', 15, '壁纸', '2025-04-20T16:16:08.364Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942551313_f46693c0f3b58407.jpg', 1, 1),
(334, '', '6,7', 15, '壁纸', '2025-04-20T16:16:08.364Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942551143_dc730dcf01ac00bb.jpg', 1, 1),
(335, '', '6,7', 15, '壁纸', '2025-04-20T16:16:12.580Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942680978_cc0d20cf12746626.jpg', 3, 1),
(336, '', '6,7', 15, '壁纸', '2025-04-20T16:16:12.580Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942681006_63577d9b385c22f6.jpg', 2, 1),
(337, '', '6,7', 15, '壁纸', '2025-04-20T16:16:12.580Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942680981_f8972bd6a9079d47.jpg', 0, 1),
(338, '', '6,7', 15, '壁纸', '2025-04-20T16:16:12.580Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942681004_cb6db75461f86149.jpg', 2, 1),
(339, '', '6,7', 15, '壁纸', '2025-04-20T16:16:17.198Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732673_c6101b89d2363755.jpg', 2, 1),
(340, '', '6,7', 15, '壁纸', '2025-04-20T16:16:17.198Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732696_1a95e7d30d9c90d1.jpg', 2, 1),
(341, '', '6,7', 15, '壁纸', '2025-04-20T16:16:17.198Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732518_4ff2292fe3a23e09.jpg', 1, 1),
(342, '', '6,7', 15, '壁纸', '2025-04-20T16:16:17.198Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942732698_841b8daa4c21be11.jpg', 1, 1),
(343, '', '6,7', 15, '壁纸', '2025-04-20T16:16:22.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859330_cc9133a4d449b09f.jpg', 0, 1),
(344, '', '6,7', 15, '壁纸', '2025-04-20T16:16:22.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859275_20b6bd2a9152e4ce.jpg', 1, 1),
(345, '', '6,7', 15, '壁纸', '2025-04-20T16:16:22.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859352_6e709ee3905724eb.jpg', 2, 1),
(346, '', '6,7', 15, '壁纸', '2025-04-20T16:16:22.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942859417_3851a05d870efefc.jpg', 1, 1),
(347, '', '6,7', 15, '壁纸', '2025-04-20T16:16:33.325Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937383_b93d5b3182431778.jpg', 0, 1),
(348, '', '6,7', 15, '壁纸', '2025-04-20T16:16:33.325Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937315_eb549132322db695.jpg', 2, 1),
(349, '', '6,7', 15, '壁纸', '2025-04-20T16:16:33.325Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937381_f7cea9457a8cae0f.jpg', 0, 1),
(350, '', '6,7', 15, '壁纸', '2025-04-20T16:16:33.325Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937492_755f2d739e508481.jpg', 1, 1),
(351, '', '6,7', 15, '壁纸', '2025-04-20T16:16:33.325Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743942937497_aa0b38a196da77c5.jpg', 2, 1),
(352, '', '6,7', 15, '壁纸', '2025-04-20T16:16:37.582Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011134_ba35ad270ce081ff.jpg', 1, 1),
(353, '', '6,7', 15, '壁纸', '2025-04-20T16:16:37.582Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011234_292c8da32b76da33.jpg', 2, 1),
(354, '', '6,7', 15, '壁纸', '2025-04-20T16:16:37.582Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011066_6b50499e660ad7a7.jpg', 0, 1),
(355, '', '6,7', 15, '壁纸', '2025-04-20T16:16:37.582Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943011226_95723a8a10811a56.jpg', 1, 1),
(356, '', '6,7', 15, '壁纸', '2025-04-20T16:16:41.686Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060697_7eeb7e748f809f73.jpg', 1, 1),
(357, '', '6,7', 15, '壁纸', '2025-04-20T16:16:41.686Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060487_dd4ecfe123c3cbca.jpg', 0, 1),
(358, '', '6,7', 15, '壁纸', '2025-04-20T16:16:41.686Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060675_47b68156dc524469.jpg', 2, 1),
(359, '', '6,7', 15, '壁纸', '2025-04-20T16:16:41.686Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943060695_b2c6c7bf34f1a7f5.jpg', 2, 1),
(360, '', '6,7', 15, '壁纸', '2025-04-20T16:16:46.684Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117259_048393a970bf4d3a.jpg', 1, 1),
(361, '', '6,7', 15, '壁纸', '2025-04-20T16:16:46.684Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117338_927ba3f1f68bdab8.jpg', 1, 1),
(362, '', '6,7', 15, '壁纸', '2025-04-20T16:16:46.684Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117569_d99bb7669dc27827.jpg', 2, 1),
(363, '', '6,7', 15, '壁纸', '2025-04-20T16:16:46.684Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943117744_0b8feed415d88aea.jpg', 0, 1),
(364, '', '6,7', 15, '壁纸', '2025-04-20T16:16:51.304Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173390_820d2e6f1b979d86.jpg', 1, 1),
(365, '', '6,7', 15, '壁纸', '2025-04-20T16:16:51.304Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173442_cbc6b1449f61bbca.jpg', 1, 1),
(366, '', '6,7', 15, '壁纸', '2025-04-20T16:16:51.304Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173625_c9aa16a988385dd4.jpg', 0, 1),
(367, '', '6,7', 15, '壁纸', '2025-04-20T16:16:51.304Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943173808_bbeef7761244440d.jpg', 2, 1),
(368, '', '6,7', 15, '壁纸', '2025-04-20T16:16:55.821Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882175_73143530d4929447.jpg', 3, 1),
(369, '', '6,7', 15, '壁纸', '2025-04-20T16:16:55.821Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882134_802f22ddf74170f6.jpg', 0, 1),
(370, '', '6,7', 15, '壁纸', '2025-04-20T16:16:55.821Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882226_ed89dfbb4ae4daef.jpg', 2, 1),
(371, '', '6,7', 15, '壁纸', '2025-04-20T16:16:55.821Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943882257_f4a6b6dbe3874580.jpg', 1, 1),
(372, '', '6,7', 15, '壁纸', '2025-04-20T16:17:00.083Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762623_e55b39fd18185dd2.jpg', 0, 1),
(373, '', '6,7', 15, '壁纸', '2025-04-20T16:17:00.083Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762778_8f3d99a3851556e5.jpg', 1, 1),
(374, '', '6,7', 15, '壁纸', '2025-04-20T16:17:00.083Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762654_f786bec299bf39cf.jpg', 0, 1),
(375, '', '6,7', 15, '壁纸', '2025-04-20T16:17:00.083Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943762730_895bb09dfc793ac2.jpg', 0, 1),
(376, '', '6,7', 15, '壁纸', '2025-04-20T16:17:04.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316135_129f08314e03e980.jpg', 3, 1),
(377, '', '6,7', 15, '壁纸', '2025-04-20T16:17:04.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316145_4d49692248bce9f2.jpg', 0, 1),
(378, '', '6,7', 15, '壁纸', '2025-04-20T16:17:04.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316920_899ff3e8dd6d8493.jpg', 3, 1),
(379, '', '6,7', 15, '壁纸', '2025-04-20T16:17:04.329Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943316384_7d453911f84296cf.jpg', 1, 1),
(380, '', '6,7', 15, '壁纸', '2025-04-20T16:17:07.965Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943273924_881d32931032bc5f.jpg', 0, 1),
(381, '', '6,7', 15, '壁纸', '2025-04-20T16:17:07.965Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943274140_e49aaad37832fd6d.jpg', 0, 1),
(382, '', '6,7', 15, '壁纸', '2025-04-20T16:17:07.965Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943274135_d9715ee725e29ed8.jpg', 3, 1),
(383, '', '6,7', 15, '壁纸', '2025-04-20T16:17:07.965Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943273926_c94520cfb476930c.jpg', 0, 1),
(384, '', '6,7', 15, '壁纸', '2025-04-20T16:17:11.933Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943223976_b71f60130e3f5893.jpg', 1, 1),
(385, '', '6,7', 15, '壁纸', '2025-04-20T16:17:11.933Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943224938_d6b24af24f2a5600.jpg', 1, 1),
(386, '', '6,7', 15, '壁纸', '2025-04-20T16:17:11.933Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943224077_04eded743c2d1b2e.jpg', 0, 1),
(387, '', '6,7', 15, '壁纸', '2025-04-20T16:17:11.933Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943224675_4726c3e07b2c6022.jpg', 0, 1),
(388, '', '6,7', 15, '壁纸', '2025-04-20T16:17:18.988Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930156_621071e62fc14b5a.jpg', 0, 1),
(389, '', '6,7', 15, '壁纸', '2025-04-20T16:17:18.988Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930097_ea9b6c3900ee7929.jpg', 0, 1),
(390, '', '6,7', 15, '壁纸', '2025-04-20T16:17:18.988Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930012_a767c318434ca8c0.jpg', 2, 1),
(391, '', '6,7', 15, '壁纸', '2025-04-20T16:17:18.988Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943930098_d61a76ab4aaa323b.jpg', 0, 1),
(392, '', '6,7', 15, '壁纸', '2025-04-20T16:17:23.061Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985216_7701455d9feecd6e.jpg', 0, 1),
(393, '', '6,7', 15, '壁纸', '2025-04-20T16:17:23.061Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985523_f6c260b62d1bb104.jpg', 0, 1),
(394, '', '6,7', 15, '壁纸', '2025-04-20T16:17:23.061Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985520_699ba0e20077aa3c.jpg', 3, 1),
(395, '', '6,7', 15, '壁纸', '2025-04-20T16:17:23.061Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743943985414_d0319b1ea617b99d.jpg', 3, 1),
(396, '', '6,7', 15, '壁纸', '2025-04-20T16:17:27.075Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944036353_a8460a5185b1f454.jpg', 3, 1),
(397, '', '6,7', 15, '壁纸', '2025-04-20T16:17:27.075Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944037270_846f54774c6a1344.jpg', 1, 1),
(398, '', '6,7', 15, '壁纸', '2025-04-20T16:17:27.075Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944037036_2e01c4de35dd984f.jpg', 0, 1),
(399, '', '6,7', 15, '壁纸', '2025-04-20T16:17:27.075Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944037004_d50ea9d09e7586d0.jpg', 1, 1),
(400, '', '6,7', 15, '壁纸', '2025-04-20T16:17:32.002Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944257991_aa950a0bdd0b6914.jpg', 0, 1),
(401, '', '6,7', 15, '壁纸', '2025-04-20T16:17:32.002Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944258024_28bd8edc7cbc92f6.jpg', 0, 1),
(402, '', '6,7', 15, '壁纸', '2025-04-20T16:17:32.002Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944258180_f38be3cc2e29f8a8.jpg', 0, 1),
(403, '', '6,7', 15, '壁纸', '2025-04-20T16:17:32.002Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944258173_3f7d4c97107e54e2.jpg', 0, 1),
(404, '', '6,7', 15, '壁纸', '2025-04-20T16:17:36.272Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372437_c518d71ab571874e.jpg', 0, 1),
(405, '', '6,7', 15, '壁纸', '2025-04-20T16:17:36.272Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372560_a99e6c690888c067.jpg', 0, 1),
(406, '', '6,7', 15, '壁纸', '2025-04-20T16:17:36.272Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372901_e8c86671b30af982.jpg', 1, 1),
(407, '', '6,7', 15, '壁纸', '2025-04-20T16:17:36.272Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944372896_c98e6ca13f1bee28.jpg', 2, 1),
(408, '', '6,7', 15, '壁纸', '2025-04-20T16:17:40.234Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944765523_364527b33621b901.jpg', 4, 1),
(409, '', '6,7', 15, '壁纸', '2025-04-20T16:17:40.234Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944766012_1e4bd2f4f37d093f.jpg', 0, 1),
(410, '', '6,7', 15, '壁纸', '2025-04-20T16:17:40.234Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944766121_545abfb37e980877.jpg', 2, 1),
(411, '', '6,7', 15, '壁纸', '2025-04-20T16:17:40.234Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944765598_218bd50fd06645ab.jpg', 1, 1),
(412, '', '6,7', 15, '壁纸', '2025-04-20T16:17:44.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944707748_82f7a13f9f7fc8a6.jpg', 1, 1),
(413, '', '6,7', 15, '壁纸', '2025-04-20T16:17:44.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944707749_4778dcb808e9649c.jpg', 1, 1),
(414, '', '6,7', 15, '壁纸', '2025-04-20T16:17:44.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944727537_c1d3266ce044f8ad.jpg', 0, 1),
(415, '', '6,7', 15, '壁纸', '2025-04-20T16:17:44.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944727446_d7fd3a6113f85cd9.jpg', 1, 1),
(416, '', '6,7', 15, '壁纸', '2025-04-20T16:17:48.256Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638381_e466f49668bb7499.jpg', 2, 1),
(417, '', '6,7', 15, '壁纸', '2025-04-20T16:17:48.256Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638450_92460f9bafef413c.jpg', 1, 1),
(418, '', '6,7', 15, '壁纸', '2025-04-20T16:17:48.256Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638248_8cb5c20eb9c836aa.jpg', 0, 1),
(419, '', '6,7', 15, '壁纸', '2025-04-20T16:17:48.256Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944638465_2fd12beefb185590.jpg', 1, 1),
(420, '', '6,7', 15, '壁纸', '2025-04-20T16:17:52.735Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944567987_e3c30e6a94701cc4.jpg', 2, 1),
(421, '', '6,7', 15, '壁纸', '2025-04-20T16:17:52.735Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944568801_b5ff7362b91f219e.jpg', 0, 1),
(422, '', '6,7', 15, '壁纸', '2025-04-20T16:17:52.735Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944567948_6377407a8462e02a.jpg', 1, 1),
(423, '', '6,7', 15, '壁纸', '2025-04-20T16:17:52.735Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944568811_652840e83382b3df.jpg', 0, 1),
(424, '', '6,7', 15, '壁纸', '2025-04-20T16:17:56.707Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944420027_f1c5cb479be47e13.jpg', 0, 1),
(425, '', '6,7', 15, '壁纸', '2025-04-20T16:17:56.707Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944419978_d8d052e19e58528f.jpg', 2, 1),
(426, '', '6,7', 15, '壁纸', '2025-04-20T16:17:56.707Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944420262_0e10ae1aa9efdf71.jpg', 1, 1),
(427, '', '6,7', 15, '壁纸', '2025-04-20T16:17:56.707Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944420261_2c6b9c23af28687f.jpg', 1, 1),
(428, '', '6,7', 15, '壁纸', '2025-04-20T16:17:56.707Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944515979_a1d818f81d2274fe.jpg', 0, 1),
(429, '', '6,7', 15, '壁纸', '2025-04-20T16:17:56.707Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944520687_ca771ce443ecaae2.jpg', 1, 1),
(430, '', '6,7', 15, '壁纸', '2025-04-20T16:18:03.140Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944848683_146154d28c33e6c3.jpg', 1, 1),
(431, '', '6,7', 15, '壁纸', '2025-04-20T16:18:03.140Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944848673_8f7ba8d5c05b1a50.jpg', 2, 1),
(432, '', '6,7', 15, '壁纸', '2025-04-20T16:18:03.140Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944849155_2f59e3400946410f.jpg', 1, 1),
(433, '', '6,7', 15, '壁纸', '2025-04-20T16:18:03.140Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944848925_e5a32f5b5706cb3f.jpg', 1, 1),
(434, '', '6,7', 15, '壁纸', '2025-04-20T16:18:06.977Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923705_7d28c19fd6c7faf0.jpg', 0, 1),
(435, '', '6,7', 15, '壁纸', '2025-04-20T16:18:06.977Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923721_05e9a4f621151fb0.jpg', 0, 1),
(436, '', '6,7', 15, '壁纸', '2025-04-20T16:18:06.977Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923723_9227679d6e38b3e2.jpg', 0, 1),
(437, '', '6,7', 15, '壁纸', '2025-04-20T16:18:06.977Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944923720_0eddaeac55f96b43.jpg', 0, 1),
(438, '', '6,7', 15, '壁纸', '2025-04-20T16:18:06.977Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944961984_2599748e35b8019d.jpg', 2, 1),
(439, '', '6,7', 15, '壁纸', '2025-04-20T16:18:06.977Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743944961974_f466bd5bf6cbdb67.jpg', 2, 1),
(440, '', '6,7', 15, '壁纸', '2025-04-20T16:18:11.368Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945004842_65ed6cbd3f963747.jpg', 1, 1),
(441, '', '6,7', 15, '壁纸', '2025-04-20T16:18:11.368Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945004915_ae81a5c543003ac1.jpg', 0, 1),
(442, '', '6,7', 15, '壁纸', '2025-04-20T16:18:11.368Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945005002_476f65089c1e4d15.jpg', 1, 1),
(443, '', '6,7', 15, '壁纸', '2025-04-20T16:18:11.368Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945005021_9add3f4ee19494d2.jpg', 1, 1),
(444, '', '6,7', 15, '壁纸', '2025-04-20T16:18:15.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945083534_7cfc56682124d0b5.jpg', 0, 1),
(445, '', '6,7', 15, '壁纸', '2025-04-20T16:18:15.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945083634_998caafed0d2fcb8.jpg', 1, 1),
(446, '', '6,7', 15, '壁纸', '2025-04-20T16:18:15.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945083632_efe1a8578b0aa03b.jpg', 2, 1),
(447, '', '6,7', 15, '壁纸', '2025-04-20T16:18:15.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945105934_5c474d8470fd01b6.jpg', 3, 1),
(448, '', '6,7', 15, '壁纸', '2025-04-20T16:18:15.147Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945105935_627fc0ed434351b5.jpg', 0, 1),
(449, '', '6,7', 15, '壁纸', '2025-04-20T16:18:19.058Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161386_b7ba13ee8b3b2297.jpg', 1, 1),
(450, '', '6,7', 15, '壁纸', '2025-04-20T16:18:19.058Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161771_104dfa29559670e3.jpg', 0, 1),
(451, '', '6,7', 15, '壁纸', '2025-04-20T16:18:19.058Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161248_3bb25ba249f1a3df.jpg', 1, 1),
(452, '', '6,7', 15, '壁纸', '2025-04-20T16:18:19.058Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945161769_7c7babcecd0853cd.jpg', 1, 1),
(453, '', '6,7', 15, '壁纸', '2025-04-20T16:18:23.466Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945247052_6e56d0829e21a29f.jpg', 0, 1),
(454, '', '6,7', 15, '壁纸', '2025-04-20T16:18:23.466Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945247054_dac6c4974cabb29b.jpg', 0, 1),
(455, '', '6,7', 15, '壁纸', '2025-04-20T16:18:23.466Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945247063_3320b4f758ffe83f.jpg', 0, 1),
(456, '', '6,7', 15, '壁纸', '2025-04-20T16:18:23.466Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945301760_a5f581eab7fd7770.jpg', 0, 1),
(457, '', '6,7', 15, '壁纸', '2025-04-20T16:18:23.466Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945301846_2240695f16725173.jpg', 3, 1),
(458, '', '6,7', 15, '壁纸', '2025-04-20T16:18:26.827Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346449_9f086062f28828f4.jpg', 1, 1),
(459, '', '6,7', 15, '壁纸', '2025-04-20T16:18:26.827Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346335_75dc54288a086fdc.jpg', 2, 1),
(460, '', '6,7', 15, '壁纸', '2025-04-20T16:18:26.827Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346560_3fd1e6719f6bc986.jpg', 0, 1),
(461, '', '6,7', 15, '壁纸', '2025-04-20T16:18:26.827Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945346577_881400554e0ceabd.jpg', 0, 1),
(462, '', '6,7', 15, '壁纸', '2025-04-20T16:18:30.567Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395423_af6332bb8ace5605.jpg', 2, 1),
(463, '', '6,7', 15, '壁纸', '2025-04-20T16:18:30.567Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395425_1eb62fa7da6e8305.jpg', 0, 1),
(464, '', '6,7', 15, '壁纸', '2025-04-20T16:18:30.567Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395579_5d3259fb7db879a1.jpg', 2, 1),
(465, '', '6,7', 15, '壁纸', '2025-04-20T16:18:30.567Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945395577_4b46c195897d49fb.jpg', 2, 1),
(466, '', '6,7', 15, '壁纸', '2025-04-20T16:18:34.251Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945431600_cc83a26de26accaa.jpg', 2, 1),
(467, '', '6,7', 15, '壁纸', '2025-04-20T16:18:34.251Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945431662_c62aaf6f2ed6ce52.jpg', 1, 1),
(468, '', '6,7', 15, '壁纸', '2025-04-20T16:18:34.251Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945431771_68d29cc872390570.jpg', 1, 1),
(469, '', '6,7', 15, '壁纸', '2025-04-20T16:18:34.251Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945432065_8e89cebf65c87e82.jpg', 1, 1),
(470, '', '6,7', 15, '壁纸', '2025-04-20T16:18:38.484Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945489735_42a78c764a5327c9.jpg', 0, 1),
(471, '', '6,7', 15, '壁纸', '2025-04-20T16:18:38.484Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945490228_87c48ffdfb619f96.jpg', 1, 1),
(472, '', '6,7', 15, '壁纸', '2025-04-20T16:18:38.484Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945489782_5795f7ea66eb5a11.jpg', 0, 1),
(473, '', '6,7', 15, '壁纸', '2025-04-20T16:18:38.484Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945490228_2b16213a6bc62a14.jpg', 1, 1),
(474, '', '6,7', 15, '壁纸', '2025-04-20T16:18:45.431Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945550803_a478398f4e961bff.jpg', 3, 1),
(475, '', '6,7', 15, '壁纸', '2025-04-20T16:18:45.431Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945551017_7ba412d1940e65c7.jpg', 1, 1),
(476, '', '6,7', 15, '壁纸', '2025-04-20T16:18:45.431Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945550987_ea771da1d65cc750.jpg', 1, 1),
(477, '', '6,7', 15, '壁纸', '2025-04-20T16:18:45.431Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945551093_22dafb8b61ed429a.jpg', 0, 1),
(478, '', '6,7', 15, '壁纸', '2025-04-20T16:18:50.052Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609745_41e30e7feb5d4a81.jpg', 0, 1),
(479, '', '6,7', 15, '壁纸', '2025-04-20T16:18:50.052Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609746_8a5a326eccbe2aa4.jpg', 0, 1),
(480, '', '6,7', 15, '壁纸', '2025-04-20T16:18:50.052Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609824_2774ea5219b1eded.jpg', 1, 1),
(481, '', '6,7', 15, '壁纸', '2025-04-20T16:18:50.052Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945609835_afe26bc9e2bcc1b2.jpg', 0, 1),
(482, '', '6,7', 15, '壁纸', '2025-04-20T16:18:53.803Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862640_bb96c1a929ebe6c2.jpg', 2, 1),
(483, '', '6,7', 15, '壁纸', '2025-04-20T16:18:53.803Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862574_4c288d83f9f5150c.jpg', 1, 1),
(484, '', '6,7', 15, '壁纸', '2025-04-20T16:18:53.803Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862646_550ecf7f25ff66f9.jpg', 0, 1),
(485, '', '6,7', 15, '壁纸', '2025-04-20T16:18:53.803Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945862643_15064d6027452aec.jpg', 2, 1),
(486, '', '6,7', 15, '壁纸', '2025-04-20T16:18:59.102Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958296_474cc7d278c0041b.jpg', 1, 1),
(487, '', '6,7', 15, '壁纸', '2025-04-20T16:18:59.102Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958428_d2671acf36ce63bf.jpg', 1, 1),
(488, '', '6,7', 15, '壁纸', '2025-04-20T16:18:59.102Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958318_dd4fe034adb831b5.jpg', 2, 1),
(489, '', '6,7', 15, '壁纸', '2025-04-20T16:18:59.102Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945958468_df0c337928fab1e0.jpg', 1, 1),
(490, '', '6,7', 15, '壁纸', '2025-04-20T16:19:03.417Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945657623_fbb87274b177e06b.jpg', 1, 1),
(491, '', '6,7', 15, '壁纸', '2025-04-20T16:19:03.417Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945657809_7dd9826617a37f01.jpg', 0, 1),
(492, '', '6,7', 15, '壁纸', '2025-04-20T16:19:03.417Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945657701_bb037fac7442aff8.jpg', 0, 1),
(493, '', '6,7', 15, '壁纸', '2025-04-20T16:19:03.417Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945658012_e91c18ce046ae91e.jpg', 1, 1),
(494, '', '6,7', 15, '壁纸', '2025-04-20T16:19:07.691Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017269_4b3bb98cbf74de4d.jpg', 1, 1),
(495, '', '6,7', 15, '壁纸', '2025-04-20T16:19:07.691Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017399_63bdab386dd98b2c.jpg', 1, 1),
(496, '', '6,7', 15, '壁纸', '2025-04-20T16:19:07.691Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017498_d2bbbd64d90d4fd0.jpg', 0, 1),
(497, '', '6,7', 15, '壁纸', '2025-04-20T16:19:07.691Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946017582_f6f8afb87451294d.jpg', 1, 1),
(498, '', '6,7', 15, '壁纸', '2025-04-20T16:19:12.055Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945699282_f51deca979035f8a.jpg', 1, 1),
(499, '', '6,7', 15, '壁纸', '2025-04-20T16:19:12.055Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945699279_bc3830f7d2778d1f.jpg', 0, 1),
(500, '', '6,7', 15, '壁纸', '2025-04-20T16:19:12.055Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945699279_5faf1309700bdd36.jpg', 0, 1),
(501, '', '6,7', 15, '壁纸', '2025-04-20T16:19:12.055Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945731522_682ea842e4e75344.jpg', 1, 1),
(502, '', '6,7', 15, '壁纸', '2025-04-20T16:19:12.055Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945731524_5995e6fbf9ea3fda.jpg', 1, 1),
(503, '', '6,7', 15, '壁纸', '2025-04-20T16:19:16.128Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066004_19e111c18e15e084.jpg', 0, 1),
(504, '', '6,7', 15, '壁纸', '2025-04-20T16:19:16.128Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066480_7b20df1b89bd6164.jpg', 2, 1),
(505, '', '6,7', 15, '壁纸', '2025-04-20T16:19:16.128Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066887_2fb33fa92cc94bed.jpg', 1, 1),
(506, '', '6,7', 15, '壁纸', '2025-04-20T16:19:16.128Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946066589_eec92dc487e06d83.jpg', 1, 1),
(507, '', '6,7', 15, '壁纸', '2025-04-20T16:19:19.993Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134350_803b71ba4a15de87.jpg', 0, 1),
(508, '', '6,7', 15, '壁纸', '2025-04-20T16:19:19.993Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134501_46ac9ab1ae7ec405.jpg', 0, 1),
(509, '', '6,7', 15, '壁纸', '2025-04-20T16:19:19.993Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134780_f3ed92cd92184fd1.jpg', 0, 1),
(510, '', '6,7', 15, '壁纸', '2025-04-20T16:19:19.993Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946134789_eedf1f788b221abe.jpg', 1, 1),
(511, '', '7,6', 15, '壁纸', '2025-04-20T16:19:24.719Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772150_8a29eeb52bbb568a.jpg', 1, 1),
(512, '', '7,6', 15, '壁纸', '2025-04-20T16:19:24.720Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772319_3d146cea4b265c17.jpg', 0, 1),
(513, '', '7,6', 15, '壁纸', '2025-04-20T16:19:24.720Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772865_990db87a246d4478.jpg', 1, 1),
(514, '', '7,6', 15, '壁纸', '2025-04-20T16:19:24.720Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743945772874_51b629e682745817.jpg', 3, 1),
(515, '', '6,7', 15, '壁纸', '2025-04-20T16:19:31.900Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946239805_27a287a6099cb1b8.png', 0, 1),
(516, '', '6,7', 15, '壁纸', '2025-04-20T16:19:35.831Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946572157_7de3abd61bf1a0c4.jpg', 2, 1),
(517, '', '6,7', 15, '壁纸', '2025-04-20T16:19:35.831Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946572378_984f5dd199785ffb.jpg', 1, 1),
(518, '', '6,7', 15, '壁纸', '2025-04-20T16:19:40.203Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946335917_856f2f33f268618d.png', 3, 1),
(519, '', '6,7', 15, '壁纸', '2025-04-20T16:19:40.203Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946368027_c3b413f6229484b8.png', 0, 1),
(520, '', '6,7', 15, '壁纸', '2025-04-20T16:19:40.203Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946379662_5fd386f16ee539d5.png', 2, 1),
(521, '', '6,7', 15, '壁纸', '2025-04-20T16:19:40.203Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946414742_4e297495b8166cc9.png', 1, 1),
(522, '', '6,7', 15, '壁纸', '2025-04-20T16:19:44.391Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946602262_dbf44cb43e82a283.png', 2, 1),
(523, '', '6,7', 15, '壁纸', '2025-04-20T16:19:44.391Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946605897_7b14b4774f117da7.png', 0, 1),
(524, '', '6,7', 15, '壁纸', '2025-04-20T16:19:44.391Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946605894_f011285afc63e203.png', 2, 1),
(525, '', '6,7', 15, '壁纸', '2025-04-20T16:19:48.327Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946453335_a6ccc35e23899a4e.png', 1, 1),
(526, '', '6,7', 15, '壁纸', '2025-04-20T16:19:48.327Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946453767_788f9274570191a6.png', 1, 1),
(527, '', '6,7', 15, '壁纸', '2025-04-20T16:19:52.790Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946661059_a3302a64644803a1.png', 1, 1),
(528, '', '6,7', 15, '壁纸', '2025-04-20T16:19:52.790Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946661861_83fb0866bbfe7bc5.png', 1, 1),
(529, '', '6,7', 15, '壁纸', '2025-04-20T16:19:52.790Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946662154_ef15ce674756afdd.png', 0, 1),
(530, '', '6,7', 15, '壁纸', '2025-04-20T16:19:52.790Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946661996_69ff1a06e4b5556e.png', 1, 1),
(531, '', '6,7', 15, '壁纸', '2025-04-20T16:19:56.986Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946496818_e56f6ef610a63833.jpg', 2, 1),
(532, '', '6,7', 15, '壁纸', '2025-04-20T16:19:56.986Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946496950_b75b67944515facc.jpg', 1, 1),
(533, '', '6,7', 15, '壁纸', '2025-04-20T16:20:01.017Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947009809_80e129a4a558d576.jpg', 1, 1),
(534, '', '6,7', 15, '壁纸', '2025-04-20T16:20:01.017Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947009651_7371789c150e3c52.jpg', 2, 1),
(535, '', '6,7', 15, '壁纸', '2025-04-20T16:20:04.896Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947050310_25512d189d7cdd34.jpg', 1, 1),
(536, '', '6,7', 15, '壁纸', '2025-04-20T16:20:04.896Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947050295_a723ae9d44ac8598.jpg', 1, 1),
(537, '', '6,7', 15, '壁纸', '2025-04-20T16:20:08.921Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946521900_22759d504032a1ad.jpg', 0, 1),
(538, '', '6,7', 15, '壁纸', '2025-04-20T16:20:08.921Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946522050_97cb18d6bbe20818.jpg', 1, 1),
(539, '', '6,7', 15, '壁纸', '2025-04-20T16:20:08.921Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946522293_40235a079dde313b.jpg', 1, 1),
(540, '', '6,7', 15, '壁纸', '2025-04-20T16:20:08.921Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743946522454_e9c51f980d9753e5.jpg', 1, 1),
(541, '', '6,7', 15, '壁纸', '2025-04-20T16:20:14.606Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947102802_caedaf5dc28ea6c8.png', 1, 1),
(542, '', '6,7', 15, '壁纸', '2025-04-20T16:20:14.606Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947150201_9373bbdd96d40045.png', 1, 1),
(543, '', '7,6', 15, '壁纸', '2025-04-20T16:20:18.593Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947196789_25beb1ed999b1c3e.jpg', 1, 1),
(544, '', '7,6', 15, '壁纸', '2025-04-20T16:20:18.593Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1743947196792_7edf233afc0dd8e3.jpg', 0, 1),
(545, '', '6,7', 15, '壁纸', '2025-04-20T16:20:22.991Z', 'dajuzi/xiantiaodog/', 1, 'https://pub-6d228a7c3aca4c8da42af70a2592d154.r2.dev/dajuzi/xiantiaodog/1743947234033_1bb36df767398224.jpg', 2, 1),
(546, '', '6,7', 15, '壁纸', '2025-04-20T16:20:22.991Z', 'dajuzi/xiantiaodog/', 1, 'https://pub-6d228a7c3aca4c8da42af70a2592d154.r2.dev/dajuzi/xiantiaodog/1743947234138_268fea25bd39bac7.jpg', 2, 1),
(547, '', '5', 11, '美女', '2025-04-20T16:32:12.874Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389816316_5cee74d63b60fcee.png', 1, 1),
(548, '', '5', 11, '美女', '2025-04-20T16:32:12.874Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389816555_b7f48880684bd8f0.png', 0, 1),
(549, '', '5', 11, '美女', '2025-04-20T16:32:16.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389864059_3eaa66670d0070ff.png', 2, 1),
(550, '', '5', 11, '美女', '2025-04-20T16:32:16.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389864229_c2b0999094a5296c.png', 2, 1),
(551, '', '5', 11, '美女', '2025-04-20T16:32:16.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740389864192_4d06b14dbfde0215.png', 0, 1),
(552, '', '5', 11, '美女', '2025-04-20T16:32:24.805Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740705902390_639c38482789e363.png', 1, 1),
(553, '', '5', 11, '美女', '2025-04-20T16:32:24.805Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740705902419_77a065caef32c138.png', 3, 1),
(554, '', '5', 11, '美女', '2025-04-20T16:32:28.531Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715005176_9317314419e37af6.png', 6, 1),
(555, '', '5', 11, '美女', '2025-04-20T16:32:28.531Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715005210_33f785c1f1b46f08.png', 3, 1),
(556, '', '5', 11, '美女', '2025-04-20T16:32:28.531Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715005303_ab8dd0eae0a54714.png', 4, 1),
(557, '', '5', 11, '美女', '2025-04-20T16:32:32.588Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715043136_d43766f390a128b2.png', 1, 1),
(558, '', '5', 11, '美女', '2025-04-20T16:32:32.588Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740715044066_d989a3e22e087675.png', 0, 1),
(559, '', '5', 11, '美女', '2025-04-20T16:32:36.232Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740935126260_2e4421b2ff1ac5b0.png', 1, 1),
(560, '', '5', 11, '美女', '2025-04-20T16:32:36.232Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740935704103_4bcd6c140bb6b582.png', 1, 1),
(561, '', '5', 11, '美女', '2025-04-20T16:32:36.232Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1740935705157_aab1d146c5ec969e.png', 2, 1),
(565, '', '5', 11, '美女', '2025-05-02T17:00:04.125Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746205186609_1d0e29ea9e100971.png', 1, 1),
(566, '', '5', 11, '美女', '2025-05-02T17:03:09.794Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746205364920_eb4c49f144324b87.png', 0, 1),
(567, '', '5', 11, '美女', '2025-05-02T17:03:09.794Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746205364915_5c7e13394259b78e.png', 0, 1),
(568, '', '5', 11, '美女', '2025-05-02T17:03:09.794Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746205364903_6b5ad8806d8239e2.png', 0, 1),
(569, '', '5', 11, '美女', '2025-05-04T01:23:57.367Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746321783442_db2ab108d505f90c.png', 2, 1),
(627, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623853994_64cbe36d07f44634.jpg', 1, 1);
INSERT INTO `wallpaper_image_list` (`id`, `title`, `tags_id`, `category_id`, `category_name`, `creation_time`, `file`, `status`, `url`, `favorite_count`, `is_webp`) VALUES
(628, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623854098_8f5471f1c3e9636a.jpg', 1, 1),
(629, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623854015_1c04b856b3eae43a.jpg', 3, 1),
(630, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623854117_8a7dbb085b7b41ff.jpg', 0, 1),
(631, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623854217_956d22968458ff83.jpg', 1, 1),
(632, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623854118_6f6bf24cfc39c86c.jpg', 1, 1),
(633, '', '8', 21, '风光', '2025-05-07T13:17:52.832Z', 'dajuzi/xiantiaodog/', 1, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/xiantiaodog/1746623854005_f3bed944bfc83c0f.jpg', 2, 1),
(643, '', '10', 11, '美女', '2025-05-07T13:32:56.118Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746624751885_837ddcd3a571d88b.png', 1, 1),
(644, '', '10', 11, '美女', '2025-05-07T13:32:56.118Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746624751814_cd56a07093f6d16e.png', 0, 1),
(645, '', '10', 11, '美女', '2025-05-07T13:32:56.118Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746624751887_b7cb8eb47269a990.png', 1, 1),
(646, '', '10', 11, '美女', '2025-05-07T13:32:56.118Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746624751895_7c2e3390bab7d394.png', 0, 1),
(647, '', '10', 11, '美女', '2025-05-07T13:32:56.118Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746624751894_5a3b6b5b0094c666.png', 0, 1),
(648, '', '10', 11, '美女', '2025-05-07T13:32:56.118Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746624751801_93bc2e681ca8a058.png', 1, 1),
(649, '', '5', 11, '美女', '2025-05-07T14:34:33.286Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746628460428_c70ae890be322701.png', 0, 1),
(650, '', '5', 11, '美女', '2025-05-07T14:34:33.286Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746628460440_88588afbb4a974db.png', 0, 1),
(651, '', '5', 11, '美女', '2025-05-07T14:34:33.286Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746628460431_3b55af7c1352f1ef.png', 0, 1),
(652, '', '5', 11, '美女', '2025-05-07T14:34:33.286Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746628460438_5b575bd7cf999a14.png', 1, 1),
(662, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807527003_95081ac95ec31c1f.jpg', 2, 1),
(663, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807527055_989c87e079666518.jpg', 0, 1),
(664, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807527053_569252f0be6755fc.png', 0, 1),
(665, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807529110_a57cfbf5a195c741.jpg', 0, 1),
(666, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807529255_e7e681b15c3a48cf.jpg', 0, 1),
(667, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807527044_2ff44c899e3dbe0b.png', 0, 1),
(668, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807529667_7903fcd200c00ce7.png', 0, 1),
(669, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807532322_ba5e299f1add222c.png', 0, 1),
(670, '', '11', 11, '美女', '2025-05-09T16:19:18.591Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746807533632_fee95a476c3e5771.png', 0, 1),
(687, '', '11', 11, '美女', '2025-05-09T16:28:58.984Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808108363_214f043e2402d52d.png', 1, 1),
(688, '', '11', 11, '美女', '2025-05-09T16:28:58.984Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808108452_ddb6aff4326d274e.png', 0, 1),
(689, '', '11', 11, '美女', '2025-05-09T16:28:58.984Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808109405_62123074a8ad7b9b.png', 0, 1),
(691, '', '11', 11, '美女', '2025-05-09T16:28:58.984Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808109947_1d81286acc872a94.png', 1, 1),
(692, '', '11', 11, '美女', '2025-05-09T16:28:58.984Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808110112_7ff0491603b5ed01.png', 0, 1),
(693, '', '11', 11, '美女', '2025-05-09T16:28:58.984Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808109397_236252c07ea60a7b.png', 0, 1),
(701, '', '11', 11, '美女', '2025-05-09T16:32:30.982Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808317020_8c78437a4182d03c.png', 0, 1),
(702, '', '11', 11, '美女', '2025-05-09T16:32:30.982Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808317833_9d194b903683d6a4.png', 0, 1),
(703, '', '11', 11, '美女', '2025-05-09T16:32:30.982Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808319568_e09b30e5835c312e.png', 0, 1),
(704, '', '11', 11, '美女', '2025-05-09T16:32:30.982Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808317076_45298c8cac9b2af8.png', 0, 1),
(705, '', '11', 11, '美女', '2025-05-09T16:32:30.982Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746808317092_ee6f889e78343a74.png', 0, 1),
(706, '', '11', 11, '美女', '2025-05-09T16:45:36.493Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746809010449_2c0d26600bfd461c.jpeg', 0, 1),
(707, '', '11', 11, '美女', '2025-05-09T16:45:36.493Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746809021317_7a06cc7c356eb9b4.png', 0, 1),
(708, '', '11', 11, '美女', '2025-05-09T16:45:36.493Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746809040934_950c339bdaa0a582.jpeg', 1, 1),
(709, '', '11', 11, '美女', '2025-05-09T16:45:36.493Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746809101841_c553054da3c32477.jpeg', 1, 1),
(710, '', '11', 11, '美女', '2025-05-09T16:45:36.493Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746809124461_94d4bd6fb569766a.jpeg', 0, 1),
(711, '', '11', 11, '美女', '2025-05-09T16:45:36.493Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1746809129250_7f7a3302314048be.jpeg', 1, 1),
(755, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210411_c5625fec7650c1b9.jpg', 0, 0),
(756, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210544_527fb55169480a2a.jpg', 0, 0),
(757, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210547_72e5af7f62614f4a.jpg', 0, 0),
(758, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210551_d637be80fa916ac8.jpg', 2, 0),
(759, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210512_0600b24b9c50406b.jpg', 1, 0),
(760, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210551_8ac05145eadad880.jpg', 0, 0),
(761, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210556_99b24f463744036c.jpg', 1, 0),
(762, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210565_67c1fb1d52dfb051.jpg', 0, 0),
(763, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210523_2077df5cb77c1e9a.jpg', 0, 0),
(764, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210572_8cb96d44a9b9ea32.jpg', 0, 0),
(765, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210570_18968fb7cbc6ef94.jpg', 0, 0),
(766, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210576_9ccd753de284261a.jpg', 1, 0),
(767, '', '10', 11, '美女', '2025-05-12T16:27:04.717Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747067210573_14948719b0431d0f.jpg', 0, 0),
(785, '', '10', 11, '美女', '2025-05-12T16:53:43.843Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747068811629_ad742bb197ce7816.jpeg', 0, 0),
(786, '', '10', 11, '美女', '2025-05-12T16:53:43.843Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747068811631_0e40cdaebbf7c2c6.jpeg', 0, 0),
(787, '', '10', 11, '美女', '2025-05-12T16:53:43.843Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747068811592_bc81f23b9853d922.jpeg', 0, 0),
(788, '', '10', 11, '美女', '2025-05-12T16:53:43.843Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747068811632_8d8b3b2f16dde2db.jpeg', 0, 0),
(789, '', '10', 11, '美女', '2025-05-12T16:53:43.843Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747068811634_4b99c74310c1411c.jpeg', 0, 0),
(790, '', '10', 11, '美女', '2025-05-12T16:53:43.843Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747068811621_3b52214ae166761c.jpeg', 0, 0),
(814, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236216949_9b152b3d0242cb7f.jpeg', 1, 1),
(815, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236218238_e80bee4fe7697e08.jpeg', 0, 1),
(816, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236218923_9eeeffa41f3eae24.jpeg', 0, 1),
(817, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236218761_695b1b4595209528.jpeg', 0, 1),
(818, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236219078_ce2c0ec4afff79e1.jpeg', 0, 1),
(819, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236218223_38020411c2a70bb0.jpeg', 0, 1),
(820, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236219980_075d7c2cdc8de2ab.jpeg', 1, 1),
(821, '', '10', 11, '美女', '2025-05-14T15:25:05.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236219836_0776c1be471ea807.jpeg', 0, 1),
(822, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236331479_033605cbb964209c.jpeg', 0, 1),
(823, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236333804_2e6a5611d2d9059e.jpeg', 1, 1),
(824, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236333861_5357c337de156244.jpeg', 0, 1),
(825, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236333262_4295605f2611895c.jpeg', 0, 1),
(826, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236333919_0348348043ece1d2.jpeg', 1, 1),
(827, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236333307_3a64b1fdfdd82630.jpeg', 0, 1),
(828, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236333929_212c327c75d8d45f.jpeg', 1, 1),
(829, '', '10', 11, '美女', '2025-05-14T15:26:21.915Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747236334087_eced47cfa2899a2d.jpeg', 0, 1),
(846, '', '11', 11, '美女', '2025-05-14T15:51:45.447Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747237882983_fc0ee7b8cd4d5320.jpeg', 0, 1),
(847, '', '11', 11, '美女', '2025-05-14T15:51:45.447Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747237886680_1c2b1636188d2b2b.jpeg', 0, 1),
(848, '', '11', 11, '美女', '2025-05-14T15:52:50.163Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747237936399_3a2b0c406449de41.jpeg', 0, 1),
(849, '', '11', 11, '美女', '2025-05-14T15:52:50.163Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747237938368_4e1f582e724e5f5d.jpeg', 1, 1),
(850, '', '11', 11, '美女', '2025-05-14T15:55:13.933Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238000783_58850c6c1b6df494.jpeg', 0, 1),
(851, '', '11', 11, '美女', '2025-05-14T15:55:13.933Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238002907_53e2767834d6cd04.jpeg', 0, 1),
(852, '', '11', 11, '美女', '2025-05-14T15:55:13.933Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238002891_d72fa0e66305fdbc.jpeg', 0, 1),
(853, '', '11', 11, '美女', '2025-05-14T15:55:13.933Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238002428_780a7355b150f552.jpeg', 0, 1),
(854, '', '10,11', 11, '美女', '2025-05-14T15:57:13.044Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238176901_ce83836eaa84d8f4.jpeg', 1, 1),
(855, '', '10,11', 11, '美女', '2025-05-14T15:57:13.044Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238178804_d8c1b954a672980b.jpeg', 0, 1),
(856, '', '10,11', 11, '美女', '2025-05-14T15:57:13.044Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238178765_4c4495afe800de35.jpeg', 0, 1),
(857, '', '10,11', 11, '美女', '2025-05-14T15:57:13.044Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238178666_beb4311d9809b78e.jpeg', 0, 1),
(858, '', '10', 11, '美女', '2025-05-14T15:59:05.264Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238289239_f6dc858e709f6862.jpeg', 0, 1),
(859, '', '10', 11, '美女', '2025-05-14T15:59:05.264Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238289507_40bbe8ba3604255a.jpeg', 0, 1),
(860, '', '10', 11, '美女', '2025-05-14T15:59:05.264Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238290092_d809bad366acc74f.jpeg', 0, 1),
(861, '', '10', 11, '美女', '2025-05-14T15:59:05.264Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238290140_96c9e11e67c169f4.jpeg', 0, 1),
(862, '', '10', 11, '美女', '2025-05-14T15:59:05.264Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238289423_c93ee69919e96a23.jpeg', 0, 1),
(863, '', '10', 11, '美女', '2025-05-14T16:00:41.678Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238393327_13672972972faa28.jpeg', 0, 1),
(864, '', '10', 11, '美女', '2025-05-14T16:00:41.678Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238393829_490c8927a20d85d1.jpeg', 1, 1),
(865, '', '10', 11, '美女', '2025-05-14T16:00:41.678Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238393357_c8fa1f19354c6bd1.jpeg', 0, 1),
(866, '', '10', 11, '美女', '2025-05-14T16:00:41.678Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238393780_8da1f4795333f2bf.jpeg', 1, 1),
(867, '', '11', 11, '美女', '2025-05-14T16:02:43.663Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238506031_1ac48d14261305ea.jpeg', 1, 1),
(868, '', '11', 11, '美女', '2025-05-14T16:02:43.663Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238507170_423cf2afba2f9ddb.jpeg', 0, 1),
(869, '', '11', 11, '美女', '2025-05-14T16:02:43.663Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238507071_5ab78d9ff623ab87.jpeg', 1, 1),
(870, '', '11', 11, '美女', '2025-05-14T16:02:43.663Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238507006_dbf0b114e44a2bbc.jpeg', 0, 1),
(871, '', '11', 11, '美女', '2025-05-14T16:02:43.663Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238507879_efeef191f078d792.jpeg', 0, 1),
(872, '', '11', 11, '美女', '2025-05-14T16:02:43.663Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238507325_2e55a8694358e973.jpeg', 0, 1),
(873, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238600999_246be3b3a3f436f0.jpeg', 0, 1),
(874, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238618134_1ff8b95ff5508ea6.jpeg', 0, 1),
(875, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238627635_95aa9978cc42faa5.jpeg', 0, 1),
(876, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238647461_d81b6e50b2604be3.jpeg', 0, 1),
(877, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238649537_14c0f64a577aefca.jpeg', 0, 1),
(878, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238647887_168cde0e6f4a3103.jpeg', 0, 1),
(879, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238649277_1c0fc8e6fad671af.jpeg', 0, 1),
(880, '', '11', 11, '美女', '2025-05-14T16:04:47.910Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238649890_6dec1f5b91d6ae09.jpeg', 0, 1),
(881, '', '11', 11, '美女', '2025-05-14T16:06:18.687Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238714364_a0d9abe6a4396474.jpeg', 0, 1),
(882, '', '11', 11, '美女', '2025-05-14T16:06:18.687Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238714819_72ecef6992fc9bfc.jpeg', 0, 1),
(883, '', '11', 11, '美女', '2025-05-14T16:06:18.687Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238714670_6f13596e2c8f7ef0.jpeg', 0, 1),
(884, '', '11', 11, '美女', '2025-05-14T16:06:18.687Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747238715510_73337a171f3aa963.jpeg', 0, 1),
(898, '', '10', 11, '美女', '2025-05-14T16:19:46.967Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239487895_f6489cf26f201078.jpeg', 0, 1),
(899, '', '10', 11, '美女', '2025-05-14T16:19:46.967Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239488045_f680977698e1c136.jpeg', 0, 1),
(900, '', '10', 11, '美女', '2025-05-14T16:19:46.967Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239487641_d27ced76ab18ad93.jpeg', 0, 1),
(901, '', '10', 11, '美女', '2025-05-14T16:19:46.967Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239488332_3407cb9a8040eff7.jpeg', 1, 1),
(902, '', '10', 11, '美女', '2025-05-14T16:19:46.967Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239488036_4d80af6492fac1ad.jpeg', 1, 1),
(903, '', '10', 11, '美女', '2025-05-14T16:21:10.808Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239609388_bfc8f3f9b5a9d15b.jpeg', 0, 1),
(904, '', '10', 11, '美女', '2025-05-14T16:21:10.808Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239620746_34519ac3dc2c6a3d.jpeg', 0, 1),
(905, '', '10', 11, '美女', '2025-05-14T16:21:10.808Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239609222_fc7360cb9d93be24.jpeg', 0, 1),
(906, '', '10', 11, '美女', '2025-05-14T16:21:10.808Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239620963_7f6e46c013febb90.jpeg', 0, 1),
(907, '', '10', 11, '美女', '2025-05-14T16:21:10.808Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239609364_9dbe8872e8a53a6c.jpeg', 1, 1),
(908, '', '10', 11, '美女', '2025-05-14T16:25:58.905Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239836733_4a4fe612cab14d01.png', 0, 1),
(909, '', '10', 11, '美女', '2025-05-14T16:25:58.905Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239844613_3743f70c3874a476.png', 0, 1),
(910, '', '10', 11, '美女', '2025-05-14T16:25:58.905Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239915252_4947686aaaf1dc24.png', 0, 1),
(911, '', '10', 11, '美女', '2025-05-14T16:25:58.905Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747239920596_6042852d97a76636.png', 0, 1),
(912, '', '10', 11, '美女', '2025-05-14T16:27:57.262Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240031311_324ec250191fc0a1.png', 0, 1),
(913, '', '10', 11, '美女', '2025-05-14T16:27:57.262Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240038986_189f57952eab05eb.png', 1, 1),
(914, '', '10', 11, '美女', '2025-05-14T16:27:57.262Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240047566_04fd97434d64f235.png', 0, 1),
(915, '', '10', 11, '美女', '2025-05-14T16:27:57.262Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240066633_f42d4fbd0cf4b10a.png', 0, 1),
(916, '', '10', 11, '美女', '2025-05-14T16:29:21.758Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240089689_2686620a1f10f7aa.png', 0, 1),
(917, '', '10', 11, '美女', '2025-05-14T16:29:21.758Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240099476_bffeedae4a52c59a.png', 1, 1),
(918, '', '10', 11, '美女', '2025-05-14T16:29:21.758Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240128355_9fa84453c48cdae9.jpg', 0, 1),
(919, '', '10', 11, '美女', '2025-05-14T16:29:21.758Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240138121_2dbf4b18116523d0.jpg', 0, 1),
(920, '', '11', 11, '美女', '2025-05-14T16:30:26.018Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240201376_da5f18eff862fb7b.jpg', 0, 1),
(921, '', '11', 11, '美女', '2025-05-14T16:30:26.018Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240202022_90366eb4a77fe209.jpg', 0, 1),
(922, '', '11', 11, '美女', '2025-05-14T16:30:26.018Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240202026_f566e7ad52706550.jpg', 0, 1),
(923, '', '11', 11, '美女', '2025-05-14T16:30:26.018Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240202025_2524e55e023b04fd.jpg', 0, 1),
(924, '', '11', 11, '美女', '2025-05-14T16:30:26.018Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240202032_0f910a66cb9d10a5.jpg', 0, 1),
(925, '', '10', 11, '美女', '2025-05-14T16:31:19.407Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240246903_00c9f90035a62a56.jpg', 0, 0),
(926, '', '10', 11, '美女', '2025-05-14T16:31:19.407Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240246898_75095b62244d0437.jpeg', 0, 0),
(927, '', '10', 11, '美女', '2025-05-14T16:31:19.407Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240246882_ad4ced37a70b8fa2.jpg', 0, 0),
(928, '', '10', 11, '美女', '2025-05-14T16:31:19.407Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240265419_f0f0e52a1191b59b.jpg', 0, 0),
(929, '', '10', 11, '美女', '2025-05-14T16:31:19.407Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240265422_15240385dabbc801.jpg', 0, 0),
(930, '', '10', 11, '美女', '2025-05-14T16:31:27.157Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240246903_00c9f90035a62a56.jpg', 0, 0),
(931, '', '10', 11, '美女', '2025-05-14T16:31:27.157Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240246898_75095b62244d0437.jpeg', 0, 0),
(932, '', '10', 11, '美女', '2025-05-14T16:31:27.157Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240246882_ad4ced37a70b8fa2.jpg', 1, 0),
(933, '', '10', 11, '美女', '2025-05-14T16:31:27.157Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240265419_f0f0e52a1191b59b.jpg', 0, 0),
(934, '', '10', 11, '美女', '2025-05-14T16:31:27.157Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747240265422_15240385dabbc801.jpg', 0, 0),
(959, '', '11', 11, '美女', '2025-05-14T16:54:15.927Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241641157_bffd254e57c52329.jpg', 0, 0),
(960, '', '11', 11, '美女', '2025-05-14T16:54:15.927Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241641288_bd036b665f08638a.jpg', 0, 0),
(961, '', '11', 11, '美女', '2025-05-14T16:54:15.927Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241641234_afd6c94bfb5c5aef.jpg', 0, 0),
(962, '', '11', 11, '美女', '2025-05-14T16:54:15.927Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241641289_fd1d98c60619d12a.jpg', 0, 0),
(963, '', '11', 11, '美女', '2025-05-14T16:54:15.927Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241641233_cc3048f24bb78971.jpg', 1, 0),
(964, '', '11', 11, '美女', '2025-05-14T16:54:46.408Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241669857_29526e97c63e0c4e.jpg', 0, 0),
(965, '', '11', 11, '美女', '2025-05-14T16:54:46.408Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241669988_802271419a76431a.jpg', 0, 0),
(966, '', '11', 11, '美女', '2025-05-14T16:54:46.408Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241670575_a66049d393680e87.jpg', 0, 0),
(967, '', '11', 11, '美女', '2025-05-14T16:54:46.408Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241669984_2a92457e35d49ae8.jpg', 0, 0),
(968, '', '11', 11, '美女', '2025-05-14T16:54:46.408Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241670505_b0c7376988fe7fb5.jpg', 0, 0),
(969, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241705117_65d8f70d88b946b5.jpg', 0, 0),
(970, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241705165_8c53bce78615a488.jpg', 0, 0),
(971, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241705767_5f4774d548ff8f78.jpg', 2, 0),
(972, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241706429_0fbca3590a4de063.jpg', 0, 0),
(973, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241705959_693608e7cddf07fe.jpg', 0, 0),
(974, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241706483_fc666586cc0e0e4a.jpg', 2, 0),
(975, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241706548_8c61915243ec777c.jpg', 0, 0),
(976, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241705147_84b08ca017073c2e.jpg', 0, 0),
(977, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241706925_e21eeda98d08798a.jpg', 0, 0),
(978, '', '11', 11, '美女', '2025-05-14T16:55:47.611Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241707973_f2acd34f6e372f94.jpg', 0, 0),
(979, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241770322_96b4badfd39bdce7.jpg', 0, 1),
(980, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241770606_0317c255affb115e.jpg', 1, 1),
(981, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241789939_97aa6ac680b43b36.jpg', 0, 1),
(982, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241790047_81a9e5a78a44113a.jpg', 0, 1),
(983, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241814679_d36a3fe8b30dade0.jpg', 0, 1),
(984, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241790067_03426e5c9e1d4944.jpg', 0, 1),
(985, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241814508_78fb8f0fde5c39bf.jpg', 0, 1),
(986, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241856967_f7e337d1f4829db3.jpg', 0, 1),
(987, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241857649_782d6624aeda7fd5.jpg', 0, 1),
(988, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241857681_c1e5b0c3ae34df3f.jpg', 0, 1),
(989, '', '11', 11, '美女', '2025-05-14T16:58:42.690Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241857424_356fb5e5c904d1c8.jpg', 0, 1),
(990, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241947396_15f77f82a68f0a1b.jpg', 0, 0),
(991, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241947457_5f54bc3a42bd9f4b.jpg', 0, 0),
(992, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241948349_f4bb9f7b71f0ba73.jpg', 0, 0),
(993, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241948394_28d3308f6e605013.jpg', 0, 0),
(994, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241948451_ab954f81077833d2.jpg', 0, 0),
(995, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241948846_e6ccc1d2f639c366.jpg', 0, 0),
(996, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241947463_0b45c0e922700e41.jpg', 0, 0),
(997, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241948614_b3e5f94b1f6df4a7.jpg', 0, 0),
(998, '', '11', 11, '美女', '2025-05-14T16:59:46.307Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747241948877_9825397267c30aa8.jpg', 0, 0),
(999, '', '10', 11, '美女', '2025-05-14T17:01:41.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242058959_c0eb0aaab7755e7f.jpg', 0, 1),
(1000, '', '10', 11, '美女', '2025-05-14T17:01:41.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242060657_889643f2fd896152.jpg', 0, 1),
(1001, '', '10', 11, '美女', '2025-05-14T17:01:41.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242060546_ac627e2ea894482f.jpg', 0, 1),
(1002, '', '10', 11, '美女', '2025-05-14T17:01:41.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242059816_4ed0449f762cc1b4.jpg', 0, 1),
(1003, '', '10', 11, '美女', '2025-05-14T17:01:41.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242061175_e7bb710f34d418ef.jpg', 0, 1),
(1004, '', '10', 11, '美女', '2025-05-14T17:03:23.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242114130_803a5a554ccee14f.png', 0, 0),
(1005, '', '10', 11, '美女', '2025-05-14T17:03:23.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242124778_5e3360b0cd88a780.png', 0, 0),
(1006, '', '10', 11, '美女', '2025-05-14T17:03:23.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242134357_67ed6dd1743abc71.png', 0, 0),
(1007, '', '10', 11, '美女', '2025-05-14T17:03:23.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242167186_504625e648a89eee.png', 0, 0),
(1008, '', '10', 11, '美女', '2025-05-14T17:03:23.465Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747242177964_babdcb2476dee7af.png', 0, 0),
(1009, '', '1', 11, '美女', '2025-05-20T07:17:51.342Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725464752_424eb028b57f72e3.webp', 1, 0),
(1010, '', '1', 11, '美女', '2025-05-20T07:17:51.342Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725464787_031a009dbd20c9d8.webp', 0, 0),
(1011, '', '1', 11, '美女', '2025-05-20T07:17:51.342Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725464785_a41a1f75c2eb79d3.webp', 0, 0),
(1012, '', '1', 11, '美女', '2025-05-20T07:17:51.342Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725464789_c41a376cde243ad0.webp', 0, 0),
(1013, '', '1', 11, '美女', '2025-05-20T07:17:51.342Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725464789_ac25762e4e0afecc.webp', 0, 0),
(1022, '', '1', 11, '美女', '2025-05-20T07:19:44.486Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725579540_9100f674b90b4c0e.webp', 0, 0),
(1024, '', '1', 11, '美女', '2025-05-20T07:19:44.486Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725579553_8488596b8e120967.webp', 1, 0),
(1026, '', '1', 11, '美女', '2025-05-20T07:23:06.332Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725779129_040223d57ff6d65b.webp', 0, 0),
(1027, '', '1', 11, '美女', '2025-05-20T07:23:06.332Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725779138_d3787b62590ee4d8.webp', 0, 0),
(1028, '', '1', 11, '美女', '2025-05-20T07:23:06.332Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725779110_b22860ea15dc286e.webp', 0, 0),
(1029, '', '1', 11, '美女', '2025-05-20T07:23:06.332Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747725779059_e5c3bd81528edcb1.webp', 1, 0),
(1034, '', '2,1', 11, '美女', '2025-05-20T07:31:01.715Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747726257840_81effe5a79a7ae24.webp', 0, 0),
(1035, '', '2,1', 11, '美女', '2025-05-20T07:31:01.715Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747726257846_6a3d4514dfdb5c21.webp', 0, 0),
(1036, '', '2,1', 11, '美女', '2025-05-20T07:31:01.715Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747726257898_4cb6712a812eb764.webp', 0, 0),
(1037, '', '2,1', 11, '美女', '2025-05-20T07:31:01.715Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1747726257845_9c9aea23ed00acf2.webp', 0, 0),
(1038, '', '1', 11, '美女', '2025-05-26T15:49:36.468Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748274571419_8d434c209c92087f.jpeg', 2, 0),
(1039, '', '1', 11, '美女', '2025-05-26T15:49:36.468Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748274571413_84ccc9e041719722.jpeg', 0, 0),
(1040, '', '1', 11, '美女', '2025-05-26T15:49:36.468Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748274571402_3d07ffd30ffd26c8.jpeg', 2, 0),
(1041, '', '1', 11, '美女', '2025-05-26T15:49:36.468Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748274571425_f375e5ff27962dda.jpeg', 0, 0),
(1042, '', '1', 11, '美女', '2025-05-26T15:49:36.468Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748274571422_1d14b56fa3e40e45.jpeg', 1, 0),
(1043, '', '1', 11, '美女', '2025-05-28T03:25:16.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748402665549_c740a194ce5bb821.jpg', 0, 1),
(1044, '', '1', 11, '美女', '2025-05-28T03:25:16.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748402666306_98d06a37b2517f4e.jpg', 0, 1),
(1045, '', '1', 11, '美女', '2025-05-28T03:25:16.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748402666333_d199b2592a535a5a.jpg', 0, 1),
(1046, '', '1', 11, '美女', '2025-05-28T03:25:16.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748402665890_feb8344960f64c29.jpg', 0, 1),
(1047, '', '1', 11, '美女', '2025-05-28T03:25:16.868Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748402666038_c96c4287a9b39624.jpg', 0, 1),
(1048, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612623_eb1c0eb0cb3b98a8.jpeg', 0, 0),
(1049, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612627_90dde4f6c30ed77d.jpeg', 0, 0),
(1050, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612769_10f25008e6528d78.jpeg', 1, 0),
(1051, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612770_f0b9bce5433719a2.jpeg', 0, 0),
(1052, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612771_63b16344cf332ec5.jpeg', 1, 0),
(1053, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612801_420517d2a84ec561.jpeg', 0, 0),
(1054, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612788_65f6a3738623b579.jpeg', 0, 0),
(1055, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612822_ab46fd74445792a6.jpeg', 1, 0),
(1056, '', '1,9', 11, '美女', '2025-05-31T23:37:02.640Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748734612730_e777a38a15de7eb7.jpeg', 1, 0),
(1057, '', '9', 22, '穿搭', '2025-05-31T23:38:53.186Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734729131_49e878c9e0962de0.jpeg', 0, 0),
(1058, '', '9', 22, '穿搭', '2025-05-31T23:38:53.186Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734729159_cf9837761e69ba4c.jpeg', 0, 0),
(1059, '', '9', 22, '穿搭', '2025-05-31T23:38:53.186Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734729133_953bde5e0fea44a1.jpeg', 0, 0),
(1060, '', '9', 22, '穿搭', '2025-05-31T23:38:53.186Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734729178_5820cbcf983170a5.jpeg', 0, 0),
(1061, '', '9', 22, '穿搭', '2025-05-31T23:38:53.186Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734729169_a19377a884c65152.jpeg', 0, 0),
(1062, '', '9', 22, '穿搭', '2025-05-31T23:38:53.186Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734729173_93f4b5a6ee96aef4.jpeg', 0, 0),
(1063, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734808766_887401cf7a86604a.jpeg', 0, 0),
(1064, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734808981_833422cf0ece399f.jpeg', 0, 0),
(1065, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734809028_35ffc0178c65e644.jpeg', 0, 0),
(1066, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734809050_2611d2e221d8d447.jpeg', 0, 0),
(1067, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734809236_f14ca3e4ce63f42e.jpeg', 0, 0),
(1068, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734809246_f4ca0855391de821.jpeg', 0, 0),
(1069, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734808941_a5715a3ab4f01124.jpeg', 1, 0),
(1070, '', '9', 22, '穿搭', '2025-05-31T23:40:23.074Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734808951_63602ac20e94880b.jpeg', 0, 0),
(1071, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901572_fcc44ac52968980a.jpeg', 0, 0),
(1072, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901546_abac25fe8313907f.jpeg', 0, 0),
(1073, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901643_a007d6ea2ba69bdb.jpeg', 0, 0),
(1074, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901684_65f4fda719dd361a.jpeg', 0, 0),
(1075, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901695_b3a33a27c791c52e.jpeg', 0, 0),
(1076, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901698_6fbf08ae1012bd27.jpeg', 0, 0),
(1077, '', '9', 22, '穿搭', '2025-05-31T23:41:53.454Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748734901695_feabe55998361aa3.jpeg', 0, 0),
(1078, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134273_8b3537499243e83a.jpeg', 0, 0),
(1079, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134374_eec6c7003ba565bb.jpeg', 0, 0),
(1080, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134304_f3555fad027b9d12.jpeg', 0, 0),
(1081, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134377_5e08d92f2f79cf65.jpeg', 0, 0),
(1082, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134448_c92ec9f615a6d0a6.jpeg', 1, 0),
(1083, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134481_73db94141d0b357b.jpeg', 1, 0),
(1084, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134347_70a9d1f69f0bb803.jpeg', 0, 0),
(1085, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134481_a36793c209ba277f.jpeg', 0, 0);
INSERT INTO `wallpaper_image_list` (`id`, `title`, `tags_id`, `category_id`, `category_name`, `creation_time`, `file`, `status`, `url`, `favorite_count`, `is_webp`) VALUES
(1086, '', '9', 22, '穿搭', '2025-05-31T23:45:47.041Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735134378_82507b4562a1c25e.jpeg', 0, 0),
(1087, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240279_2d273d07b33dd086.jpeg', 0, 0),
(1088, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240243_3c52f627436527d6.jpeg', 0, 0),
(1089, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240290_d4e35efbf35c1904.jpeg', 0, 0),
(1090, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240253_004cd0bd84e2147b.jpeg', 0, 0),
(1091, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240291_37652236730aaa33.jpeg', 1, 0),
(1092, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240340_1dd1dc39a23650bf.jpeg', 1, 0),
(1093, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240341_bfcda13955b970bd.jpeg', 0, 0),
(1094, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240315_ec405978a433fa9f.jpeg', 0, 0),
(1095, '', '9', 22, '穿搭', '2025-05-31T23:47:29.100Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735240294_40e8079df029f9cd.jpeg', 0, 0),
(1096, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735367332_ebc81381e9c67607.jpeg', 0, 0),
(1097, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379030_96426a524fb90f05.jpeg', 0, 0),
(1098, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379080_0b45c9d6146c7400.jpeg', 0, 0),
(1099, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379125_650fc54ca12ada44.jpeg', 0, 0),
(1100, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379130_e5873011e3f574fe.jpeg', 0, 0),
(1101, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379146_97dd039009f3930b.jpeg', 0, 0),
(1102, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379066_79023c56f0d5a47d.jpeg', 0, 0),
(1103, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379380_0b07ec63a21777d8.jpeg', 0, 0),
(1104, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379381_8ccd188f3149fac5.jpeg', 0, 0),
(1105, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379062_c9b856c93926de29.jpeg', 1, 0),
(1106, '', '9', 22, '穿搭', '2025-05-31T23:49:48.105Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735379381_5e88fa9d35dcf16c.jpeg', 0, 0),
(1107, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489184_c2039ed1c3d986db.jpeg', 0, 0),
(1108, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489137_8ec9742f2972761b.jpeg', 0, 0),
(1109, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489219_7aaf7bff12d6c68f.jpeg', 0, 0),
(1110, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489302_6b4cce40e557db4e.jpeg', 0, 0),
(1111, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489252_85e0e811c4e59bdf.jpeg', 0, 0),
(1112, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489344_c2c2370c80de417e.jpeg', 0, 0),
(1113, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489345_f7b2922ba41024ea.jpeg', 0, 0),
(1114, '', '9', 22, '穿搭', '2025-05-31T23:51:38.476Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735489170_ae590d08825da5b7.jpeg', 0, 0),
(1115, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607290_fc47e0b4e2a6b30c.jpeg', 1, 0),
(1116, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607408_96d17d33aa289a0c.jpeg', 1, 0),
(1117, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607281_0c1253f90a2af745.jpeg', 0, 0),
(1118, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607415_30c37c12e97d06d7.jpeg', 0, 0),
(1119, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607497_fad3f39bb995f788.jpeg', 0, 0),
(1120, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607535_917edc4c2513052a.jpeg', 0, 0),
(1121, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607538_ba8413016c7ea16d.jpeg', 0, 0),
(1122, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607685_101e406e705ec307.jpeg', 0, 0),
(1123, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607434_5a040da184673352.jpeg', 0, 0),
(1124, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607708_0111040a718642d3.jpeg', 0, 0),
(1125, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735608532_6af4973b61e47606.jpeg', 1, 0),
(1126, '', '9', 22, '穿搭', '2025-05-31T23:53:38.177Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748735607407_6dc4f09a3762030d.jpeg', 0, 0),
(1127, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353311_86e8c0ade136c264.jpeg', 0, 0),
(1128, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353347_1dbd0f1b5f605ba8.jpeg', 0, 0),
(1129, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353375_8a6366af2e327c3a.jpeg', 0, 0),
(1130, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353405_2462133f5faf3b7f.jpeg', 0, 0),
(1131, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353422_eb76271f9b84d333.jpeg', 1, 0),
(1132, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353438_f4b4318ee590fc8d.jpeg', 0, 0),
(1133, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353405_b720719a0707c562.jpeg', 1, 0),
(1134, '', '9', 22, '穿搭', '2025-06-01T00:06:00.992Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736353368_54b81f2a11a3a71f.jpeg', 0, 0),
(1135, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386517_270051226c017fc3.jpeg', 0, 0),
(1136, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386541_2745facab394bc34.jpeg', 0, 0),
(1137, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386539_81c4cd34cde5c1dc.jpeg', 1, 0),
(1138, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386590_bf20d40bd6812a9f.jpeg', 0, 0),
(1139, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386548_9ec065284c93a4b3.jpeg', 0, 0),
(1140, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386555_675e847a8761f0b2.jpeg', 0, 0),
(1141, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386604_4f65b4b7d4468eea.jpeg', 0, 0),
(1142, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386597_f57fa212ce8b3973.jpeg', 0, 0),
(1143, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386606_942b6bc48a2723b9.jpeg', 0, 0),
(1144, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386606_ebfb0ee81debf971.jpeg', 0, 0),
(1145, '', '9', 22, '穿搭', '2025-06-01T00:06:32.229Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748736386592_02a0b6fbd0f26883.jpeg', 0, 0),
(1166, '', '9', 22, '穿搭', '2025-06-01T00:18:19.592Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737095298_ac92ae05fe9ac87d.jpeg', 0, 0),
(1167, '', '9', 22, '穿搭', '2025-06-01T00:18:19.592Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737095457_125d4b37bd634857.jpeg', 0, 0),
(1168, '', '9', 22, '穿搭', '2025-06-01T00:18:19.592Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737095497_7d5f8a3c7118609b.jpeg', 1, 0),
(1169, '', '9', 22, '穿搭', '2025-06-01T00:18:19.592Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737095499_e221a37423fd5f79.jpeg', 0, 0),
(1170, '', '9', 22, '穿搭', '2025-06-01T00:18:19.592Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737095415_d5c2fa3acff992b6.jpeg', 0, 0),
(1171, '', '9', 22, '穿搭', '2025-06-01T00:18:19.592Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737095451_88bffe84248407ad.jpeg', 0, 0),
(1172, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119660_541845db36bc9202.jpeg', 0, 0),
(1173, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119709_131057d83350ed17.jpeg', 0, 0),
(1174, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119615_04ee2fd8402443cf.jpeg', 0, 0),
(1175, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119730_a2dd50d77f734d2d.jpeg', 0, 0),
(1176, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119772_ee9da24a16229db2.jpeg', 0, 0),
(1177, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119616_29552909e54e7dc8.jpeg', 0, 0),
(1178, '', '9', 22, '穿搭', '2025-06-01T00:18:43.365Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737119762_19b5cdc9ca23d279.jpeg', 0, 0),
(1179, '', '9', 22, '穿搭', '2025-06-01T00:19:16.423Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737151995_253dc0f1ac818956.jpeg', 0, 0),
(1180, '', '9', 22, '穿搭', '2025-06-01T00:19:16.423Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737152013_bc060c9f0d900805.jpeg', 0, 0),
(1181, '', '9', 22, '穿搭', '2025-06-01T00:19:16.423Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737152031_c87ee9f5cf4f3527.jpeg', 0, 0),
(1182, '', '9', 22, '穿搭', '2025-06-01T00:19:16.423Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737151900_233be8acf6f38c1e.jpeg', 0, 0),
(1183, '', '9', 22, '穿搭', '2025-06-01T00:19:16.423Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737151962_31b28e1ba9c1c254.jpeg', 1, 0),
(1184, '', '9', 22, '穿搭', '2025-06-01T00:19:47.191Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737183201_9cd6470fa262059c.jpeg', 1, 0),
(1185, '', '9', 22, '穿搭', '2025-06-01T00:19:47.191Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737183273_8683643f9cf46731.jpeg', 1, 0),
(1186, '', '9', 22, '穿搭', '2025-06-01T00:19:47.191Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737183291_cfee515621ded96c.jpeg', 0, 0),
(1187, '', '9', 22, '穿搭', '2025-06-01T00:19:47.191Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737183314_34e435a9e2697778.jpeg', 1, 0),
(1188, '', '9', 22, '穿搭', '2025-06-01T00:19:47.191Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737183343_393a15c298a02774.jpeg', 0, 0),
(1189, '', '9', 22, '穿搭', '2025-06-01T00:20:20.895Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737215265_1ed0713e4b61ed88.jpeg', 0, 0),
(1190, '', '9', 22, '穿搭', '2025-06-01T00:20:20.895Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737215280_bc58d4d0b8c4651e.jpeg', 0, 0),
(1191, '', '9', 22, '穿搭', '2025-06-01T00:20:20.895Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737215363_2dad1a0143ed8734.jpeg', 0, 0),
(1192, '', '9', 22, '穿搭', '2025-06-01T00:20:20.895Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737215373_86db13c1d778a24b.jpeg', 0, 0),
(1193, '', '9', 22, '穿搭', '2025-06-01T00:20:20.895Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737215383_6c37be01371831c2.jpeg', 0, 0),
(1194, '', '9', 22, '穿搭', '2025-06-01T00:20:20.895Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748737215385_bff18b836aa3ad9d.jpeg', 0, 0),
(1195, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201318_3e55e6422259618b.jpeg', 0, 0),
(1196, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201331_14dbc4efc79197f9.jpeg', 0, 0),
(1197, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201340_d951936825ad9e0d.jpeg', 0, 0),
(1198, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201305_ab241675c533a112.jpeg', 0, 0),
(1199, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201396_1e69e6f7ef90a281.jpeg', 0, 0),
(1200, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201442_b5d99e7842855535.jpeg', 0, 0),
(1201, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201371_fa989dec3fc5c005.jpeg', 0, 0),
(1202, '', '9', 22, '穿搭', '2025-06-01T00:53:29.475Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748739201427_21b25389d0196b62.jpeg', 0, 0),
(1203, '', '9', 22, '穿搭', '2025-06-01T01:15:12.882Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748740507571_89161acc941d1541.jpeg', 0, 0),
(1204, '', '9', 22, '穿搭', '2025-06-01T01:15:12.882Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748740507688_35172f6743ecdf8b.jpeg', 1, 0),
(1205, '', '9', 22, '穿搭', '2025-06-01T01:15:12.882Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748740507708_713fea823e720428.jpeg', 0, 0),
(1206, '', '9', 22, '穿搭', '2025-06-01T01:15:12.882Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748740507708_eadb5af6921c6972.jpeg', 0, 0),
(1207, '', '9', 22, '穿搭', '2025-06-01T01:15:12.882Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748740507692_433655083105e0a7.jpeg', 0, 0),
(1208, '', '9', 22, '穿搭', '2025-06-01T01:15:12.882Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748740507686_7e37c0bfef588fd9.jpeg', 0, 0),
(1216, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755296123_9e50a87b5f352712.jpeg', 1, 0),
(1217, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755296493_c5060beb78e03a27.jpeg', 0, 0),
(1218, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755296985_d7eac1ef59a77606.jpeg', 0, 0),
(1219, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755296216_d4631b895f5b1a1e.jpeg', 0, 0),
(1220, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755297066_cdd2da3cf1368267.jpeg', 1, 0),
(1221, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755296825_50569568f6e67d4f.jpeg', 2, 0),
(1222, '', '9', 22, '穿搭', '2025-06-01T05:21:45.633Z', 'dajuzi/chuanda/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/chuanda/1748755297104_3fb66c7a5d7cdbfa.jpeg', 0, 0),
(1223, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234517_c3456ac584904a5a.jpeg', 0, 0),
(1224, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234562_0230f11aba4b740a.jpeg', 2, 0),
(1225, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234561_20959394423f9561.jpeg', 0, 0),
(1226, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234590_67b309c40ec37a59.jpeg', 1, 0),
(1227, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234564_f89a539116b7b023.jpeg', 0, 0),
(1228, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234615_228c0d44dab0523c.jpeg', 1, 0),
(1229, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234586_46efebfeecb5538c.jpeg', 0, 0),
(1230, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234594_8b515a97f909292c.jpeg', 0, 0),
(1231, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234620_4e70d8a2c4c1e76b.jpeg', 1, 0),
(1232, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234666_d852539223e834ee.jpeg', 0, 0),
(1233, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234669_13552a66323f1cbe.jpeg', 1, 0),
(1234, '', '1', 11, '美女', '2025-06-01T05:37:23.666Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756234631_596dbc66c76d82d0.jpeg', 1, 0),
(1235, '', '1', 11, '美女', '2025-06-01T05:48:47.590Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756923318_0bcfe2682adc9bd5.jpeg', 0, 0),
(1236, '', '1', 11, '美女', '2025-06-01T05:48:47.590Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756923298_d1f1b9c31f6ef8ce.jpeg', 0, 0),
(1237, '', '1', 11, '美女', '2025-06-01T05:48:47.590Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756923320_c72bef275ec21fcc.jpeg', 3, 0),
(1238, '', '1', 11, '美女', '2025-06-01T05:48:47.590Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1748756923280_2f62131740196a76.jpeg', 1, 0),
(1239, '123', '1', 11, '美女', '2026-03-08T13:00:29.347Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1772974712597_cc6f2fe73f8c01b4.jpg', 0, 1),
(1240, '123', '1', 11, '美女', '2026-03-08T13:00:29.347Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1772974718003_18f9f05a8af2e50f.jpg', 0, 1),
(1241, '333', '1', 11, '美女', '2026-03-08T13:00:52.508Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1772974845656_f0a36f681f02b8a2.jpg', 0, 1),
(1242, '333', '1', 11, '美女', '2026-03-08T13:00:52.508Z', 'dajuzi/gufeng/', 0, 'https://juzi-1253562145.cos.ap-guangzhou.myqcloud.com/dajuzi/gufeng/1772974850341_44cf0ad8f1ecd407.jpg', 0, 1);

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_image_tags`
--

CREATE TABLE `wallpaper_image_tags` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET utf8 COMMENT '标签列表',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `image_total` int(11) DEFAULT NULL COMMENT '图片数量',
  `status` int(11) NOT NULL COMMENT '显示/隐藏',
  `group_id` int(11) NOT NULL COMMENT '分类ID',
  `group_name` varchar(255) NOT NULL COMMENT '分类名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wallpaper_image_tags`
--

INSERT INTO `wallpaper_image_tags` (`id`, `name`, `sort`, `image_total`, `status`, `group_id`, `group_name`) VALUES
(1, '自然', 5, NULL, 0, 11, '美女'),
(2, '写真', 6, NULL, 0, 11, '美女'),
(3, '古风', 1, NULL, 0, 11, '美女'),
(6, '线条小狗', 2, NULL, 1, 15, '壁纸'),
(7, '卡通', 3, NULL, 1, 15, '壁纸'),
(8, '风光', 4, NULL, 1, 21, '风光'),
(12, 'ootd', 0, NULL, 0, 11, '美女');

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_image_to_tags`
--

CREATE TABLE `wallpaper_image_to_tags` (
  `id` int(11) NOT NULL,
  `image_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wallpaper_image_to_tags`
--

INSERT INTO `wallpaper_image_to_tags` (`id`, `image_id`, `tag_id`, `created_at`) VALUES
(1, 314, 6, '2025-04-20 16:10:59'),
(2, 314, 7, '2025-04-20 16:10:59'),
(3, 315, 6, '2025-04-20 16:10:59'),
(4, 315, 7, '2025-04-20 16:10:59'),
(5, 316, 6, '2025-04-20 16:10:59'),
(6, 316, 7, '2025-04-20 16:10:59'),
(7, 317, 6, '2025-04-20 16:10:59'),
(8, 317, 7, '2025-04-20 16:10:59'),
(9, 318, 6, '2025-04-20 16:13:32'),
(10, 318, 7, '2025-04-20 16:13:32'),
(11, 319, 6, '2025-04-20 16:13:32'),
(12, 319, 7, '2025-04-20 16:13:32'),
(13, 320, 6, '2025-04-20 16:13:32'),
(14, 320, 7, '2025-04-20 16:13:32'),
(15, 321, 6, '2025-04-20 16:13:32'),
(16, 321, 7, '2025-04-20 16:13:32'),
(17, 322, 6, '2025-04-20 16:15:50'),
(18, 322, 7, '2025-04-20 16:15:50'),
(19, 323, 6, '2025-04-20 16:15:50'),
(20, 323, 7, '2025-04-20 16:15:50'),
(21, 324, 6, '2025-04-20 16:15:50'),
(22, 324, 7, '2025-04-20 16:15:50'),
(23, 325, 6, '2025-04-20 16:15:50'),
(24, 325, 7, '2025-04-20 16:15:50'),
(25, 326, 6, '2025-04-20 16:16:02'),
(26, 326, 7, '2025-04-20 16:16:02'),
(27, 327, 6, '2025-04-20 16:16:02'),
(28, 327, 7, '2025-04-20 16:16:02'),
(29, 328, 6, '2025-04-20 16:16:02'),
(30, 328, 7, '2025-04-20 16:16:02'),
(31, 329, 6, '2025-04-20 16:16:02'),
(32, 329, 7, '2025-04-20 16:16:02'),
(33, 330, 6, '2025-04-20 16:16:09'),
(34, 330, 7, '2025-04-20 16:16:09'),
(35, 331, 6, '2025-04-20 16:16:09'),
(36, 331, 7, '2025-04-20 16:16:09'),
(37, 332, 6, '2025-04-20 16:16:09'),
(38, 332, 7, '2025-04-20 16:16:09'),
(39, 333, 6, '2025-04-20 16:16:09'),
(40, 333, 7, '2025-04-20 16:16:09'),
(41, 334, 6, '2025-04-20 16:16:09'),
(42, 334, 7, '2025-04-20 16:16:09'),
(43, 335, 6, '2025-04-20 16:16:13'),
(44, 335, 7, '2025-04-20 16:16:13'),
(45, 336, 6, '2025-04-20 16:16:13'),
(46, 336, 7, '2025-04-20 16:16:13'),
(47, 337, 6, '2025-04-20 16:16:13'),
(48, 337, 7, '2025-04-20 16:16:13'),
(49, 338, 6, '2025-04-20 16:16:13'),
(50, 338, 7, '2025-04-20 16:16:13'),
(51, 339, 6, '2025-04-20 16:16:18'),
(52, 339, 7, '2025-04-20 16:16:18'),
(53, 340, 6, '2025-04-20 16:16:18'),
(54, 340, 7, '2025-04-20 16:16:18'),
(55, 341, 6, '2025-04-20 16:16:18'),
(56, 341, 7, '2025-04-20 16:16:18'),
(57, 342, 6, '2025-04-20 16:16:18'),
(58, 342, 7, '2025-04-20 16:16:18'),
(59, 343, 6, '2025-04-20 16:16:23'),
(60, 343, 7, '2025-04-20 16:16:23'),
(61, 344, 6, '2025-04-20 16:16:23'),
(62, 344, 7, '2025-04-20 16:16:23'),
(63, 345, 6, '2025-04-20 16:16:23'),
(64, 345, 7, '2025-04-20 16:16:23'),
(65, 346, 6, '2025-04-20 16:16:23'),
(66, 346, 7, '2025-04-20 16:16:23'),
(67, 347, 6, '2025-04-20 16:16:34'),
(68, 347, 7, '2025-04-20 16:16:34'),
(69, 348, 6, '2025-04-20 16:16:34'),
(70, 348, 7, '2025-04-20 16:16:34'),
(71, 349, 6, '2025-04-20 16:16:34'),
(72, 349, 7, '2025-04-20 16:16:34'),
(73, 350, 6, '2025-04-20 16:16:34'),
(74, 350, 7, '2025-04-20 16:16:34'),
(75, 351, 6, '2025-04-20 16:16:34'),
(76, 351, 7, '2025-04-20 16:16:34'),
(77, 352, 6, '2025-04-20 16:16:38'),
(78, 352, 7, '2025-04-20 16:16:38'),
(79, 353, 6, '2025-04-20 16:16:38'),
(80, 353, 7, '2025-04-20 16:16:38'),
(81, 354, 6, '2025-04-20 16:16:38'),
(82, 354, 7, '2025-04-20 16:16:38'),
(83, 355, 6, '2025-04-20 16:16:38'),
(84, 355, 7, '2025-04-20 16:16:38'),
(85, 356, 6, '2025-04-20 16:16:42'),
(86, 356, 7, '2025-04-20 16:16:42'),
(87, 357, 6, '2025-04-20 16:16:42'),
(88, 357, 7, '2025-04-20 16:16:42'),
(89, 358, 6, '2025-04-20 16:16:42'),
(90, 358, 7, '2025-04-20 16:16:42'),
(91, 359, 6, '2025-04-20 16:16:42'),
(92, 359, 7, '2025-04-20 16:16:42'),
(93, 360, 6, '2025-04-20 16:16:47'),
(94, 360, 7, '2025-04-20 16:16:47'),
(95, 361, 6, '2025-04-20 16:16:47'),
(96, 361, 7, '2025-04-20 16:16:47'),
(97, 362, 6, '2025-04-20 16:16:47'),
(98, 362, 7, '2025-04-20 16:16:47'),
(99, 363, 6, '2025-04-20 16:16:47'),
(100, 363, 7, '2025-04-20 16:16:47'),
(101, 364, 6, '2025-04-20 16:16:52'),
(102, 364, 7, '2025-04-20 16:16:52'),
(103, 365, 6, '2025-04-20 16:16:52'),
(104, 365, 7, '2025-04-20 16:16:52'),
(105, 366, 6, '2025-04-20 16:16:52'),
(106, 366, 7, '2025-04-20 16:16:52'),
(107, 367, 6, '2025-04-20 16:16:52'),
(108, 367, 7, '2025-04-20 16:16:52'),
(109, 368, 6, '2025-04-20 16:16:56'),
(110, 368, 7, '2025-04-20 16:16:56'),
(111, 369, 6, '2025-04-20 16:16:56'),
(112, 369, 7, '2025-04-20 16:16:56'),
(113, 370, 6, '2025-04-20 16:16:56'),
(114, 370, 7, '2025-04-20 16:16:56'),
(115, 371, 6, '2025-04-20 16:16:56'),
(116, 371, 7, '2025-04-20 16:16:56'),
(117, 372, 6, '2025-04-20 16:17:01'),
(118, 372, 7, '2025-04-20 16:17:01'),
(119, 373, 6, '2025-04-20 16:17:01'),
(120, 373, 7, '2025-04-20 16:17:01'),
(121, 374, 6, '2025-04-20 16:17:01'),
(122, 374, 7, '2025-04-20 16:17:01'),
(123, 375, 6, '2025-04-20 16:17:01'),
(124, 375, 7, '2025-04-20 16:17:01'),
(125, 376, 6, '2025-04-20 16:17:05'),
(126, 376, 7, '2025-04-20 16:17:05'),
(127, 377, 6, '2025-04-20 16:17:05'),
(128, 377, 7, '2025-04-20 16:17:05'),
(129, 378, 6, '2025-04-20 16:17:05'),
(130, 378, 7, '2025-04-20 16:17:05'),
(131, 379, 6, '2025-04-20 16:17:05'),
(132, 379, 7, '2025-04-20 16:17:05'),
(133, 380, 6, '2025-04-20 16:17:08'),
(134, 380, 7, '2025-04-20 16:17:08'),
(135, 381, 6, '2025-04-20 16:17:08'),
(136, 381, 7, '2025-04-20 16:17:08'),
(137, 382, 6, '2025-04-20 16:17:08'),
(138, 382, 7, '2025-04-20 16:17:08'),
(139, 383, 6, '2025-04-20 16:17:08'),
(140, 383, 7, '2025-04-20 16:17:08'),
(141, 384, 6, '2025-04-20 16:17:12'),
(142, 384, 7, '2025-04-20 16:17:12'),
(143, 385, 6, '2025-04-20 16:17:12'),
(144, 385, 7, '2025-04-20 16:17:12'),
(145, 386, 6, '2025-04-20 16:17:12'),
(146, 386, 7, '2025-04-20 16:17:12'),
(147, 387, 6, '2025-04-20 16:17:12'),
(148, 387, 7, '2025-04-20 16:17:12'),
(149, 388, 6, '2025-04-20 16:17:19'),
(150, 388, 7, '2025-04-20 16:17:19'),
(151, 389, 6, '2025-04-20 16:17:19'),
(152, 389, 7, '2025-04-20 16:17:19'),
(153, 390, 6, '2025-04-20 16:17:19'),
(154, 390, 7, '2025-04-20 16:17:19'),
(155, 391, 6, '2025-04-20 16:17:19'),
(156, 391, 7, '2025-04-20 16:17:19'),
(157, 392, 6, '2025-04-20 16:17:24'),
(158, 392, 7, '2025-04-20 16:17:24'),
(159, 393, 6, '2025-04-20 16:17:24'),
(160, 393, 7, '2025-04-20 16:17:24'),
(161, 394, 6, '2025-04-20 16:17:24'),
(162, 394, 7, '2025-04-20 16:17:24'),
(163, 395, 6, '2025-04-20 16:17:24'),
(164, 395, 7, '2025-04-20 16:17:24'),
(165, 396, 6, '2025-04-20 16:17:28'),
(166, 396, 7, '2025-04-20 16:17:28'),
(167, 397, 6, '2025-04-20 16:17:28'),
(168, 397, 7, '2025-04-20 16:17:28'),
(169, 398, 6, '2025-04-20 16:17:28'),
(170, 398, 7, '2025-04-20 16:17:28'),
(171, 399, 6, '2025-04-20 16:17:28'),
(172, 399, 7, '2025-04-20 16:17:28'),
(173, 400, 6, '2025-04-20 16:17:32'),
(174, 400, 7, '2025-04-20 16:17:32'),
(175, 401, 6, '2025-04-20 16:17:32'),
(176, 401, 7, '2025-04-20 16:17:32'),
(177, 402, 6, '2025-04-20 16:17:32'),
(178, 402, 7, '2025-04-20 16:17:32'),
(179, 403, 6, '2025-04-20 16:17:32'),
(180, 403, 7, '2025-04-20 16:17:32'),
(181, 404, 6, '2025-04-20 16:17:37'),
(182, 404, 7, '2025-04-20 16:17:37'),
(183, 405, 6, '2025-04-20 16:17:37'),
(184, 405, 7, '2025-04-20 16:17:37'),
(185, 406, 6, '2025-04-20 16:17:37'),
(186, 406, 7, '2025-04-20 16:17:37'),
(187, 407, 6, '2025-04-20 16:17:37'),
(188, 407, 7, '2025-04-20 16:17:37'),
(189, 408, 6, '2025-04-20 16:17:41'),
(190, 408, 7, '2025-04-20 16:17:41'),
(191, 409, 6, '2025-04-20 16:17:41'),
(192, 409, 7, '2025-04-20 16:17:41'),
(193, 410, 6, '2025-04-20 16:17:41'),
(194, 410, 7, '2025-04-20 16:17:41'),
(195, 411, 6, '2025-04-20 16:17:41'),
(196, 411, 7, '2025-04-20 16:17:41'),
(197, 412, 6, '2025-04-20 16:17:45'),
(198, 412, 7, '2025-04-20 16:17:45'),
(199, 413, 6, '2025-04-20 16:17:45'),
(200, 413, 7, '2025-04-20 16:17:45'),
(201, 414, 6, '2025-04-20 16:17:45'),
(202, 414, 7, '2025-04-20 16:17:45'),
(203, 415, 6, '2025-04-20 16:17:45'),
(204, 415, 7, '2025-04-20 16:17:45'),
(205, 416, 6, '2025-04-20 16:17:49'),
(206, 416, 7, '2025-04-20 16:17:49'),
(207, 417, 6, '2025-04-20 16:17:49'),
(208, 417, 7, '2025-04-20 16:17:49'),
(209, 418, 6, '2025-04-20 16:17:49'),
(210, 418, 7, '2025-04-20 16:17:49'),
(211, 419, 6, '2025-04-20 16:17:49'),
(212, 419, 7, '2025-04-20 16:17:49'),
(213, 420, 6, '2025-04-20 16:17:53'),
(214, 420, 7, '2025-04-20 16:17:53'),
(215, 421, 6, '2025-04-20 16:17:53'),
(216, 421, 7, '2025-04-20 16:17:53'),
(217, 422, 6, '2025-04-20 16:17:53'),
(218, 422, 7, '2025-04-20 16:17:53'),
(219, 423, 6, '2025-04-20 16:17:53'),
(220, 423, 7, '2025-04-20 16:17:53'),
(221, 424, 6, '2025-04-20 16:17:57'),
(222, 424, 7, '2025-04-20 16:17:57'),
(223, 425, 6, '2025-04-20 16:17:57'),
(224, 425, 7, '2025-04-20 16:17:57'),
(225, 426, 6, '2025-04-20 16:17:57'),
(226, 426, 7, '2025-04-20 16:17:57'),
(227, 427, 6, '2025-04-20 16:17:57'),
(228, 427, 7, '2025-04-20 16:17:57'),
(229, 428, 6, '2025-04-20 16:17:57'),
(230, 428, 7, '2025-04-20 16:17:57'),
(231, 429, 6, '2025-04-20 16:17:57'),
(232, 429, 7, '2025-04-20 16:17:57'),
(233, 430, 6, '2025-04-20 16:18:04'),
(234, 430, 7, '2025-04-20 16:18:04'),
(235, 431, 6, '2025-04-20 16:18:04'),
(236, 431, 7, '2025-04-20 16:18:04'),
(237, 432, 6, '2025-04-20 16:18:04'),
(238, 432, 7, '2025-04-20 16:18:04'),
(239, 433, 6, '2025-04-20 16:18:04'),
(240, 433, 7, '2025-04-20 16:18:04'),
(241, 434, 6, '2025-04-20 16:18:07'),
(242, 434, 7, '2025-04-20 16:18:07'),
(243, 435, 6, '2025-04-20 16:18:07'),
(244, 435, 7, '2025-04-20 16:18:07'),
(245, 436, 6, '2025-04-20 16:18:07'),
(246, 436, 7, '2025-04-20 16:18:07'),
(247, 437, 6, '2025-04-20 16:18:07'),
(248, 437, 7, '2025-04-20 16:18:07'),
(249, 438, 6, '2025-04-20 16:18:07'),
(250, 438, 7, '2025-04-20 16:18:07'),
(251, 439, 6, '2025-04-20 16:18:07'),
(252, 439, 7, '2025-04-20 16:18:07'),
(253, 440, 6, '2025-04-20 16:18:12'),
(254, 440, 7, '2025-04-20 16:18:12'),
(255, 441, 6, '2025-04-20 16:18:12'),
(256, 441, 7, '2025-04-20 16:18:12'),
(257, 442, 6, '2025-04-20 16:18:12'),
(258, 442, 7, '2025-04-20 16:18:12'),
(259, 443, 6, '2025-04-20 16:18:12'),
(260, 443, 7, '2025-04-20 16:18:12'),
(261, 444, 6, '2025-04-20 16:18:16'),
(262, 444, 7, '2025-04-20 16:18:16'),
(263, 445, 6, '2025-04-20 16:18:16'),
(264, 445, 7, '2025-04-20 16:18:16'),
(265, 446, 6, '2025-04-20 16:18:16'),
(266, 446, 7, '2025-04-20 16:18:16'),
(267, 447, 6, '2025-04-20 16:18:16'),
(268, 447, 7, '2025-04-20 16:18:16'),
(269, 448, 6, '2025-04-20 16:18:16'),
(270, 448, 7, '2025-04-20 16:18:16'),
(271, 449, 6, '2025-04-20 16:18:20'),
(272, 449, 7, '2025-04-20 16:18:20'),
(273, 450, 6, '2025-04-20 16:18:20'),
(274, 450, 7, '2025-04-20 16:18:20'),
(275, 451, 6, '2025-04-20 16:18:20'),
(276, 451, 7, '2025-04-20 16:18:20'),
(277, 452, 6, '2025-04-20 16:18:20'),
(278, 452, 7, '2025-04-20 16:18:20'),
(279, 453, 6, '2025-04-20 16:18:24'),
(280, 453, 7, '2025-04-20 16:18:24'),
(281, 454, 6, '2025-04-20 16:18:24'),
(282, 454, 7, '2025-04-20 16:18:24'),
(283, 455, 6, '2025-04-20 16:18:24'),
(284, 455, 7, '2025-04-20 16:18:24'),
(285, 456, 6, '2025-04-20 16:18:24'),
(286, 456, 7, '2025-04-20 16:18:24'),
(287, 457, 6, '2025-04-20 16:18:24'),
(288, 457, 7, '2025-04-20 16:18:24'),
(289, 458, 6, '2025-04-20 16:18:27'),
(290, 458, 7, '2025-04-20 16:18:27'),
(291, 459, 6, '2025-04-20 16:18:27'),
(292, 459, 7, '2025-04-20 16:18:27'),
(293, 460, 6, '2025-04-20 16:18:27'),
(294, 460, 7, '2025-04-20 16:18:27'),
(295, 461, 6, '2025-04-20 16:18:27'),
(296, 461, 7, '2025-04-20 16:18:27'),
(297, 462, 6, '2025-04-20 16:18:31'),
(298, 462, 7, '2025-04-20 16:18:31'),
(299, 463, 6, '2025-04-20 16:18:31'),
(300, 463, 7, '2025-04-20 16:18:31'),
(301, 464, 6, '2025-04-20 16:18:31'),
(302, 464, 7, '2025-04-20 16:18:31'),
(303, 465, 6, '2025-04-20 16:18:31'),
(304, 465, 7, '2025-04-20 16:18:31'),
(305, 466, 6, '2025-04-20 16:18:35'),
(306, 466, 7, '2025-04-20 16:18:35'),
(307, 467, 6, '2025-04-20 16:18:35'),
(308, 467, 7, '2025-04-20 16:18:35'),
(309, 468, 6, '2025-04-20 16:18:35'),
(310, 468, 7, '2025-04-20 16:18:35'),
(311, 469, 6, '2025-04-20 16:18:35'),
(312, 469, 7, '2025-04-20 16:18:35'),
(313, 470, 6, '2025-04-20 16:18:39'),
(314, 470, 7, '2025-04-20 16:18:39'),
(315, 471, 6, '2025-04-20 16:18:39'),
(316, 471, 7, '2025-04-20 16:18:39'),
(317, 472, 6, '2025-04-20 16:18:39'),
(318, 472, 7, '2025-04-20 16:18:39'),
(319, 473, 6, '2025-04-20 16:18:39'),
(320, 473, 7, '2025-04-20 16:18:39'),
(321, 474, 6, '2025-04-20 16:18:46'),
(322, 474, 7, '2025-04-20 16:18:46'),
(323, 475, 6, '2025-04-20 16:18:46'),
(324, 475, 7, '2025-04-20 16:18:46'),
(325, 476, 6, '2025-04-20 16:18:46'),
(326, 476, 7, '2025-04-20 16:18:46'),
(327, 477, 6, '2025-04-20 16:18:46'),
(328, 477, 7, '2025-04-20 16:18:46'),
(329, 478, 6, '2025-04-20 16:18:51'),
(330, 478, 7, '2025-04-20 16:18:51'),
(331, 479, 6, '2025-04-20 16:18:51'),
(332, 479, 7, '2025-04-20 16:18:51'),
(333, 480, 6, '2025-04-20 16:18:51'),
(334, 480, 7, '2025-04-20 16:18:51'),
(335, 481, 6, '2025-04-20 16:18:51'),
(336, 481, 7, '2025-04-20 16:18:51'),
(337, 482, 6, '2025-04-20 16:18:54'),
(338, 482, 7, '2025-04-20 16:18:54'),
(339, 483, 6, '2025-04-20 16:18:54'),
(340, 483, 7, '2025-04-20 16:18:54'),
(341, 484, 6, '2025-04-20 16:18:54'),
(342, 484, 7, '2025-04-20 16:18:54'),
(343, 485, 6, '2025-04-20 16:18:54'),
(344, 485, 7, '2025-04-20 16:18:54'),
(345, 486, 6, '2025-04-20 16:19:00'),
(346, 486, 7, '2025-04-20 16:19:00'),
(347, 487, 6, '2025-04-20 16:19:00'),
(348, 487, 7, '2025-04-20 16:19:00'),
(349, 488, 6, '2025-04-20 16:19:00'),
(350, 488, 7, '2025-04-20 16:19:00'),
(351, 489, 6, '2025-04-20 16:19:00'),
(352, 489, 7, '2025-04-20 16:19:00'),
(353, 490, 6, '2025-04-20 16:19:04'),
(354, 490, 7, '2025-04-20 16:19:04'),
(355, 491, 6, '2025-04-20 16:19:04'),
(356, 491, 7, '2025-04-20 16:19:04'),
(357, 492, 6, '2025-04-20 16:19:04'),
(358, 492, 7, '2025-04-20 16:19:04'),
(359, 493, 6, '2025-04-20 16:19:04'),
(360, 493, 7, '2025-04-20 16:19:04'),
(361, 494, 6, '2025-04-20 16:19:08'),
(362, 494, 7, '2025-04-20 16:19:08'),
(363, 495, 6, '2025-04-20 16:19:08'),
(364, 495, 7, '2025-04-20 16:19:08'),
(365, 496, 6, '2025-04-20 16:19:08'),
(366, 496, 7, '2025-04-20 16:19:08'),
(367, 497, 6, '2025-04-20 16:19:08'),
(368, 497, 7, '2025-04-20 16:19:08'),
(369, 498, 6, '2025-04-20 16:19:13'),
(370, 498, 7, '2025-04-20 16:19:13'),
(371, 499, 6, '2025-04-20 16:19:13'),
(372, 499, 7, '2025-04-20 16:19:13'),
(373, 500, 6, '2025-04-20 16:19:13'),
(374, 500, 7, '2025-04-20 16:19:13'),
(375, 501, 6, '2025-04-20 16:19:13'),
(376, 501, 7, '2025-04-20 16:19:13'),
(377, 502, 6, '2025-04-20 16:19:13'),
(378, 502, 7, '2025-04-20 16:19:13'),
(379, 503, 6, '2025-04-20 16:19:17'),
(380, 503, 7, '2025-04-20 16:19:17'),
(381, 504, 6, '2025-04-20 16:19:17'),
(382, 504, 7, '2025-04-20 16:19:17'),
(383, 505, 6, '2025-04-20 16:19:17'),
(384, 505, 7, '2025-04-20 16:19:17'),
(385, 506, 6, '2025-04-20 16:19:17'),
(386, 506, 7, '2025-04-20 16:19:17'),
(387, 507, 6, '2025-04-20 16:19:20'),
(388, 507, 7, '2025-04-20 16:19:20'),
(389, 508, 6, '2025-04-20 16:19:20'),
(390, 508, 7, '2025-04-20 16:19:20'),
(391, 509, 6, '2025-04-20 16:19:20'),
(392, 509, 7, '2025-04-20 16:19:20'),
(393, 510, 6, '2025-04-20 16:19:20'),
(394, 510, 7, '2025-04-20 16:19:20'),
(395, 511, 7, '2025-04-20 16:19:25'),
(396, 511, 6, '2025-04-20 16:19:25'),
(397, 512, 7, '2025-04-20 16:19:25'),
(398, 512, 6, '2025-04-20 16:19:25'),
(399, 513, 7, '2025-04-20 16:19:25'),
(400, 513, 6, '2025-04-20 16:19:25'),
(401, 514, 7, '2025-04-20 16:19:25'),
(402, 514, 6, '2025-04-20 16:19:25'),
(403, 515, 6, '2025-04-20 16:19:32'),
(404, 515, 7, '2025-04-20 16:19:32'),
(405, 516, 6, '2025-04-20 16:19:36'),
(406, 516, 7, '2025-04-20 16:19:36'),
(407, 517, 6, '2025-04-20 16:19:36'),
(408, 517, 7, '2025-04-20 16:19:36'),
(409, 518, 6, '2025-04-20 16:19:41'),
(410, 518, 7, '2025-04-20 16:19:41'),
(411, 519, 6, '2025-04-20 16:19:41'),
(412, 519, 7, '2025-04-20 16:19:41'),
(413, 520, 6, '2025-04-20 16:19:41'),
(414, 520, 7, '2025-04-20 16:19:41'),
(415, 521, 6, '2025-04-20 16:19:41'),
(416, 521, 7, '2025-04-20 16:19:41'),
(417, 522, 6, '2025-04-20 16:19:45'),
(418, 522, 7, '2025-04-20 16:19:45'),
(419, 523, 6, '2025-04-20 16:19:45'),
(420, 523, 7, '2025-04-20 16:19:45'),
(421, 524, 6, '2025-04-20 16:19:45'),
(422, 524, 7, '2025-04-20 16:19:45'),
(423, 525, 6, '2025-04-20 16:19:49'),
(424, 525, 7, '2025-04-20 16:19:49'),
(425, 526, 6, '2025-04-20 16:19:49'),
(426, 526, 7, '2025-04-20 16:19:49'),
(427, 527, 6, '2025-04-20 16:19:53'),
(428, 527, 7, '2025-04-20 16:19:53'),
(429, 528, 6, '2025-04-20 16:19:53'),
(430, 528, 7, '2025-04-20 16:19:53'),
(431, 529, 6, '2025-04-20 16:19:53'),
(432, 529, 7, '2025-04-20 16:19:53'),
(433, 530, 6, '2025-04-20 16:19:53'),
(434, 530, 7, '2025-04-20 16:19:53'),
(435, 531, 6, '2025-04-20 16:19:57'),
(436, 531, 7, '2025-04-20 16:19:57'),
(437, 532, 6, '2025-04-20 16:19:57'),
(438, 532, 7, '2025-04-20 16:19:57'),
(439, 533, 6, '2025-04-20 16:20:01'),
(440, 533, 7, '2025-04-20 16:20:01'),
(441, 534, 6, '2025-04-20 16:20:01'),
(442, 534, 7, '2025-04-20 16:20:01'),
(443, 535, 6, '2025-04-20 16:20:05'),
(444, 535, 7, '2025-04-20 16:20:05'),
(445, 536, 6, '2025-04-20 16:20:05'),
(446, 536, 7, '2025-04-20 16:20:05'),
(447, 537, 6, '2025-04-20 16:20:09'),
(448, 537, 7, '2025-04-20 16:20:09'),
(449, 538, 6, '2025-04-20 16:20:09'),
(450, 538, 7, '2025-04-20 16:20:09'),
(451, 539, 6, '2025-04-20 16:20:09'),
(452, 539, 7, '2025-04-20 16:20:09'),
(453, 540, 6, '2025-04-20 16:20:09'),
(454, 540, 7, '2025-04-20 16:20:09'),
(455, 541, 6, '2025-04-20 16:20:15'),
(456, 541, 7, '2025-04-20 16:20:15'),
(457, 542, 6, '2025-04-20 16:20:15'),
(458, 542, 7, '2025-04-20 16:20:15'),
(459, 543, 7, '2025-04-20 16:20:19'),
(460, 543, 6, '2025-04-20 16:20:19'),
(461, 544, 7, '2025-04-20 16:20:19'),
(462, 544, 6, '2025-04-20 16:20:19'),
(467, 547, 3, '2025-04-20 16:32:13'),
(468, 548, 3, '2025-04-20 16:32:13'),
(469, 549, 3, '2025-04-20 16:32:17'),
(470, 550, 3, '2025-04-20 16:32:17'),
(471, 551, 3, '2025-04-20 16:32:17'),
(472, 552, 3, '2025-04-20 16:32:25'),
(473, 553, 3, '2025-04-20 16:32:25'),
(474, 554, 3, '2025-04-20 16:32:29'),
(475, 555, 3, '2025-04-20 16:32:29'),
(476, 556, 3, '2025-04-20 16:32:29'),
(477, 557, 3, '2025-04-20 16:32:33'),
(478, 558, 3, '2025-04-20 16:32:33'),
(480, 565, 3, '2025-05-02 17:00:04'),
(484, 569, 3, '2025-05-04 01:23:57'),
(569, 627, 8, '2025-05-07 13:17:52'),
(570, 628, 8, '2025-05-07 13:17:52'),
(571, 629, 8, '2025-05-07 13:17:52'),
(572, 630, 8, '2025-05-07 13:17:52'),
(573, 631, 8, '2025-05-07 13:17:52'),
(574, 632, 8, '2025-05-07 13:17:52'),
(575, 633, 8, '2025-05-07 13:17:52'),
(585, 643, 1, '2025-05-07 13:32:56'),
(586, 644, 1, '2025-05-07 13:32:56'),
(587, 645, 1, '2025-05-07 13:32:56'),
(588, 646, 1, '2025-05-07 13:32:56'),
(589, 647, 1, '2025-05-07 13:32:56'),
(590, 648, 1, '2025-05-07 13:32:56'),
(591, 649, 3, '2025-05-07 14:34:33'),
(592, 650, 3, '2025-05-07 14:34:33'),
(593, 651, 3, '2025-05-07 14:34:33'),
(594, 652, 3, '2025-05-07 14:34:33'),
(604, 662, 2, '2025-05-09 16:19:18'),
(605, 663, 2, '2025-05-09 16:19:18'),
(607, 665, 2, '2025-05-09 16:19:18'),
(608, 666, 2, '2025-05-09 16:19:18'),
(609, 667, 2, '2025-05-09 16:19:18'),
(610, 668, 2, '2025-05-09 16:19:18'),
(611, 669, 2, '2025-05-09 16:19:18'),
(612, 670, 2, '2025-05-09 16:19:18'),
(629, 687, 2, '2025-05-09 16:28:58'),
(630, 688, 2, '2025-05-09 16:28:58'),
(631, 689, 2, '2025-05-09 16:28:58'),
(633, 691, 2, '2025-05-09 16:28:58'),
(634, 692, 2, '2025-05-09 16:28:58'),
(635, 693, 2, '2025-05-09 16:28:58'),
(643, 701, 2, '2025-05-09 16:32:30'),
(644, 702, 2, '2025-05-09 16:32:30'),
(645, 703, 2, '2025-05-09 16:32:30'),
(646, 704, 2, '2025-05-09 16:32:30'),
(647, 705, 2, '2025-05-09 16:32:30'),
(708, 755, 1, '2025-05-12 16:27:04'),
(709, 756, 1, '2025-05-12 16:27:04'),
(710, 757, 1, '2025-05-12 16:27:04'),
(711, 758, 1, '2025-05-12 16:27:04'),
(712, 759, 1, '2025-05-12 16:27:04'),
(713, 760, 1, '2025-05-12 16:27:04'),
(714, 761, 1, '2025-05-12 16:27:04'),
(715, 762, 1, '2025-05-12 16:27:04'),
(716, 763, 1, '2025-05-12 16:27:04'),
(717, 764, 1, '2025-05-12 16:27:04'),
(718, 765, 1, '2025-05-12 16:27:04'),
(719, 766, 1, '2025-05-12 16:27:04'),
(720, 767, 1, '2025-05-12 16:27:04'),
(722, 785, 1, '2025-05-12 16:53:43'),
(723, 786, 1, '2025-05-12 16:53:43'),
(724, 787, 1, '2025-05-12 16:53:43'),
(725, 788, 1, '2025-05-12 16:53:43'),
(726, 789, 1, '2025-05-12 16:53:43'),
(727, 790, 1, '2025-05-12 16:53:43'),
(744, 814, 1, '2025-05-14 15:25:10'),
(745, 815, 1, '2025-05-14 15:25:10'),
(746, 816, 1, '2025-05-14 15:25:10'),
(747, 817, 1, '2025-05-14 15:25:10'),
(748, 818, 1, '2025-05-14 15:25:10'),
(749, 819, 1, '2025-05-14 15:25:10'),
(750, 820, 1, '2025-05-14 15:25:10'),
(751, 821, 1, '2025-05-14 15:25:10'),
(752, 822, 1, '2025-05-14 15:26:27'),
(753, 823, 1, '2025-05-14 15:26:27'),
(754, 824, 1, '2025-05-14 15:26:27'),
(755, 825, 1, '2025-05-14 15:26:27'),
(756, 826, 1, '2025-05-14 15:26:27'),
(757, 827, 1, '2025-05-14 15:26:27'),
(758, 828, 1, '2025-05-14 15:26:27'),
(759, 829, 1, '2025-05-14 15:26:27'),
(776, 846, 2, '2025-05-14 15:51:51'),
(777, 847, 2, '2025-05-14 15:51:51'),
(778, 848, 2, '2025-05-14 15:52:55'),
(779, 849, 2, '2025-05-14 15:52:55'),
(784, 850, 2, '2025-05-14 15:55:30'),
(785, 851, 2, '2025-05-14 15:55:30'),
(786, 852, 2, '2025-05-14 15:55:30'),
(787, 853, 2, '2025-05-14 15:55:30'),
(788, 854, 1, '2025-05-14 15:57:18'),
(789, 854, 2, '2025-05-14 15:57:18'),
(790, 855, 1, '2025-05-14 15:57:18'),
(791, 855, 2, '2025-05-14 15:57:18'),
(792, 856, 1, '2025-05-14 15:57:18'),
(793, 856, 2, '2025-05-14 15:57:18'),
(794, 857, 1, '2025-05-14 15:57:18'),
(795, 857, 2, '2025-05-14 15:57:18'),
(796, 858, 1, '2025-05-14 15:59:11'),
(797, 859, 1, '2025-05-14 15:59:11'),
(798, 860, 1, '2025-05-14 15:59:11'),
(799, 861, 1, '2025-05-14 15:59:11'),
(800, 862, 1, '2025-05-14 15:59:11'),
(801, 863, 1, '2025-05-14 16:00:47'),
(802, 864, 1, '2025-05-14 16:00:47'),
(803, 865, 1, '2025-05-14 16:00:47'),
(804, 866, 1, '2025-05-14 16:00:47'),
(805, 867, 2, '2025-05-14 16:02:49'),
(806, 868, 2, '2025-05-14 16:02:49'),
(807, 869, 2, '2025-05-14 16:02:49'),
(808, 870, 2, '2025-05-14 16:02:49'),
(809, 871, 2, '2025-05-14 16:02:49'),
(810, 872, 2, '2025-05-14 16:02:49'),
(811, 873, 2, '2025-05-14 16:04:53'),
(812, 874, 2, '2025-05-14 16:04:53'),
(813, 875, 2, '2025-05-14 16:04:53'),
(814, 876, 2, '2025-05-14 16:04:53'),
(815, 877, 2, '2025-05-14 16:04:53'),
(816, 878, 2, '2025-05-14 16:04:53'),
(817, 879, 2, '2025-05-14 16:04:53'),
(818, 880, 2, '2025-05-14 16:04:53'),
(819, 881, 2, '2025-05-14 16:06:24'),
(820, 882, 2, '2025-05-14 16:06:24'),
(821, 883, 2, '2025-05-14 16:06:24'),
(822, 884, 2, '2025-05-14 16:06:24'),
(846, 898, 1, '2025-05-14 16:19:52'),
(847, 899, 1, '2025-05-14 16:19:52'),
(848, 900, 1, '2025-05-14 16:19:52'),
(849, 901, 1, '2025-05-14 16:19:52'),
(850, 902, 1, '2025-05-14 16:19:52'),
(851, 903, 1, '2025-05-14 16:21:15'),
(852, 904, 1, '2025-05-14 16:21:15'),
(853, 905, 1, '2025-05-14 16:21:15'),
(854, 906, 1, '2025-05-14 16:21:15'),
(855, 907, 1, '2025-05-14 16:21:15'),
(856, 908, 1, '2025-05-14 16:26:04'),
(857, 909, 1, '2025-05-14 16:26:04'),
(858, 910, 1, '2025-05-14 16:26:04'),
(859, 911, 1, '2025-05-14 16:26:04'),
(860, 912, 1, '2025-05-14 16:28:02'),
(861, 913, 1, '2025-05-14 16:28:02'),
(862, 914, 1, '2025-05-14 16:28:02'),
(863, 915, 1, '2025-05-14 16:28:02'),
(864, 916, 1, '2025-05-14 16:29:26'),
(865, 917, 1, '2025-05-14 16:29:26'),
(866, 918, 1, '2025-05-14 16:29:26'),
(867, 919, 1, '2025-05-14 16:29:26'),
(868, 920, 2, '2025-05-14 16:30:31'),
(869, 921, 2, '2025-05-14 16:30:31'),
(870, 922, 2, '2025-05-14 16:30:31'),
(871, 923, 2, '2025-05-14 16:30:31'),
(872, 924, 2, '2025-05-14 16:30:31'),
(873, 930, 1, '2025-05-14 16:31:32'),
(874, 931, 1, '2025-05-14 16:31:32'),
(875, 932, 1, '2025-05-14 16:31:32'),
(876, 933, 1, '2025-05-14 16:31:32'),
(877, 934, 1, '2025-05-14 16:31:32'),
(950, 959, 2, '2025-05-14 16:54:21'),
(951, 960, 2, '2025-05-14 16:54:21'),
(952, 961, 2, '2025-05-14 16:54:21'),
(953, 962, 2, '2025-05-14 16:54:21'),
(954, 963, 2, '2025-05-14 16:54:21'),
(955, 964, 2, '2025-05-14 16:54:51'),
(956, 965, 2, '2025-05-14 16:54:51'),
(957, 966, 2, '2025-05-14 16:54:51'),
(958, 967, 2, '2025-05-14 16:54:51'),
(959, 968, 2, '2025-05-14 16:54:51'),
(960, 969, 2, '2025-05-14 16:55:52'),
(961, 970, 2, '2025-05-14 16:55:52'),
(962, 971, 2, '2025-05-14 16:55:52'),
(963, 972, 2, '2025-05-14 16:55:52'),
(964, 973, 2, '2025-05-14 16:55:52'),
(965, 974, 2, '2025-05-14 16:55:52'),
(966, 975, 2, '2025-05-14 16:55:52'),
(967, 976, 2, '2025-05-14 16:55:52'),
(968, 977, 2, '2025-05-14 16:55:52'),
(969, 978, 2, '2025-05-14 16:55:52'),
(970, 979, 2, '2025-05-14 16:58:47'),
(971, 980, 2, '2025-05-14 16:58:47'),
(972, 981, 2, '2025-05-14 16:58:47'),
(973, 982, 2, '2025-05-14 16:58:47'),
(974, 983, 2, '2025-05-14 16:58:47'),
(975, 984, 2, '2025-05-14 16:58:47'),
(976, 985, 2, '2025-05-14 16:58:47'),
(977, 986, 2, '2025-05-14 16:58:47'),
(978, 987, 2, '2025-05-14 16:58:47'),
(979, 988, 2, '2025-05-14 16:58:47'),
(980, 989, 2, '2025-05-14 16:58:47'),
(981, 990, 2, '2025-05-14 16:59:51'),
(982, 991, 2, '2025-05-14 16:59:51'),
(983, 992, 2, '2025-05-14 16:59:51'),
(984, 993, 2, '2025-05-14 16:59:51'),
(985, 994, 2, '2025-05-14 16:59:51'),
(986, 995, 2, '2025-05-14 16:59:51'),
(987, 996, 2, '2025-05-14 16:59:51'),
(988, 997, 2, '2025-05-14 16:59:51'),
(989, 998, 2, '2025-05-14 16:59:51'),
(990, 999, 1, '2025-05-14 17:01:46'),
(991, 1000, 1, '2025-05-14 17:01:46'),
(992, 1001, 1, '2025-05-14 17:01:46'),
(993, 1002, 1, '2025-05-14 17:01:46'),
(994, 1003, 1, '2025-05-14 17:01:46'),
(995, 1004, 1, '2025-05-14 17:03:28'),
(996, 1005, 1, '2025-05-14 17:03:28'),
(997, 1006, 1, '2025-05-14 17:03:28'),
(998, 1007, 1, '2025-05-14 17:03:28'),
(999, 1008, 1, '2025-05-14 17:03:28'),
(1000, 1009, 1, '2025-05-20 07:17:56'),
(1001, 1010, 1, '2025-05-20 07:17:56'),
(1002, 1011, 1, '2025-05-20 07:17:56'),
(1003, 1012, 1, '2025-05-20 07:17:56'),
(1004, 1013, 1, '2025-05-20 07:17:56'),
(1017, 1026, 1, '2025-05-20 07:23:11'),
(1018, 1027, 1, '2025-05-20 07:23:11'),
(1019, 1028, 1, '2025-05-20 07:23:11'),
(1020, 1029, 1, '2025-05-20 07:23:11'),
(1025, 1034, 2, '2025-05-20 07:31:06'),
(1026, 1034, 1, '2025-05-20 07:31:06'),
(1027, 1035, 2, '2025-05-20 07:31:06'),
(1028, 1035, 1, '2025-05-20 07:31:06'),
(1029, 1036, 2, '2025-05-20 07:31:06'),
(1030, 1036, 1, '2025-05-20 07:31:06'),
(1031, 1037, 2, '2025-05-20 07:31:06'),
(1032, 1037, 1, '2025-05-20 07:31:06'),
(1033, 1038, 1, '2025-05-26 15:49:41'),
(1034, 1039, 1, '2025-05-26 15:49:41'),
(1035, 1040, 1, '2025-05-26 15:49:41'),
(1036, 1041, 1, '2025-05-26 15:49:41'),
(1037, 1042, 1, '2025-05-26 15:49:41'),
(1038, 1043, 1, '2025-05-28 03:25:22'),
(1039, 1044, 1, '2025-05-28 03:25:22'),
(1040, 1045, 1, '2025-05-28 03:25:22'),
(1041, 1046, 1, '2025-05-28 03:25:22'),
(1042, 1047, 1, '2025-05-28 03:25:22'),
(1044, 1048, 1, '2025-05-31 23:37:07'),
(1046, 1049, 1, '2025-05-31 23:37:07'),
(1048, 1050, 1, '2025-05-31 23:37:07'),
(1050, 1051, 1, '2025-05-31 23:37:07'),
(1052, 1052, 1, '2025-05-31 23:37:07'),
(1054, 1053, 1, '2025-05-31 23:37:07'),
(1056, 1054, 1, '2025-05-31 23:37:07'),
(1058, 1055, 1, '2025-05-31 23:37:07'),
(1060, 1056, 1, '2025-05-31 23:37:07'),
(1220, 1223, 1, '2025-06-01 05:37:28'),
(1221, 1224, 1, '2025-06-01 05:37:28'),
(1222, 1225, 1, '2025-06-01 05:37:28'),
(1223, 1226, 1, '2025-06-01 05:37:28'),
(1224, 1227, 1, '2025-06-01 05:37:28'),
(1225, 1228, 1, '2025-06-01 05:37:28'),
(1226, 1229, 1, '2025-06-01 05:37:28'),
(1227, 1230, 1, '2025-06-01 05:37:28'),
(1228, 1231, 1, '2025-06-01 05:37:28'),
(1229, 1232, 1, '2025-06-01 05:37:28'),
(1230, 1233, 1, '2025-06-01 05:37:28'),
(1231, 1234, 1, '2025-06-01 05:37:28'),
(1232, 1235, 1, '2025-06-01 05:48:52'),
(1233, 1236, 1, '2025-06-01 05:48:52'),
(1234, 1237, 1, '2025-06-01 05:48:52'),
(1235, 1238, 1, '2025-06-01 05:48:52');

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_user_collections`
--

CREATE TABLE `wallpaper_user_collections` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联wx_users.openid',
  `group_id` int(10) UNSIGNED NOT NULL COMMENT '关联image_groups.id',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- 转存表中的数据 `wallpaper_user_collections`
--

INSERT INTO `wallpaper_user_collections` (`id`, `user_id`, `group_id`, `created_at`) VALUES
(1, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 34, '2025-03-02 21:23:52'),
(2, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 35, '2025-03-03 00:32:52'),
(3, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 36, '2025-03-03 01:07:03'),
(4, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 36, '2025-03-03 01:07:26'),
(5, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 29, '2025-03-03 01:12:59'),
(6, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 36, '2025-03-03 03:26:01'),
(7, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 38, '2025-03-04 10:23:11'),
(8, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 40, '2025-03-12 10:09:41'),
(9, 'o8dGl5W645M9or3gLufSJDKKOKMY', 39, '2025-03-18 10:01:03'),
(10, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 39, '2025-04-06 16:40:31'),
(11, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 101, '2025-04-06 23:31:33'),
(13, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 104, '2025-04-11 00:35:22'),
(14, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 40, '2025-04-14 22:21:48'),
(15, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 103, '2025-04-14 22:21:59'),
(16, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 396, '2025-04-25 00:34:22');

-- --------------------------------------------------------

--
-- 表的结构 `wallpaper_user_favorites`
--

CREATE TABLE `wallpaper_user_favorites` (
  `id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL COMMENT '用户唯一标识',
  `image_id` int(11) NOT NULL COMMENT '图片ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1-收藏中，0-已取消'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户收藏表';

--
-- 转存表中的数据 `wallpaper_user_favorites`
--

INSERT INTO `wallpaper_user_favorites` (`id`, `user_id`, `image_id`, `create_time`, `status`) VALUES
(1, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 555, '2025-04-25 01:02:34', 1),
(2, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 560, '2025-04-25 00:52:43', 1),
(3, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 561, '2025-04-25 00:52:45', 1),
(4, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 497, '2025-04-25 00:53:49', 1),
(5, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 524, '2025-04-25 00:54:17', 1),
(6, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 482, '2025-04-25 00:54:44', 1),
(7, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 376, '2025-04-25 00:55:42', 1),
(8, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 318, '2025-04-25 00:56:10', 1),
(9, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 485, '2025-04-25 00:56:17', 1),
(10, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 457, '2025-04-25 00:56:26', 1),
(11, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 493, '2025-04-25 00:57:45', 1),
(12, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 390, '2025-04-25 00:58:03', 1),
(13, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 549, '2025-04-25 00:59:21', 0),
(14, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 554, '2025-04-25 01:02:37', 1),
(15, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 550, '2025-04-25 01:02:38', 1),
(16, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 361, '2025-04-25 01:08:48', 1),
(17, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 469, '2025-04-25 01:25:16', 1),
(18, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 356, '2025-04-25 01:25:16', 1),
(19, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 475, '2025-04-25 01:25:28', 1),
(20, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 378, '2025-04-25 01:25:28', 1),
(21, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 378, '2025-04-25 01:25:40', 1),
(22, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 504, '2025-04-25 01:25:40', 1),
(23, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 338, '2025-04-25 01:25:52', 1),
(24, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 501, '2025-04-25 01:25:52', 1),
(25, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 457, '2025-04-25 01:26:04', 1),
(26, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 540, '2025-04-25 01:26:04', 0),
(27, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 525, '2025-04-25 01:26:16', 1),
(28, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 440, '2025-04-25 01:26:16', 1),
(29, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 408, '2025-04-25 01:26:27', 1),
(30, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 379, '2025-04-25 01:26:28', 1),
(31, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 554, '2025-04-25 01:26:39', 1),
(32, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 346, '2025-04-25 01:26:40', 1),
(33, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 488, '2025-04-25 01:26:51', 1),
(34, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 386, '2025-04-25 01:26:52', 0),
(35, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 556, '2025-04-25 01:27:41', 1),
(36, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 556, '2025-04-25 01:27:42', 0),
(37, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 368, '2025-04-25 18:49:12', 1),
(38, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 425, '2025-04-25 18:49:14', 1),
(39, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 394, '2025-04-25 18:53:25', 1),
(40, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 553, '2025-04-25 21:14:51', 1),
(41, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 534, '2025-04-25 23:47:41', 0),
(42, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 536, '2025-04-26 00:05:37', 1),
(43, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 318, '2025-04-26 00:05:47', 1),
(44, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 328, '2025-04-26 00:05:49', 1),
(45, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 465, '2025-04-26 00:05:50', 1),
(46, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 338, '2025-04-26 00:05:56', 1),
(47, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 417, '2025-04-26 00:06:01', 1),
(48, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 384, '2025-04-26 00:06:02', 1),
(49, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 339, '2025-04-26 00:06:05', 1),
(50, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 494, '2025-04-26 00:06:13', 1),
(51, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 474, '2025-04-26 00:06:13', 1),
(52, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 458, '2025-04-26 00:06:14', 1),
(53, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 464, '2025-04-26 00:06:24', 1),
(54, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 395, '2025-04-26 00:06:25', 1),
(55, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 371, '2025-04-26 00:06:25', 1),
(56, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 470, '2025-04-26 00:06:33', 0),
(57, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 394, '2025-04-26 00:06:37', 1),
(58, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 487, '2025-04-26 00:06:37', 1),
(59, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 503, '2025-04-26 00:06:42', 0),
(60, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 396, '2025-04-26 00:06:49', 1),
(61, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 556, '2025-04-26 00:06:49', 1),
(62, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 534, '2025-04-26 00:06:51', 1),
(63, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 553, '2025-04-26 00:07:01', 1),
(64, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 416, '2025-04-26 00:07:01', 1),
(65, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 353, '2025-04-26 00:07:13', 1),
(66, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 437, '2025-04-26 00:07:13', 0),
(67, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 488, '2025-04-26 00:07:25', 1),
(68, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 445, '2025-04-26 00:07:25', 1),
(69, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 554, '2025-04-26 00:07:30', 1),
(70, 'o8dGl5QWiersXzxUPSGCJZ8Xt7wc', 554, '2025-04-26 00:08:14', 1),
(72, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 567, '2025-05-03 01:05:01', 1),
(73, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 362, '2025-05-03 02:04:13', 1),
(74, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 498, '2025-05-03 02:08:21', 1),
(75, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 340, '2025-05-03 02:08:30', 1),
(76, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 502, '2025-05-03 02:08:32', 1),
(77, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 352, '2025-05-03 02:08:39', 1),
(78, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 318, '2025-05-03 02:08:44', 1),
(79, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 395, '2025-05-03 02:08:49', 1),
(80, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 432, '2025-05-03 02:08:56', 1),
(81, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 410, '2025-05-03 02:08:58', 1),
(82, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 411, '2025-05-03 02:09:07', 1),
(83, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 490, '2025-05-03 02:09:08', 1),
(84, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 426, '2025-05-03 02:09:16', 1),
(85, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 358, '2025-05-03 02:09:20', 0),
(86, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 447, '2025-05-03 02:09:25', 1),
(87, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 434, '2025-05-03 02:09:32', 0),
(88, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 513, '2025-05-03 02:09:35', 1),
(89, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 367, '2025-05-03 02:09:43', 1),
(90, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 408, '2025-05-03 02:09:55', 1),
(91, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 399, '2025-05-03 02:10:07', 1),
(92, 'o8dGl5e8HV1_sLrAHPY25HXlMaRw', 556, '2025-05-03 02:10:14', 1),
(93, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 554, '2025-05-07 22:22:38', 1),
(94, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 526, '2025-05-03 22:00:44', 1),
(95, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 546, '2025-05-03 22:00:46', 1),
(96, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 420, '2025-05-03 22:00:56', 1),
(97, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 459, '2025-05-03 22:00:58', 1),
(98, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 362, '2025-05-03 22:01:08', 1),
(99, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 408, '2025-05-03 22:01:10', 1),
(100, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 553, '2025-05-03 22:01:20', 1),
(101, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 350, '2025-05-03 22:01:21', 1),
(102, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 385, '2025-05-03 22:01:32', 0),
(103, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 532, '2025-05-03 22:01:33', 1),
(104, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 373, '2025-05-03 22:01:45', 1),
(105, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 559, '2025-05-03 22:01:56', 1),
(106, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 552, '2025-05-03 22:01:57', 1),
(107, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 473, '2025-05-03 22:02:08', 0),
(108, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 340, '2025-05-03 22:02:09', 1),
(109, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 487, '2025-05-03 22:02:20', 0),
(110, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 385, '2025-05-03 22:02:21', 1),
(111, 'o8dGl5SKnGvGaNud_7aPEVTP85Og', 555, '2025-05-03 22:03:11', 1),
(112, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 315, '2025-05-03 22:16:19', 1),
(113, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 335, '2025-05-03 22:16:28', 1),
(114, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 344, '2025-05-03 22:16:38', 1),
(115, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 425, '2025-05-03 22:16:43', 1),
(116, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 358, '2025-05-03 22:16:47', 1),
(117, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 457, '2025-05-03 22:16:55', 1),
(118, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 364, '2025-05-03 22:16:56', 1),
(119, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 376, '2025-05-03 22:17:05', 1),
(120, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 335, '2025-05-03 22:17:07', 1),
(121, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 462, '2025-05-03 22:17:15', 1),
(122, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 561, '2025-05-03 22:17:19', 1),
(123, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 468, '2025-05-03 22:17:24', 1),
(124, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 546, '2025-05-03 22:17:31', 1),
(125, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 505, '2025-05-03 22:17:33', 1),
(126, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 474, '2025-05-03 22:17:42', 1),
(127, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 522, '2025-05-03 22:17:54', 1),
(128, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 514, '2025-05-28 05:32:52', 1),
(129, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 554, '2025-05-03 22:18:21', 1),
(130, 'o8dGl5W645M9or3gLufSJDKKOKMY', 524, '2025-05-04 07:13:28', 1),
(131, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 422, '2025-05-04 07:13:28', 1),
(133, 'o8dGl5W645M9or3gLufSJDKKOKMY', 550, '2025-05-04 07:13:51', 1),
(134, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 518, '2025-05-04 07:13:51', 1),
(135, 'o8dGl5W645M9or3gLufSJDKKOKMY', 339, '2025-05-04 07:14:03', 1),
(136, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 430, '2025-05-04 07:14:03', 1),
(137, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 549, '2025-05-04 07:14:15', 1),
(138, 'o8dGl5W645M9or3gLufSJDKKOKMY', 431, '2025-05-04 07:14:15', 1),
(139, 'o8dGl5W645M9or3gLufSJDKKOKMY', 345, '2025-05-04 07:14:27', 1),
(140, 'o8dGl5W645M9or3gLufSJDKKOKMY', 474, '2025-05-04 07:14:39', 1),
(141, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 447, '2025-05-04 07:14:51', 1),
(142, 'o8dGl5W645M9or3gLufSJDKKOKMY', 415, '2025-05-04 07:14:51', 1),
(143, 'o8dGl5W645M9or3gLufSJDKKOKMY', 370, '2025-05-04 07:15:03', 1),
(144, 'o8dGl5W645M9or3gLufSJDKKOKMY', 556, '2025-05-04 07:15:53', 1),
(146, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 645, '2025-05-07 21:33:29', 1),
(147, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 557, '2025-05-07 21:46:00', 1),
(148, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 443, '2025-05-07 22:22:14', 1),
(149, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 547, '2025-05-07 22:22:24', 1),
(150, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 520, '2025-05-07 22:22:26', 1),
(151, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 429, '2025-05-07 22:22:26', 1),
(152, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 329, '2025-05-07 22:22:33', 1),
(153, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 367, '2025-05-07 22:22:42', 1),
(154, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 359, '2025-05-07 22:22:50', 1),
(155, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 545, '2025-05-07 22:22:50', 1),
(156, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 394, '2025-05-07 22:22:52', 1),
(157, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 413, '2025-05-07 22:23:01', 1),
(158, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 462, '2025-05-07 22:23:01', 1),
(159, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 514, '2025-05-07 22:23:02', 1),
(160, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 485, '2025-05-07 22:23:10', 1),
(161, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 331, '2025-05-07 22:23:13', 1),
(162, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 320, '2025-05-07 22:23:14', 1),
(163, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 514, '2025-05-07 22:23:19', 1),
(164, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 643, '2025-05-07 22:23:25', 1),
(165, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 522, '2025-05-07 22:23:25', 1),
(166, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 527, '2025-05-07 22:23:29', 1),
(167, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 533, '2025-05-07 22:23:37', 1),
(168, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 359, '2025-05-07 22:23:37', 1),
(169, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 410, '2025-05-07 22:23:49', 1),
(170, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 565, '2025-05-07 22:23:49', 1),
(171, 'o8dGl5QnBSstDWHysSUJliEwJW6U', 486, '2025-05-07 22:24:01', 1),
(172, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 341, '2025-05-07 22:24:01', 1),
(173, 'o8dGl5X4OUnqDoS4achYoqx6ctBY', 629, '2025-05-07 22:24:17', 1),
(174, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 555, '2025-05-07 22:25:06', 0),
(175, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 648, '2025-05-07 22:35:57', 1),
(176, 'o8dGl5S0HQzGIi8QoFAIJKsj1nWE', 709, '2025-05-10 00:48:24', 1),
(177, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 687, '2025-05-12 01:20:48', 1),
(178, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 365, '2025-05-12 01:20:57', 1),
(179, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 407, '2025-05-12 01:20:59', 1),
(180, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 351, '2025-05-12 01:21:02', 0),
(181, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 368, '2025-05-12 01:21:06', 1),
(182, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 327, '2025-05-12 01:21:11', 1),
(183, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 345, '2025-05-12 01:21:14', 1),
(184, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 378, '2025-05-12 01:21:16', 1),
(185, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 531, '2025-05-12 01:21:23', 1),
(186, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 464, '2025-05-12 01:21:25', 1),
(187, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 342, '2025-05-12 01:21:26', 1),
(188, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 465, '2025-05-12 01:21:34', 1),
(189, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 368, '2025-05-12 01:21:35', 1),
(190, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 466, '2025-05-12 01:21:43', 1),
(191, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 396, '2025-05-12 01:21:47', 1),
(192, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 510, '2025-05-12 01:21:50', 1),
(193, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 489, '2025-05-12 01:21:53', 1),
(194, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 555, '2025-05-12 01:21:58', 1),
(195, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 543, '2025-05-12 01:22:02', 1),
(196, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 629, '2025-05-12 01:22:02', 1),
(197, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 439, '2025-05-12 01:22:10', 1),
(198, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 446, '2025-05-12 01:22:14', 1),
(199, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 534, '2025-05-12 01:22:22', 1),
(200, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 469, '2025-05-12 01:22:26', 0),
(201, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 438, '2025-05-12 01:22:34', 1),
(202, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 431, '2025-05-12 01:22:38', 0),
(203, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 629, '2025-05-12 01:22:50', 1),
(204, 'o8dGl5S6oXFyE1T6chv9oN-f9jVs', 569, '2025-05-12 01:23:36', 1),
(205, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 446, '2025-05-13 00:39:51', 1),
(206, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 662, '2025-05-13 00:40:00', 1),
(207, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 382, '2025-05-13 00:40:02', 1),
(209, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 711, '2025-05-13 00:40:09', 1),
(210, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 406, '2025-05-13 00:40:14', 1),
(211, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 360, '2025-05-13 00:40:15', 1),
(212, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 326, '2025-05-13 00:40:19', 1),
(213, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 535, '2025-05-13 00:40:26', 1),
(214, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 427, '2025-05-13 00:40:27', 1),
(215, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 408, '2025-05-13 00:40:28', 1),
(216, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 431, '2025-05-13 00:40:37', 1),
(217, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 518, '2025-05-13 00:40:38', 1),
(218, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 382, '2025-05-13 00:40:39', 1),
(219, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 459, '2025-05-13 00:40:46', 1),
(220, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 317, '2025-05-13 00:40:50', 1),
(221, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 517, '2025-05-13 00:40:56', 1),
(222, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 662, '2025-05-13 00:41:02', 1),
(223, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 531, '2025-05-13 00:41:02', 1),
(224, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 545, '2025-05-13 00:41:05', 1),
(225, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 325, '2025-05-13 00:41:13', 1),
(226, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 482, '2025-05-13 00:41:14', 1),
(227, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 483, '2025-05-13 00:41:25', 1),
(228, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 438, '2025-05-13 00:41:26', 1),
(229, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 353, '2025-05-13 00:41:37', 1),
(230, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 633, '2025-05-13 00:41:53', 1),
(231, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 569, '2025-05-13 00:42:38', 1),
(232, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 1029, '2025-05-20 15:44:13', 1),
(233, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 396, '2025-05-28 05:32:39', 1),
(234, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 828, '2025-05-28 05:32:40', 1),
(235, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 480, '2025-05-28 05:32:51', 1),
(236, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 1042, '2025-05-28 05:33:03', 1),
(237, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 520, '2025-05-28 05:33:04', 1),
(238, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 335, '2025-05-28 05:33:15', 1),
(239, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 814, '2025-05-28 05:33:15', 1),
(240, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 358, '2025-05-28 05:33:27', 1),
(241, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 407, '2025-05-28 05:33:27', 1),
(242, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 917, '2025-05-28 05:33:39', 1),
(243, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 974, '2025-05-28 05:33:39', 1),
(244, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 506, '2025-05-28 05:33:51', 1),
(245, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 932, '2025-05-28 05:33:51', 1),
(246, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 314, '2025-05-28 05:34:02', 1),
(247, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 761, '2025-05-28 05:34:03', 1),
(248, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 974, '2025-05-28 05:34:14', 1),
(249, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 370, '2025-05-28 05:34:15', 1),
(250, 'o8dGl5QIsPDZoPFwoVk4WWif_cmM', 1040, '2025-05-28 05:35:16', 1),
(251, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 1040, '2025-05-28 05:35:22', 1),
(252, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 1233, '2025-06-15 23:31:00', 1),
(253, 'o8dGl5SXx9I_7Q6yxA0ojC0ZjmCg', 1237, '2025-06-15 23:34:07', 1),
(254, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 451, '2025-06-16 00:19:36', 1),
(255, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 1237, '2025-06-16 00:19:45', 1),
(256, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 631, '2025-06-16 00:19:47', 1),
(257, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 971, '2025-06-16 00:19:54', 1),
(258, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 1137, '2025-06-16 00:19:59', 1),
(259, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 1069, '2025-06-16 00:19:59', 1),
(260, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 317, '2025-06-16 00:20:04', 1),
(261, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 1168, '2025-06-16 00:20:11', 1),
(262, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 854, '2025-06-16 00:20:11', 1),
(263, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 395, '2025-06-16 00:20:13', 1),
(264, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 539, '2025-06-16 00:20:22', 1),
(265, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 419, '2025-06-16 00:20:23', 1),
(266, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 355, '2025-06-16 00:20:23', 1),
(267, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 1091, '2025-06-16 00:20:31', 1),
(268, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 708, '2025-06-16 00:20:34', 1),
(269, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 632, '2025-06-16 00:20:35', 1),
(270, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 1125, '2025-06-16 00:20:40', 1),
(271, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 913, '2025-06-16 00:20:46', 1),
(272, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 867, '2025-06-16 00:20:47', 1),
(273, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 1204, '2025-06-16 00:20:50', 1),
(274, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 1234, '2025-06-16 00:20:58', 1),
(275, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 397, '2025-06-16 00:20:59', 1),
(276, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 473, '2025-06-16 00:21:10', 1),
(277, 'o8dGl5QEvAFZZ1jnjPzZx46GuN6I', 541, '2025-06-16 00:21:10', 1),
(278, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 351, '2025-06-16 00:21:22', 1),
(279, 'o8dGl5X_kQ3ZSXQtS-uk57uTZVpE', 1221, '2025-06-16 00:21:37', 1),
(280, 'o8dGl5cvJ6UdoYREKqk4xM2CCyq0', 1221, '2025-06-16 00:22:24', 1),
(281, 'oHRgK4272YSN07WDoYjVlNC48PLs', 652, '2025-06-20 01:45:48', 1),
(282, 'oHRgK4272YSN07WDoYjVlNC48PLs', 329, '2025-06-20 01:46:00', 1),
(283, 'oHRgK4272YSN07WDoYjVlNC48PLs', 348, '2025-06-20 01:46:12', 1),
(284, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1131, '2025-06-20 01:46:23', 1),
(285, 'oHRgK4272YSN07WDoYjVlNC48PLs', 516, '2025-06-20 01:46:35', 1),
(286, 'oHRgK4272YSN07WDoYjVlNC48PLs', 316, '2025-06-20 01:46:47', 1),
(287, 'oHRgK4272YSN07WDoYjVlNC48PLs', 530, '2025-06-20 01:46:59', 1),
(288, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1052, '2025-06-20 01:47:10', 1),
(289, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1024, '2025-06-20 01:47:22', 1),
(290, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1231, '2025-06-20 01:48:23', 1),
(291, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 471, '2025-06-30 00:18:53', 1),
(292, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 1009, '2025-06-30 00:19:02', 1),
(293, 'oHRgK4272YSN07WDoYjVlNC48PLs', 511, '2025-06-30 00:19:05', 1),
(294, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 869, '2025-06-30 00:19:05', 1),
(295, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 1055, '2025-06-30 00:19:11', 1),
(296, 'oHRgK4272YSN07WDoYjVlNC48PLs', 902, '2025-06-30 00:19:16', 1),
(297, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1133, '2025-06-30 00:19:17', 1),
(298, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 971, '2025-06-30 00:19:20', 1),
(299, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1083, '2025-06-30 00:19:28', 1),
(300, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1038, '2025-06-30 00:19:28', 1),
(301, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 449, '2025-06-30 00:19:29', 1),
(302, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 518, '2025-06-30 00:19:38', 1),
(303, 'oHRgK4272YSN07WDoYjVlNC48PLs', 416, '2025-06-30 00:19:40', 1),
(304, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 466, '2025-06-30 00:19:40', 1),
(305, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 521, '2025-06-30 00:19:48', 1),
(306, 'oHRgK4272YSN07WDoYjVlNC48PLs', 907, '2025-06-30 00:19:52', 1),
(307, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1115, '2025-06-30 00:19:52', 1),
(308, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 538, '2025-06-30 00:19:57', 1),
(309, 'oHRgK4272YSN07WDoYjVlNC48PLs', 823, '2025-06-30 00:20:04', 1),
(310, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1187, '2025-06-30 00:20:04', 1),
(311, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 1184, '2025-06-30 00:20:06', 1),
(312, 'oHRgK4272YSN07WDoYjVlNC48PLs', 628, '2025-06-30 00:20:15', 1),
(313, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 901, '2025-06-30 00:20:16', 1),
(314, 'oHRgK4272YSN07WDoYjVlNC48PLs', 766, '2025-06-30 00:20:27', 1),
(315, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 476, '2025-06-30 00:20:28', 1),
(316, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1038, '2025-06-30 00:20:39', 1),
(317, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 864, '2025-06-30 00:20:40', 1),
(318, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', 1216, '2025-06-30 00:21:03', 1),
(319, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1224, '2025-06-30 00:21:53', 1),
(320, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1224, '2025-06-30 00:21:54', 1),
(321, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1105, '2025-06-30 00:43:29', 1),
(322, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1238, '2025-06-30 00:43:30', 1),
(323, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 691, '2025-06-30 00:43:41', 1),
(324, 'oHRgK4272YSN07WDoYjVlNC48PLs', 321, '2025-06-30 00:43:41', 1),
(325, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1183, '2025-06-30 00:43:53', 1),
(326, 'oHRgK4272YSN07WDoYjVlNC48PLs', 351, '2025-06-30 00:43:53', 1),
(327, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1185, '2025-06-30 00:44:05', 1),
(328, 'oHRgK4272YSN07WDoYjVlNC48PLs', 390, '2025-06-30 00:44:05', 1),
(329, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 633, '2025-06-30 00:44:16', 1),
(330, 'oHRgK4272YSN07WDoYjVlNC48PLs', 336, '2025-06-30 00:44:17', 1),
(331, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1050, '2025-06-30 00:44:28', 1),
(332, 'oHRgK4272YSN07WDoYjVlNC48PLs', 314, '2025-06-30 00:44:28', 1),
(333, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 467, '2025-06-30 00:44:40', 1),
(334, 'oHRgK4272YSN07WDoYjVlNC48PLs', 376, '2025-06-30 00:44:40', 1),
(335, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 442, '2025-06-30 00:44:51', 1),
(336, 'oHRgK4272YSN07WDoYjVlNC48PLs', 542, '2025-06-30 00:44:52', 1),
(337, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 382, '2025-06-30 00:45:03', 1),
(338, 'oHRgK4272YSN07WDoYjVlNC48PLs', 866, '2025-06-30 00:45:04', 1),
(339, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1226, '2025-07-01 00:25:48', 1),
(340, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 549, '2025-07-01 00:25:57', 1),
(341, 'oHRgK4272YSN07WDoYjVlNC48PLs', 980, '2025-07-01 00:26:00', 1),
(342, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 758, '2025-07-01 00:26:06', 1),
(343, 'oHRgK4272YSN07WDoYjVlNC48PLs', 849, '2025-07-01 00:26:12', 1),
(344, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 759, '2025-07-01 00:26:15', 1),
(345, 'oHRgK4272YSN07WDoYjVlNC48PLs', 758, '2025-07-01 00:26:24', 1),
(346, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 826, '2025-07-01 00:26:25', 1),
(347, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 336, '2025-07-01 00:26:34', 1),
(348, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 348, '2025-07-01 00:26:43', 1),
(349, 'oHRgK4272YSN07WDoYjVlNC48PLs', 963, '2025-07-01 00:26:48', 1),
(350, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1082, '2025-07-01 00:26:52', 1),
(351, 'oHRgK4272YSN07WDoYjVlNC48PLs', 820, '2025-07-01 00:27:00', 1),
(352, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1092, '2025-07-01 00:27:01', 1),
(353, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1056, '2025-07-01 00:27:12', 1),
(354, 'oHRgK4272YSN07WDoYjVlNC48PLs', 334, '2025-07-01 00:27:24', 1),
(355, 'oHRgK4272YSN07WDoYjVlNC48PLs', 528, '2025-07-01 00:27:36', 1),
(356, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', 1220, '2025-07-01 00:28:01', 1),
(357, 'oHRgK4272YSN07WDoYjVlNC48PLs', 1116, '2025-08-25 00:39:59', 1),
(358, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 1228, '2026-02-01 21:58:58', 1),
(359, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 1237, '2026-03-08 22:49:46', 1),
(360, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 504, '2026-03-09 14:30:07', 1),
(361, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 452, '2026-03-09 16:45:36', 1),
(362, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 439, '2026-03-09 16:45:48', 1),
(363, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 433, '2026-03-09 16:46:00', 1),
(364, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 495, '2026-03-09 16:46:12', 1),
(365, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 447, '2026-03-09 16:46:24', 1),
(366, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 627, '2026-03-09 16:46:36', 1),
(367, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 412, '2026-03-09 16:46:48', 1),
(368, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 516, '2026-03-09 16:47:00', 1),
(369, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 420, '2026-03-09 16:47:11', 1),
(370, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', 540, '2026-03-09 16:47:37', 1),
(371, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', 333, '2026-03-09 18:29:09', 1);

-- --------------------------------------------------------

--
-- 表的结构 `wx_config`
--

CREATE TABLE `wx_config` (
  `covers_reduce` text CHARACTER SET utf8 COMMENT '封面图片压缩'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wx_config`
--

INSERT INTO `wx_config` (`covers_reduce`) VALUES
('?imageMogr2/thumbnail/!50p');

-- --------------------------------------------------------

--
-- 表的结构 `wx_users`
--

CREATE TABLE `wx_users` (
  `id` int(11) NOT NULL,
  `openid` varchar(50) NOT NULL COMMENT '微信唯一标识',
  `unionid` varchar(50) DEFAULT NULL COMMENT '微信开放平台唯一标识',
  `nickname` varchar(100) DEFAULT NULL COMMENT '用户昵称',
  `avatar_url` varchar(10000) DEFAULT NULL COMMENT '用户头像',
  `gender` tinyint(1) DEFAULT '0' COMMENT '性别 0-未知 1-男 2-女',
  `country` varchar(50) DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `session_key` varchar(100) NOT NULL COMMENT '微信会话密钥',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `wx_users`
--

INSERT INTO `wx_users` (`id`, `openid`, `unionid`, `nickname`, `avatar_url`, `gender`, `country`, `province`, `city`, `session_key`, `created_at`, `updated_at`) VALUES
(235, 'oHRgK47faPz0wuOQYzrWHFqNKj5o', NULL, '20001', 'data:image/png;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/4gJASUNDX1BST0ZJTEUAAQEAAAIwAAAAAAIQAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AAAB3AAAAFRtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z3BhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAOAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwADEANgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/bAEMACgcHCAcGCggICAsKCgsOGBAODQ0OHRUWERgjHyUkIh8iISYrNy8mKTQpISIwQTE0OTs+Pj4lLkRJQzxINz0+O//bAEMBCgsLDg0OHBAQHDsoIig7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O//AABEIAIQAhAMBIgACEQEDEQH/xAAcAAACAwEBAQEAAAAAAAAAAAAAAgEDBAUGBwj/xAA2EAABBAEDAgQEAwcFAQAAAAABAAIDEQQFEiExQRMiUXEGMmGBFBWxI0JSU2Kh0TNDosHh8P/EABkBAAMBAQEAAAAAAAAAAAAAAAABAgMEBf/EACIRAAMAAgIBBQEBAAAAAAAAAAABAgMREjEhBCJBUWETMv/aAAwDAQACEQMRAD8A+x+G3+EH7KmTCgkslnPugZsB/wBwKxs0cgNEEK/cifDMQx44XljRyeoaVlfO+CZzXQWL4BaRa6EogfY28/ThZ/Cnb/pybm/wvFrWa+yHP0JE1oBkMW0HqLItD3As/ZwgOPcEG1eHyR218JF9wOP7JgDYHhsrvQRy8hxOS/Fc8X4NH6K2LCm3NqI1fVy6gL28CI+6cTOujGR9k3mon+SMR08lt+QD0ACPBkra4OcO1hbdry7duNehChzavlxPqo5ovgzA1jMVvn3Bx+imPHdK/wASOUPb6VSMljC63lxP1SskijFB23/pa+Wtrsz0k9l4ZBHYkDd7hz3WeXEwwNxkc0VyGnqlmyQ9pY0eY9wFUI8iOMuLXAeoVTLXnZNNfQn4PxH7oQTH/UukGRw4h2sDBXWr5WA5MwaAeQOi1Y2Q7IOx0ZJ7kdE75NeQjin4EZkSbfl/t0QuiGNrlqFjzX0acK+zzLctg+WW/cUn/MB6rlAprtdXFGHJnUGpgck2FdHrNHlcVW47Y3TNErw1vU2OqTiRq2dj83BNh5v6qz82e1t1a42QwinggsPDSBSq3c+oHSlP85Y+dI9NhaqyZzmvcGkdLPWqVmRnbSdrmj3PVecE7TGxpa229/8AK2xZk5j3NkD33QaR0WbxJPZorbWjS7VJmu6Uj8ylf6cKJ8SSTzvmG7vxwqGvZC/90n1ATSl9ITdL4NJc+UcohjjfuD7Bqkomc/kDgpdwDhQ570hb+BGvGayOYuHPYFaJpaIaG3uWFmS1vSitcEgLQepKil52y0/Giv8ABySmncNWyGJsEYYwUP1UtkocptwKiqbKmUhgLQgOpCz8lngwptNSKXpHCDeDfopAMjwOASfYKAFNcoD4NwwoA0D8XGXE06+jfujIEWOA1j4pSR18NYkKeP4Vy/C/FdA1/wC1a519QK6L0ELMJrAYYiwnsB1+5XmBfULQ3OyGDyvIPS1Nw66Ki0uz1xhjliLHsBB7BcZmkTeI+mgNB43HquYM7J/nOTDUMr+c5ZziqemW8kvtHYGBkkEU1tep6rnyOdG9zHCnA0VSNQyj1lKQyOe7c51k96pVMtdkVS+DQyz6LZDIQ76Wuc1x9Va17vVU1sSejrNmHdMMgbqrouY2R3qnEriOqz4Fczol4cb4QsLchzRSEuDH/Q4NIpPaLXSYCUppTSmkDIpRS4ebq8gyn+E/9kzgV3+qzs1vPmZvgwppGj94NJC5n6hctJbOqfStztvR6SlfBjGZw60uJpusnKf4csD2OHUkdV126kYx5BVd1N+oTn29jXp3Ne425GFtjtgArssIbt4q07NRdL87rv1USPG/gjos8WVp6Y8mPa8AArAs249zSYSuugF2Kkjl4s1BWt6Khm76K5pTEWBWNVQTtKQDoQhIZzKUUn2qKWhBVJIyJtvcGhcvUNWaI3RQgguFbj2XJ13UnjVJGNPliGwc9+//AN9FzIMwkU82SebXBmz3tqej0cGCNKq6Nr4Zi0NgYZZH9GtFrXiv1rDmEOWzax48vII/suc/U8nT2tnxnhpJ2kloP6+y9Fp2XHr+meemZEfDq7HsR9As8OOaX6aZclQ/wq3uYaPXupGQOlrPl4uVjGnbXX0ormQZks+Z4DBu4JJHZJy96+Rdzv5O9HKA7qtEctrBiwSuPLSunFhu6kV7raMTfkwrIkO3c88LTFFt5PJURQhhu1cAuqZ0ctVsYJ2pQnCokYJwbSJ2JAMhSEJDMdJJCI2Oe7o0ElXUubr834fRshwPLxsH34/S1dPS2KVtpHgMqYzZL5D1c4uP3VbCN4SODi5OyNxIXkU9s9mVo6+PiwZsXhT/ACnrX6+6s0jBzNJz3SiWMwi2n+se3ZZIcnwG+Y19VA1Z8sohia9xcaAA5JUw7X+SqUNe436hqEsmSGRlz5pDQY0WSu5omkN07HMj2j8RN5pD6f0KdD0NunsM84D8qTq7rtHoV16Xo4cXH3Ps83Pn5+2ekVhqkhNSK5XScpACYBFpgEgAJ2qAEwSGSEwUAJwkBKFB4QkPZUvKfE2YMmZmJGbZEbefV3/i1arrll0GI7yjgyDv7LgUSdxPVcnqM61xk7vTene+VGR7IYm7nLFJnssiNp9wujNGx58xA91GnaDLrOUWwtEcDD55SOPt6lcuOeaOvLShbZzMbHytSyWwQMdI93QBe/0H4ci0mLxJNsuS7q+uG/Qrfpej4mkweHjR0T8z3cud7rdS9PHiUnl5czvx8FdoIT0ilqYFdIpPSNqAFATBqmkwCBkUpDVICYBTsCAEwCkBMAkAtoT2hAz4HD8R58LgXSCRvo8LvYutRZsG5g2vHzMvovDh9LXgzOhna9p78j1C46xKjtjNUvye40zT8rW89sDbbEOZHfwhfR8XEhw8dmPAwMjYKAWD4axcWDRoJMY7hM0Pc+uXE/4XXpdOLGoRzZsruhaUEKylFLUxK6RSs2opAFdI2qy0WgBA1MAmAU2kMWlICmkwKQEAJgEUmAQUFITAcISA/MDStcHUIQspNqPtvwQSfhPCvsHD/kV6BCFuYPsmkIQgRCEIQAIpCEASAmpCEhgpCEIAkJgEISGMhCEhn//Z', NULL, NULL, NULL, NULL, 'yTBfFEh82KcrmfKTaVgLVA==', '2025-05-25 14:05:14', '2026-03-10 22:50:25'),
(236, 'oHRgK4zcQIge8avJpyWgUH7WrzN4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '+gtLAVmuJmHuq2FeSuza1Q==', '2025-05-29 00:49:43', '2025-05-29 00:49:43'),
(237, 'oHRgK4272YSN07WDoYjVlNC48PLs', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'e0R491tRGTp2mGk7nFVstg==', '2025-05-29 00:49:43', '2026-03-09 16:44:08'),
(238, 'oHRgK46Wt0AkPhkEe_zItyN5N6Ds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FA5i4zLfEE5GwSSwuK5Qiw==', '2025-05-29 00:49:44', '2025-05-29 00:49:44'),
(239, 'oHRgK480X1vnGkm5Qm3x_AunHGuo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'pBysUnzLe8Alee461sceBA==', '2025-05-29 14:33:31', '2025-05-29 14:42:33'),
(240, 'oHRgK40umFQ37zyepCht0DZmOxEk', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'O7XP4t376NowstrFIUGs2Q==', '2025-05-29 19:15:46', '2025-06-06 23:18:40'),
(241, 'oHRgK43KNvCcPiVD_ClRWchChkQw', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1YazIFMUEd6sIPTj7Nx3pg==', '2025-05-29 23:17:33', '2025-05-30 00:01:38'),
(242, 'oHRgK47eVVrAzBg6fGaeNvS3_lzE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'cHziE/fPhEs/AoZtQOLSig==', '2025-05-29 23:52:58', '2026-03-09 16:44:08'),
(243, 'oHRgK49kW3cVoMSbFJjRPChqK-Sg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vqxchTilv1nuVHx4Ryow1w==', '2025-05-29 23:52:59', '2025-05-29 23:52:59'),
(244, 'oHRgK4_wPO-9lxP0Zjpxb7ISsbyg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'pGt7/c77C+iQ5X0tm76+EQ==', '2025-05-30 07:11:12', '2025-05-30 07:11:12'),
(245, 'oHRgK4_p8PfofkcwuQ6qXo5OCqgw', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'e6H9AD3MM494X6DwlhrGZA==', '2025-05-30 14:49:03', '2025-05-30 14:49:03'),
(246, 'oHRgK43kuaZef4J5w77VMGJzjTJo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5EjhXRO9sYCVYIsUqHTmxQ==', '2025-06-06 10:52:02', '2025-06-06 10:52:02'),
(247, 'oHRgK47z5xtWi7g1g0ObPwG0k02M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S7VLaMEkSXZdlqRh4xx4Vg==', '2025-06-06 10:54:16', '2025-06-06 11:04:25'),
(248, 'oHRgK469Ljx2JGUkPameapLjSlNs', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FKzB8+bOxX6EihDgTaPwWw==', '2025-06-06 18:04:40', '2025-06-06 18:05:52'),
(249, 'oHRgK4wm1GeubIJcs5nmlBE1aoyY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SYtm6b+ijh8Ee5kMAtn0Lg==', '2025-06-06 18:21:10', '2025-06-06 18:21:10'),
(250, 'oHRgK41y3aSVNAL7jVd2PUphYEwg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'HYmQPGSr8NfwFVTrYOMkJw==', '2025-06-06 21:24:51', '2025-06-06 21:24:51'),
(251, 'oHRgK42DE3_iW5X_j9nYsOHZZ6x8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NkCJB/TGKKxN/rBgtHthTw==', '2025-06-06 23:20:30', '2025-06-06 23:20:30'),
(252, 'oHRgK49fRIRM826-2gTYSav2yDRs', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N32EMlTH4g2XuZUqgenFsQ==', '2025-06-06 23:20:30', '2025-06-06 23:20:30'),
(253, 'oHRgK44JT696R84WKQVrSFFFQwL4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TpUpfbgraFv4nDW5YE+82A==', '2025-06-07 11:50:38', '2025-06-07 11:50:38'),
(254, 'oHRgK44CGCAQWplcWiKDSGbBVFdg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '8S4eNDMBj6vkiSFLcVWfuQ==', '2025-06-07 17:05:00', '2025-06-07 17:15:08'),
(255, 'oHRgK42uX_BwfTqw5xcRXARrKm_M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'V6uj1AWieZogUAYesuYLbQ==', '2025-06-07 18:08:01', '2025-06-07 18:08:01'),
(256, 'oHRgK43Z1fo_mErVP6yoMcJ7dyr0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dMWiBg/+6sMVPhs+S1/wwg==', '2025-06-07 22:11:46', '2025-06-07 22:11:46'),
(257, 'oHRgK4zrjhP8O3318WRSuhERLc40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'fcfrxFJhVxyxbVKldUuxxw==', '2025-06-08 11:46:31', '2025-06-08 11:46:31'),
(258, 'oHRgK41DUVp5WPDy5SCRJGt8SJGU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'O2LA+peJqVBbpczOKO3lEw==', '2025-06-08 11:46:58', '2025-06-08 11:46:58'),
(259, 'oHRgK4xaTIBF8MgEHw2Y9l1WmYPQ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'xnqbu61R6wYnOWIMb9OdvQ==', '2025-06-08 12:49:04', '2025-06-08 12:49:04'),
(260, 'oHRgK40kOyKHvfA7ndoRcEdC_nG4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0dgTEptCQ/gvP2UuYi0WVg==', '2025-06-08 14:20:31', '2025-06-08 14:20:31'),
(261, 'oHRgK4xOsZzSccz7A973vBSFP75c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4bxkJP7lD5yBPFQf5s4Ixw==', '2025-06-08 17:04:46', '2025-06-08 17:04:46'),
(262, 'oHRgK46MQqI_g497SpWDA3h68otU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'aW1VFqHreJptrr1/Dj6XzA==', '2025-06-09 10:34:14', '2025-06-09 10:34:14'),
(263, 'oHRgK40a_ic9NciOMoWlrx6UhbM0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F8YGP2IU9iFbsFZpqOlPxw==', '2025-06-09 14:50:13', '2025-06-09 14:50:13'),
(264, 'oHRgK49OLeGV-Mx5Dnc_PQcdwq7Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'gwz2EVaPsxPN0/FLF7yFqw==', '2025-06-09 15:07:26', '2025-06-09 15:07:26'),
(265, 'oHRgK4wy5F62Do8hIwQVFNG1PWbg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'tppou3o1u9oC3VLQBAWGQQ==', '2025-06-10 15:40:00', '2025-06-10 15:40:00'),
(266, 'oHRgK4x7tEm8ydJ2l-kxhxMoXrdE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'dBuBUovqDq4O5aT71CTK8A==', '2025-06-11 00:05:53', '2025-06-11 17:55:42'),
(267, 'oHRgK47mUIzsLkL70DUrwKfmfgHA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EMRKY5CDIqLYGYRP2tfN1g==', '2025-06-11 05:16:36', '2025-06-11 05:16:36'),
(268, 'oHRgK46nk9sHU_blQi8YYpw8XphM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SIMIYvI5sKeSwoU7Zowisw==', '2025-06-11 11:10:52', '2025-06-11 11:10:52'),
(269, 'oHRgK486vhqZruCGAVTdvftZcuN8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OtQ3N8emOcbXpuZV5Y4VDw==', '2025-06-11 12:03:09', '2025-06-11 12:03:09'),
(270, 'oHRgK46CGhFAmgC2R4YWZZqkfc80', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ezGpT+eJq3V66/RuqzVtdA==', '2025-06-11 22:47:43', '2025-06-11 22:47:43'),
(271, 'oHRgK4xUQ8Bv80gJpIrIN3E1kprk', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'vQctV8TRcfN/rpeYXzFPlg==', '2025-06-12 16:29:19', '2025-06-12 16:29:19'),
(272, 'oHRgK4wvlPwfIM1c2arfvWbbbGh0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'yBdq/1Lvot9BTqW769R9yA==', '2025-06-12 19:44:26', '2025-06-12 19:44:26'),
(273, 'oHRgK49VTxa4TDhSp44mis0rAqoQ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NcxG4R0ebke9e2DvTVHm8Q==', '2025-06-12 20:08:08', '2025-06-12 21:26:37'),
(274, 'oHRgK484WtgtxuyqYUSmcw_K5x7g', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EER1+RuOn+Gxl+Pn/I8iNg==', '2025-06-13 07:39:21', '2025-06-13 07:39:21'),
(275, 'oHRgK43xmPpRSFq46DF9LDz_X1BU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ZwSegpBkZcV3AhaOWFvYUw==', '2025-06-13 12:21:16', '2025-06-13 12:21:16'),
(276, 'oHRgK4y0h6NbDCkQEpT8tN1hoKAo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '6fL1ZLiezWsoOTwlys063Q==', '2025-06-13 16:08:58', '2025-06-13 16:08:58'),
(277, 'oHRgK46bHwmjcSjwcCvEaM6JB6Lo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'WRP2cR48KPG9NTBxx35w0w==', '2025-06-13 18:15:22', '2025-06-13 18:15:22'),
(278, 'oHRgK4yUVb5Cr1UTzVXOSXjNzk-A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uJvIRIYMjLr9PyuP+fzpnQ==', '2025-06-14 11:57:25', '2025-06-14 11:57:25'),
(279, 'oHRgK43Poh4q6f8IWVv0AcwYWrjs', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '440xWrRuvj1FLiPzYYT31Q==', '2025-06-14 13:26:36', '2025-06-14 13:26:36'),
(280, 'oHRgK4_BFY1NQii5QckLi7NwSDC0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'eQQdJk3oNraJp4/KN67BZw==', '2025-06-14 23:08:06', '2025-06-14 23:08:06'),
(281, 'oHRgK48JxqCYUxSZY9cSGNJVhQsE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uJ9kk+jTGyINxUN6l6n/yw==', '2025-06-15 12:39:29', '2025-06-15 12:39:29'),
(282, 'oHRgK4wFqZbC_wf4BA6QZIbyc9I8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'y+Pd1m2jGoKBnLrxQ4edbQ==', '2025-06-15 16:26:12', '2025-06-15 16:26:12'),
(283, 'oHRgK4wHMT4PFKx4godLdkwTLF2o', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lfKNDxsJrDuelN3w/8BkPQ==', '2025-06-16 18:13:25', '2025-06-16 18:13:25'),
(284, 'oHRgK4ypbUHvybvQVrtAfZpXEij0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'jlvJBv869gJJ/TX8WTXsnA==', '2025-06-17 09:00:53', '2025-06-17 09:11:50'),
(285, 'oeog-5ekvOGCu2-DVZUJ0WCxPhA0', NULL, '通', '../../static/logo.png', NULL, NULL, NULL, NULL, '/QlBLdpRzks/3YGK8jaEaQ==', '2025-06-19 22:09:12', '2025-06-19 22:10:45'),
(286, 'oeog-5XJ_LJXbek6D2uk92mDGnoU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5fzrINPsQZVuUG/8ievAvg==', '2025-06-20 01:18:58', '2025-06-20 01:18:58'),
(287, 'oeog-5eF5RmY7yzhViHYiu8O2mJU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'JWE8LpwpjyoF9G1NUIr3FQ==', '2025-06-20 01:18:58', '2025-06-20 01:18:58'),
(288, 'oeog-5cLTmOJsrtTuSHogUKIo9m8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CIvvccwWL4jo9+wSm1npew==', '2025-06-20 01:18:59', '2025-06-20 17:29:55'),
(289, 'oeog-5cpuyYWcD-tZt2LpwpB0IOw', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ZsB6x8C6ZNPWo/BJ7+2tKA==', '2025-06-20 17:29:54', '2025-06-20 17:29:54'),
(290, 'oeog-5QfM14QcmKAZX3TNvMvZ6Fc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'h4Q3M6OhklKi6F+gKb6zNw==', '2025-06-20 17:29:55', '2025-06-20 17:29:55'),
(291, 'oHRgK4-KS7tdkFN7nc0hk24Ld5HQ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'aXzwxuZlDGYVPVFIVsJ1Uw==', '2026-03-09 16:44:08', '2026-03-09 16:44:08'),
(292, 'oHRgK44iqeORxUKRg_FeiEkN0s3I', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wH57GgnPffhhsLrbrIqt6w==', '2026-03-09 17:05:22', '2026-03-09 17:05:22'),
(293, 'oHRgK4ykZg26ZNspifdV2y32uiJc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Ta6eyFC2Ji6gxmfme0jO6g==', '2026-03-09 18:20:53', '2026-03-09 18:20:53'),
(294, 'oHRgK49_epT_sKzlou6rpjGNR-I0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'enyEuQQ7lZ+1Vnid7ZrpGA==', '2026-03-09 18:21:51', '2026-03-09 18:21:51'),
(295, 'oHRgK46GqBHHVOP15BujUbgg-Q0s', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'WHf5KrhJuwJOCqmEGKDrvQ==', '2026-03-09 18:22:03', '2026-03-09 18:22:03'),
(296, 'oHRgK49RQ-6hagskuuc3_JQ_6MI8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2JZTS18lbAy0mzbaGTG3Sg==', '2026-03-09 18:24:28', '2026-03-09 18:24:28'),
(297, 'oHRgK4yCIUL1B9-MSygc3jtQCunU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ZAQD73VaBkkAkM6nMWuSDA==', '2026-03-09 19:26:24', '2026-03-09 19:26:24'),
(298, 'oHRgK4-HWXmGtqMQepnmSKhXS8B8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '488gvMn3auI8AXWFNBzTBg==', '2026-03-09 23:49:06', '2026-03-09 23:49:06'),
(299, 'oHRgK43dWQSH2ClnZL-Ln7Bcs3l8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Be4vsa8QERRCiXWWyD+RWg==', '2026-03-10 11:06:57', '2026-03-10 11:06:57'),
(300, 'oHRgK48Aac5oaAXRLuOJ0B2Jn7rY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'GRzDEyIw6sWtmOuis+++Pg==', '2026-03-10 13:23:43', '2026-03-10 13:23:43'),
(301, 'oHRgK46_imnq8jQT4N49dJPEptZU', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KpuAkxLknpnuByCPR0yqYQ==', '2026-03-10 14:43:04', '2026-03-10 14:43:04'),
(302, 'oHRgK45-K9TUzqVjiGOm2Iy1zBow', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'kinDcl6VAgEr7CfyC5xVMg==', '2026-03-10 14:43:07', '2026-03-10 14:43:07');

--
-- 转储表的索引
--

--
-- 表的索引 `material_category`
--
ALTER TABLE `material_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_sort` (`sort_order`),
  ADD KEY `idx_sort_field` (`sort_field`);

--
-- 表的索引 `material_info`
--
ALTER TABLE `material_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_sort_time` (`sort_time`),
  ADD KEY `idx_create_time` (`create_time`),
  ADD KEY `idx_sub_category_id` (`sub_category_id`);

--
-- 表的索引 `material_subcategory`
--
ALTER TABLE `material_subcategory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category_id` (`category_id`);

--
-- 表的索引 `material_user_collection_list`
--
ALTER TABLE `material_user_collection_list`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `miniprogram_info`
--
ALTER TABLE `miniprogram_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_appid` (`appid`),
  ADD KEY `app_secret` (`app_secret`),
  ADD KEY `app_secret_2` (`app_secret`);

--
-- 表的索引 `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `router_menu`
--
ALTER TABLE `router_menu`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `wallpaper_app_img_list`
--
ALTER TABLE `wallpaper_app_img_list`
  ADD PRIMARY KEY (`id`,`group_id`) USING BTREE;

--
-- 表的索引 `wallpaper_image_categories`
--
ALTER TABLE `wallpaper_image_categories`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `wallpaper_image_groups`
--
ALTER TABLE `wallpaper_image_groups`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `wallpaper_image_list`
--
ALTER TABLE `wallpaper_image_list`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `wallpaper_image_tags`
--
ALTER TABLE `wallpaper_image_tags`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `wallpaper_image_to_tags`
--
ALTER TABLE `wallpaper_image_to_tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_image_tag` (`image_id`,`tag_id`),
  ADD KEY `idx_image_to_tags_image_id` (`image_id`),
  ADD KEY `idx_image_to_tags_tag_id` (`tag_id`);

--
-- 表的索引 `wallpaper_user_collections`
--
ALTER TABLE `wallpaper_user_collections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_group` (`user_id`,`group_id`),
  ADD KEY `idx_created` (`created_at`);

--
-- 表的索引 `wallpaper_user_favorites`
--
ALTER TABLE `wallpaper_user_favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_user_image` (`user_id`,`image_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_image_id` (`image_id`);

--
-- 表的索引 `wx_users`
--
ALTER TABLE `wx_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `openid` (`openid`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `material_category`
--
ALTER TABLE `material_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=16;

--
-- 使用表AUTO_INCREMENT `material_info`
--
ALTER TABLE `material_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=107;

--
-- 使用表AUTO_INCREMENT `material_subcategory`
--
ALTER TABLE `material_subcategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `material_user_collection_list`
--
ALTER TABLE `material_user_collection_list`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `miniprogram_info`
--
ALTER TABLE `miniprogram_info`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号', AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `router_menu`
--
ALTER TABLE `router_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号', AUTO_INCREMENT=135;

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号', AUTO_INCREMENT=55;

--
-- 使用表AUTO_INCREMENT `wallpaper_app_img_list`
--
ALTER TABLE `wallpaper_app_img_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- 使用表AUTO_INCREMENT `wallpaper_image_categories`
--
ALTER TABLE `wallpaper_image_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `wallpaper_image_groups`
--
ALTER TABLE `wallpaper_image_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- 使用表AUTO_INCREMENT `wallpaper_image_list`
--
ALTER TABLE `wallpaper_image_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1243;

--
-- 使用表AUTO_INCREMENT `wallpaper_image_tags`
--
ALTER TABLE `wallpaper_image_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- 使用表AUTO_INCREMENT `wallpaper_image_to_tags`
--
ALTER TABLE `wallpaper_image_to_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1236;

--
-- 使用表AUTO_INCREMENT `wallpaper_user_collections`
--
ALTER TABLE `wallpaper_user_collections`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- 使用表AUTO_INCREMENT `wallpaper_user_favorites`
--
ALTER TABLE `wallpaper_user_favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=372;

--
-- 使用表AUTO_INCREMENT `wx_users`
--
ALTER TABLE `wx_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=303;

--
-- 限制导出的表
--

--
-- 限制表 `material_info`
--
ALTER TABLE `material_info`
  ADD CONSTRAINT `fk_category` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subcategory` FOREIGN KEY (`sub_category_id`) REFERENCES `material_subcategory` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- 限制表 `material_subcategory`
--
ALTER TABLE `material_subcategory`
  ADD CONSTRAINT `fk_subcategory_category` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`) ON UPDATE CASCADE;

--
-- 限制表 `wallpaper_image_to_tags`
--
ALTER TABLE `wallpaper_image_to_tags`
  ADD CONSTRAINT `fk_image_to_tags_image` FOREIGN KEY (`image_id`) REFERENCES `wallpaper_image_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_image_to_tags_tag` FOREIGN KEY (`tag_id`) REFERENCES `wallpaper_image_tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
