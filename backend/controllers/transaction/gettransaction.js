const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")
const getUserid = require("../../utils/userInfo/getUserid")
const { getTransactionData } = require("../../utils/userInfo/getUserTransaction")

const getTransaction = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = getUserid(token)
        if (decodeData.error) return res.status(500).send(decodeData.error)

        const cacheData = await redis.hget(`userTransaction:${decodeData.id}`, 'getAll')
        if (cacheData) {
            return res.send(JSON.parse(cacheData))
        }

        const data = await getTransactionData(decodeData.id)
        
        redis.hset(
            `userTransaction:${decodeData.id}`,
            'getAll',
            JSON.stringify(data)
        )
        await redis.expire(`userTransaction:${decodeData.id}`, 3600) // Set cache expiry to 1 hour

        return res.send(data)
    } catch (error) {
        console.log(error)
        res.status(500).send("Something went wrong")
    }
}

module.exports = getTransaction
