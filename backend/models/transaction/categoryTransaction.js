const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const categoriseTransactionData = async (userId) => {
    try {
        const cacheData=await redis.get(`categoryTransaction:${userId}`)
        if(cacheData) return JSON.parse(cacheData)
        const response = await pool.query(`
            SELECT description, COUNT(*) AS count, SUM(amount) AS total_amount
            FROM transaction
            WHERE account_id=$1
            GROUP BY description
            ORDER BY total_amount DESC
        `, [userId])

        const data = response.rows.map(data => {
            data.count = parseInt(data.count, 10)
            data.total_amount = parseFloat(data.total_amount, 10)
            return data
        })
        redis.set(`categoryTransaction:${userId}`,JSON.stringify(data))
        return data
    } catch (error) {
        console.error('Error fetching data from database:', error)
    }
}
module.exports=categoriseTransactionData