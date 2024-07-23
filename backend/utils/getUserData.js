const { pool } = require("../config/dbConfig")

const getUserDetails = async (id) => {
    try {
        const personal_details = await pool.query(`
        SELECT account.account_number,account.balance, customer.first_name, customer.last_name
        FROM account
        LEFT JOIN customer ON account.customer_id = customer.id
        WHERE account.id = $1
      `, [id])
      personal_details.rows[0].balance=parseFloat(personal_details.rows[0].balance)
        const investementDetails=await pool.query(`SELECT mutual_funds_investement.* FROM account LEFT JOIN mutual_funds_investement ON mutual_funds_investement.account_id=account.id WHERE account.id=$1`,[id])
        return {personal_details:personal_details.rows[0],investementDetails:investementDetails.rows}
    } catch (error) {
        console.error('Error executing query', error.stack)
        throw error
    }
}
module.exports = getUserDetails