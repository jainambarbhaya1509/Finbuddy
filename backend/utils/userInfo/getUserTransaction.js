const { pool } = require("../../config/dbConfig")

const getTransactionData = async (userId) => {
    try {
        const { rows } = await pool.query('SELECT * FROM transaction WHERE account_id=$1', [userId])
        return rows
    } catch (error) {
        console.error('Error fetching data from database:', error)
    }
}

const categoriseTransactionData = async (userId) => {
    try {
        const response = await pool.query(`
            SELECT description, COUNT(*) AS count, SUM(amount) AS total_amount
            FROM transaction
            WHERE account_id=$1
            GROUP BY description
            ORDER BY total_amount DESC
        `, [userId])

        const data = response.rows.map(data => {
            data.count = parseInt(data.count, 10)
            data.total_amount = parseFloat(data.total_amount, 10)
            return data
        })

        return data
    } catch (error) {
        console.error('Error fetching data from database:', error)
    }
}
module.exports = { getTransactionData, categoriseTransactionData }