module.exports = {
    formatDateTime: async function () {
        const date = new Date();
        const padZero = num => num.toString().padStart(2, '0'); // 补零函数

        return [
            date.getFullYear(),
            padZero(date.getMonth() + 1), // 月份从0开始计算
            padZero(date.getDate()),
        ].join('-') + ' ' + [
            padZero(date.getHours()),
            padZero(date.getMinutes()),
            padZero(date.getSeconds())
        ].join(':');
    }
}
