const { pool } = require("../../config/dbConfig")

const getUserLoan = async (userId) => {
    try {
        const { rows } = await pool.query(`
      SELECT * FROM loan_type 
      JOIN loan ON loan_type.id = loan.loan_type_id 
      WHERE loan.account_id = $1`, [userId])
        return rows
    } catch (error) {
        console.error('Error fetching data from database:', error)
    }
}
module.exports={getUserLoan}