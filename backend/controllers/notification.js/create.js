const { pool } = require("../../config/dbConfig")
const { updateCache } = require("../../models/notifications/updateNotification")

const addNotification = async (account_id, content) => {
  try {
    pool.query(`INSERT INTO notifications (account_id,content) VALUES($1,$2)`, [account_id, content])
    updateCache()
  } catch (error) {
    console.error('Error handling notifications:', error)
    res.status(500).send({ error: 'Error handling notifications' })
  }
}

module.exports = addNotification
