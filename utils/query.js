const mysql = require('mysql')
const pool = require('../pool')


function query (sql,params) {
  return new Promise((resolve, reject) => {
    //获取连接
    pool.getConnection((err, conn) => {
      if (err){
        reject(err)
        return
      }
      //执行sql语句
      conn.query(sql, params, (err, result) => {
        conn.release()
        if (err) {
          reject(err)
          return
        }
        resolve(result)
      })
    })
  })
}


module.exports = query