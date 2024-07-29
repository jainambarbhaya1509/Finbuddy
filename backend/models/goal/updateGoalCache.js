const { pool } = require("../../config/dbConfig");
const { redis } = require("../../config/redisServer")

const updateGoalCache = async (userId) => {
    try {
        const { rows } = await pool.query('SELECT * FROM goal WHERE account_id=$1', [userId])
        if (rows.length===0) return redis.del(`goal:${userId}`)
        redis.set(`goal:${userId}`, JSON.stringify(rows))
    } catch (error) {
        console.log(error);
    }
}
module.exports=updateGoalCache