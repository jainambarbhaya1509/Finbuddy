const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const goalData = async (userId) => {
    try {
        const cacheData=await redis.get(`goal:${userId}`)
        if(cacheData) return JSON.parse(cacheData)
            
        const {rows} = await pool.query('SELECT * FROM goal WHERE account_id=$1', [userId])
        redis.set(`goal:${userId}`,JSON.stringify(rows))
        return rows
    } catch (error) {
        console.log(error);
    }
}
module.exports = goalData 