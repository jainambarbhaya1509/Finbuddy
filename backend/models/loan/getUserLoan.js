const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const getUserLoan = async (userId) => {
    try {
        const cacheData = await redis.get(`loan:${userId}`)
        if (cacheData) return JSON.parse(cacheData)

        const { rows } = await pool.query(`
      SELECT * FROM loan_type 
      JOIN loan ON loan_type.id = loan.loan_type_id 
      WHERE loan.account_id = $1`, [userId])
        redis.set(`loan:${userId}`, JSON.stringify(rows))
        return rows
    } catch (error) {
        console.error('Error fetching data from database:', error)
    }
}
module.exports = { getUserLoan }