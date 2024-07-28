const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const updatenNotificationsCache = async (notificationId, userId) => {
    try {
        const notifications = await pool.query('UPADTE notifications SET is_read=$1 WHERE id=$2', [Boolean(true), notificationId])
        updateCache
        return notifications.rows
    } catch (error) {
        console.log(error);
    }
}
const updateCache = async (userId) => {
    const data = await pool.query(`
        SELECT * FROM notifications
        WHERE account_id=$1
          AND is_read = FALSE
        ORDER BY timestamp DESC
      `, [userId])
    redis.set(`notification:${userId}`, JSON.stringify(data.rows))
}
module.exports = {updatenNotificationsCache,updateCache}