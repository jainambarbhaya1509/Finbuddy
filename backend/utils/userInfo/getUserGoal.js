const { pool } = require("../../config/dbConfig")

const goalData = async(userId) => {
    const data= await pool.query('SELECT * FROM goal WHERE account_id=$1', [userId])
    return data.rows
}
module.exports={goalData}