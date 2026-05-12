/**
 * 将下划线命名转换为驼峰命名
 * @param {string} str - 下划线格式的字符串
 * @returns {string} - 驼峰格式的字符串
 */
const toCamelCase = (str) => {
    return str.replace(/_([a-z])/g, (match, letter) => letter.toUpperCase());
};

/**
 * 将对象的键从下划线格式转换为驼峰格式
 * @param {Object} obj - 原始对象
 * @returns {Object} - 转换后的对象
 */
const objectToCamelCase = (obj) => {
    if (!obj || typeof obj !== 'object') {
        return obj;
    }

    if (Array.isArray(obj)) {
        return obj.map(item => objectToCamelCase(item));
    }

    const camelCaseObj = {};
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            const camelCaseKey = toCamelCase(key);
            camelCaseObj[camelCaseKey] = objectToCamelCase(obj[key]);
        }
    }

    return camelCaseObj;
};

/**
 * 将数据库查询结果转换为驼峰格式
 * @param {Array|Object} data - 数据库查询结果
 * @returns {Array|Object} - 转换后的数据
 */
const convertDbResultToCamelCase = (data) => {
    return objectToCamelCase(data);
};

/**
 * 批量转换多个字段为驼峰格式（仅转换第一层）
 * @param {Object} obj - 原始对象
 * @param {Array} fields - 需要转换的字段名数组
 * @returns {Object} - 转换后的对象
 */
const convertSpecificFields = (obj, fields) => {
    if (!obj || typeof obj !== 'object' || !Array.isArray(fields)) {
        return obj;
    }

    const result = { ...obj };
    fields.forEach(field => {
        if (obj.hasOwnProperty(field)) {
            const camelCaseField = toCamelCase(field);
            if (camelCaseField !== field) {
                result[camelCaseField] = result[field];
                delete result[field];
            }
        }
    });

    return result;
};

module.exports = {
    toCamelCase,
    objectToCamelCase,
    convertDbResultToCamelCase,
    convertSpecificFields
};
