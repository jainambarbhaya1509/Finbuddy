const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const getnNotifications = async (userId) => {
    try {
        const cacheData = await redis.get(`notification:${userId}`)
        if (cacheData) return JSON.parse(cacheData)

        const notifications = await pool.query(`
        SELECT * FROM notifications
        WHERE account_id=$1
          AND is_read = FALSE
        ORDER BY timestamp DESC
      `, [userId])
        redis.set(`notification:${userId}`, JSON.stringify(notifications.rows))
        return notifications.rows
    } catch (error) {
        console.log(error);
    }
}
module.exports=getnNotifications