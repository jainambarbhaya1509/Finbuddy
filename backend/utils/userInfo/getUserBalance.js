const { pool } = require("../../config/dbConfig")

const fetchBalance = async (userId) => {
    try {
        const { rows } = await pool.query(
            'SELECT * FROM account WHERE id = $1',
            [userId]
        )
        console.log(rows);
        return rows[0].balance
    } catch (error) {
        console.error("Error fetching balance data:", error)
        throw error
    }
}
module.exports={fetchBalance}