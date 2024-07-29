const { pool } = require("../../../config/dbConfig");

const searchMutualFunds = async (mutualName) => {
    try {
        const { rows } = await pool.query(`SELECT * FROM mutual_Funds WHERE scheme_name LIKE $1`, [`%${mutualName}%`])
        return rows
    } catch (error) {
        console.log(error);
        throw error
    }
}
module.exports = searchMutualFunds