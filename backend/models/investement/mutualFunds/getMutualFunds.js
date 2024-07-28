const { pool } = require("../../../config/dbConfig")
const { redis } = require("../../../config/redisServer")

const getMutalFundsData = async () => {
    try {
        const cacheValue = await redis.get('mutualFunds')
        if (cacheValue) return JSON.parse(cacheValue)

        const data = await pool.query('SELECT * FROM mutual_funds')
        redis.set('mutualFunds', JSON.stringify(data.rows))
        return data.rows

    } catch (error) {
        console.log(error);
    }
}
module.exports = getMutalFundsData