const { pool } = require("../../config/dbConfig")
const getUserid = require("../../utils/getUSerid")

const categoriseTransaction = async (req, res) => {
    try {
        const token=req.headers.userauth
        
        const decodeData=await getUserid(token)
        if(decodeData.error) return res.send(decodeData.error).sendStatus(500)

        const response = await pool.query(`
        SELECT description, COUNT(*) AS count, SUM(amount) AS total_amount
        FROM transaction
        WHERE account_id=$1
        GROUP BY description
        ORDER BY total_amount DESC
        `,[decodeData.id])
        const data = response.rows

        return res.send(data)
    } catch (error) {
        console.log(error);
        res.send("Something went wrong")
    }
}
module.exports = categoriseTransaction