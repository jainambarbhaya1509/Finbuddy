const { pool } = require("../../config/dbConfig")
const getUserid = require("../../utils/userInfo/getUserid")

const readNotification = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { id } = getUserid(token)
        const notifications = await pool.query(`
      SELECT * FROM notifications
      WHERE account_id=$1
        AND is_read = FALSE
      ORDER BY timestamp DESC
    `, [id])
        return res.send(notifications.rows)
    } catch (error) {
        res.status(500).send("somthing went wrong")
    }
}
module.exports = readNotification