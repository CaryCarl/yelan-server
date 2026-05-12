const mysql=require("mysql");
const pool=mysql.createPool({
	host:"122.51.43.64",
	port:3306,
	user:"yelanSQL",
	password:"aaa123456..",
	database:"yelansql",
	connectionLimit:15,
	dateStrings:true
});

module.exports=pool;
