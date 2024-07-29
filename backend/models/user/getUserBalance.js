const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const fetchBalance = async (userId) => {
    try {
        const cacheData=await redis.get(`userBalance:${userId}`)
        if(cacheData) return JSON.parse(cacheData)
        const { rows } = await pool.query(
            'SELECT * FROM account WHERE id = $1',
            [userId]
        )
        redis.set(`userBalance:${userId}`,JSON.stringify(rows[0].balance))
        return rows[0].balance
    } catch (error) {
        console.error("Error fetching balance data:", error)
        throw error
    }
}
module.exports={fetchBalance}