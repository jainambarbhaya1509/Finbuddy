const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")
const getUserid = require("../../utils/getUserid")

const getTransaction = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = await getUserid(token)
        if (decodeData.error) return res.status(500).send(decodeData.error)

        const cacheData = await redis.hget(`userTransaction:${decodeData.id}`, 'getAll')
        if (cacheData) {
            return res.send(JSON.parse(cacheData))
        }

        const data = await pool.query("SELECT * FROM transaction WHERE account_id=$1", [decodeData.id])
        
        redis.hset(
            `userTransaction:${decodeData.id}`,
            'getAll',
            JSON.stringify(data.rows)
        )
        await redis.expire(`userTransaction:${decodeData.id}`, 3600) // Set cache expiry to 1 hour

        return res.send(data.rows)
    } catch (error) {
        console.log(error)
        res.status(500).send("Something went wrong")
    }
}

module.exports = getTransaction
