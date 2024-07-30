const { pool } = require("../../../config/dbConfig")
const { redis } = require("../../../config/redisServer")

const getStock=async(userId)=>{
    try {
        const cacheData=await redis.get(`userStock:${userId}`)
        if(cacheData) return JSON.parse(cacheData)

        const userInvestment=await pool.query('SELECT * FROM stock_investment WHERE account_id=$1',[userId])
        redis.set(`userStock:${userId}`,JSON.stringify(userInvestment.rows))
        return userInvestment.rows
    } catch (error) {
        console.log(error);
    }
}
module.exports=getStock