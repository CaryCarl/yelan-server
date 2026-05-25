# 专辑管理接口文档

> 基于 `router/admin/albumConfig.js` 自动生成  
> 更新时间：2026-05-25  
> 基础路径：`/admin/album`

---

## 接口列表

| 方法   | 路径             | 描述         |
|--------|------------------|--------------|
| POST   | /admin/album/add     | 创建专辑     |
| POST   | /admin/album/delete  | 删除专辑     |
| POST   | /admin/album/update  | 修改专辑信息 |
| GET    | /admin/album/list    | 查询专辑列表 |
| GET    | /admin/album/detail  | 查询专辑详情 |

---

## 1. 创建专辑

**接口地址**：`POST /admin/album/add`

**功能说明**：创建一个新的热门专辑，专辑创建后默认状态为启用（status=1）。

### 请求参数

| 参数名        | 类型   | 必填 | 说明                                       |
|---------------|--------|------|--------------------------------------------|
| title         | string | 是   | 专辑标题                                   |
| description   | string | 否   | 专辑描述                                   |
| cover_image   | string | 否   | 封面图片地址                               |
| sort_order    | int    | 否   | 排序权重，数值越大越靠前，默认 `0`         |
| category_id   | int    | 否   | 分类 ID，默认 `null`                       |
| tags          | string | 否   | 标签，JSON 字符串或逗号分隔，默认 `null`   |

### 请求示例

```json
{
  "title": "风景摄影精选",
  "description": "收录全球最美风景照片",
  "cover_image": "https://example.com/images/cover.jpg",
  "sort_order": 10,
  "category_id": 1,
  "tags": "风景,自然,旅行"
}
```

### 响应示例

**成功响应**：

```json
{
  "code": 200,
  "mesg": "专辑创建成功",
  "data": {
    "albumId": 123
  }
}
```

**失败响应**：

```json
{
  "code": 400,
  "mesg": "专辑标题不能为空"
}
```

---

## 2. 删除专辑

**接口地址**：`POST /admin/album/delete`

**功能说明**：物理删除专辑及其关联数据。删除专辑时会同时清理 `hot_album_group_relation` 关联表中的数据。

### 请求参数

| 参数名 | 类型 | 必填 | 说明     |
|--------|------|------|----------|
| id     | int  | 是   | 专辑 ID  |

### 请求示例

```json
{
  "id": 123
}
```

### 响应示例

**成功响应**：

```json
{
  "code": 200,
  "mesg": "专辑及关联数据删除成功"
}
```

**失败响应**：

```json
{
  "code": 400,
  "mesg": "专辑ID不能为空"
}
```

---

## 3. 修改专辑信息

**接口地址**：`POST /admin/album/update`

**功能说明**：更新指定专辑的信息，支持部分更新（只传入需要修改的字段）。

### 请求参数

| 参数名        | 类型   | 必填 | 说明                     |
|---------------|--------|------|--------------------------|
| id            | int    | 是   | 专辑 ID                  |
| title         | string | 否   | 专辑标题                 |
| description   | string | 否   | 专辑描述                 |
| cover_image   | string | 否   | 封面图片地址             |
| sort_order    | int    | 否   | 排序权重                 |
| status        | int    | 否   | 状态 (0=禁用, 1=启用)    |
| category_id   | int    | 否   | 分类 ID                  |
| tags          | string | 否   | 标签                     |

### 请求示例

```json
{
  "id": 123,
  "title": "更新后的专辑标题",
  "sort_order": 20,
  "status": 1
}
```

### 响应示例

**成功响应**：

```json
{
  "code": 200,
  "mesg": "专辑更新成功"
}
```

**失败响应**：

```json
{
  "code": 400,
  "mesg": "专辑ID不能为空"
}
```

---

## 4. 查询专辑列表

**接口地址**：`GET /admin/album/list`

**功能说明**：分页查询专辑列表，支持关键词模糊搜索和状态筛选。返回结果按排序权重和创建时间倒序排列。

### 请求参数

