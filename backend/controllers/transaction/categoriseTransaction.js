const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")
const getUserid = require("../../utils/getUserid")

const categoriseTransaction = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = await getUserid(token)
        if (decodeData.error) {
            return res.status(500).send(decodeData.error)
        }
        const cacheData = await redis.hget(`userTransaction:${decodeData.id}`, 'categorise')
        if (cacheData) {
            return res.send(JSON.parse(cacheData))
        }

        const response = await pool.query(`
            SELECT description, COUNT(*) AS count, SUM(amount) AS total_amount
            FROM transaction
            WHERE account_id=$1
            GROUP BY description
            ORDER BY total_amount DESC
        `, [decodeData.id])

        const data = response.rows.map(data => {
            data.count = parseInt(data.count, 10)
            data.total_amount = parseFloat(data.total_amount, 10)
            return data
        })

        await redis.hset(
            `userTransaction:${decodeData.id}`,
            'categorise',
            JSON.stringify(data)
        )
        await redis.expire(`userTransaction:${decodeData.id}`, 3600) // Set cache expiry to 1 hour

        return res.send(data)
    } catch (error) {
        console.log(error)
        res.status(500).send("Something went wrong")
    }
}

module.exports = categoriseTransaction
