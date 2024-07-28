const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")
const getUserid = require("../../utils/userInfo/getUserid")
const { categoriseTransactionData } = require("../../utils/userInfo/getUserTransaction")

const categoriseTransaction = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = getUserid(token)

        const cacheData = await redis.hget(`userTransaction:${decodeData.id}`, 'categorise')
        if (cacheData) {
            return res.send(JSON.parse(cacheData))
        }

        const response = await categoriseTransactionData(decodeData.id)
        await redis.hset(
            `userTransaction:${decodeData.id}`,
            'categorise',
            JSON.stringify(response)
        )
        await redis.expire(`userTransaction:${decodeData.id}`, 3600) // Set cache expiry to 1 hour

        return res.send(response)
    } catch (error) {
        console.log(error)
        res.status(500).send("Something went wrong")
    }
}

module.exports = categoriseTransaction