| 参数名   | 类型   | 必填 | 说明                              |
|----------|--------|------|-----------------------------------|
| page     | int    | 否   | 页码，从 1 开始，默认 `1`         |
| pageSize | int    | 否   | 每页条数，默认 `10`                |
| keyword  | string | 否   | 关键词，模糊搜索标题和描述         |
| status   | int    | 否   | 状态筛选 (0=禁用, 1=启用)          |

### 请求示例

```
GET /admin/album/list?page=1&pageSize=10&keyword=风景&status=1
```

### 响应示例

**成功响应**：

```json
{
  "code": 200,
  "mesg": "查询成功",
  "data": {
    "list": [
      {
        "id": 123,
        "title": "风景摄影精选",
        "description": "收录全球最美风景照片",
        "coverImage": "https://example.com/images/cover.jpg",
        "sortOrder": 10,
        "categoryId": 1,
        "tags": "风景,自然,旅行",
        "status": 1,
        "createdAt": "2026-05-25T10:30:00.000Z",
        "updatedAt": "2026-05-25T10:30:00.000Z"
      }
    ],
    "pagination": {
      "total": 50,
      "page": 1,
      "pageSize": 10,
      "totalPages": 5
    }
  }
}
```

**空数据响应**：

```json
{
  "code": 200,
  "mesg": "查询成功",
  "data": {
    "list": [],
    "pagination": {
      "total": 0,
      "page": 1,
      "pageSize": 10,
      "totalPages": 0
    }
  }
}
```

---

## 5. 查询专辑详情

**接口地址**：`GET /admin/album/detail`

**功能说明**：根据专辑 ID 查询单个专辑的完整信息。

### 请求参数

| 参数名 | 类型 | 必填 | 说明     |
|--------|------|------|----------|
| id     | int  | 是   | 专辑 ID  |

### 请求示例

```
GET /admin/album/detail?id=123
```

### 响应示例

**成功响应**：

```json
{
  "code": 200,
  "mesg": "查询成功",
  "data": {
    "id": 123,
    "title": "风景摄影精选",
    "description": "收录全球最美风景照片",
    "coverImage": "https://example.com/images/cover.jpg",
    "sortOrder": 10,
    "categoryId": 1,
    "tags": "风景,自然,旅行",
    "status": 1,
    "createdAt": "2026-05-25T10:30:00.000Z",
    "updatedAt": "2026-05-25T10:30:00.000Z"
  }
}
```

**失败响应**：

```json
{
  "code": 400,
  "mesg": "专辑ID不能为空"
}
```

或

```json
{
  "code": 404,
  "mesg": "未找到该专辑信息"
}
```

---

## 通用响应说明

### 响应状态码

| HTTP 状态码 | 说明           |
|-------------|----------------|
| 200         | 请求成功       |
| 400         | 参数校验失败   |
| 404         | 资源不存在     |
| 500         | 服务器内部错误 |

### 响应字段

| 字段  | 类型   | 说明                 |
|-------|--------|----------------------|
| code  | int    | 业务状态码           |
| mesg  | string | 提示信息             |
| data  | object | 返回数据（可选）     |

---

## 数据库表结构

### hot_album 表

| 字段名       | 类型         | 说明                       |
|--------------|--------------|----------------------------|
| id           | int          | 主键，自增                 |
| title        | varchar      | 专辑标题                   |
| description  | text         | 专辑描述                   |
| cover_image  | varchar      | 封面图片地址               |
| sort_order   | int          | 排序权重                   |
| category_id  | int          | 分类 ID                    |
| tags         | varchar      | 标签                       |
| status       | tinyint      | 状态 (0=禁用, 1=启用)       |
| created_at   | datetime     | 创建时间                   |
| updated_at   | datetime     | 更新时间                   |

### hot_album_group_relation 表（关联表）

| 字段名      | 类型 | 说明         |
|-------------|------|--------------|
| id          | int  | 主键，自增   |
| album_id    | int  | 专辑 ID      |
| group_id    | int  | 分组 ID      |
