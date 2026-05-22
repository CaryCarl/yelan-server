// 格式化日期时间 - 返回格式: 2026-05-18 17:43:40
function formatDateTime(date = new Date()) {
	const padZero = num => num.toString().padStart(2, '0');
	return [
		date.getFullYear(),
		padZero(date.getMonth() + 1),
		padZero(date.getDate()),
	].join('-') + ' ' + [
		padZero(date.getHours()),
		padZero(date.getMinutes()),
		padZero(date.getSeconds())
	].join(':');
}

// 格式化日期 - 返回格式: 2026-05-18
function formatDate(date = new Date()) {
	const padZero = num => num.toString().padStart(2, '0');
	return [
		date.getFullYear(),
		padZero(date.getMonth() + 1),
		padZero(date.getDate()),
	].join('-');
}

// 格式化时间 - 返回格式: 17:43:40
function formatTime(date = new Date()) {
	const padZero = num => num.toString().padStart(2, '0');
	return [
		padZero(date.getHours()),
		padZero(date.getMinutes()),
		padZero(date.getSeconds())
	].join(':');
}

module.exports = {
	formatDateTime,
	formatDate,
	formatTime
};