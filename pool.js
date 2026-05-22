const mysql=require("mysql");
const pool=mysql.createPool({
	host:"103.236.96.82",
	port:53306,
	user:"yelan",
	password:"aaa123456..",
	database:"yelan",
	connectionLimit:15,
	dateStrings:true
});
module.exports=pool;
