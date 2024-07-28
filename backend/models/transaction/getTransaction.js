const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const getTransactionData = async (userId) => {
    try {
        const cacheData = await redis.get(`userTransaction:${userId}`)
        if (cacheData) return JSON.parse(cacheData)
        
        const { rows } = await pool.query('SELECT * FROM transaction WHERE account_id=$1', [userId])
        redis.set(`userTransaction:${userId}`,JSON.stringify(rows))
        
        return rows
    } catch (error) {
        console.error('Error fetching data from database:', error)
    }
}
module.exports = getTransactionData