const { pool } = require("../../../config/dbConfig")
const { redis } = require("../../../config/redisServer")

const getMutualFunds = async (req, res) => {
    try {
        const mutualName  = req.params.mutualName
        if (mutualName == null) {

            const cacheValue = await redis.get('mutualFunds')
            if (cacheValue) return res.send(JSON.parse(cacheValue))

            const data = await pool.query('SELECT * FROM mutual_funds')
            redis.set('mutualFunds', JSON.stringify(data))
            return res.send(data)
        }
        const mutualValue = await redis.get(mutualName)
        if (mutualValue) {
            console.log("DAta from redis")
            return res.send(JSON.parse(mutualValue))
        }

        const dataFunds = await pool.query(`SELECT * FROM mutual_Funds WHERE scheme_name LIKE $1`, [`%${mutualName}%`])
        if (dataFunds.rows!=null) return res.send("Not found") 
        redis.set(mutualName, JSON.stringify(dataFunds.rows))
        return res.send(dataFunds.rows)
    } catch (error) {
        console.log(error)
        return res.send(error)

    }
}

module.exports = getMutualFunds