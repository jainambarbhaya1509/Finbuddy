const { pool } = require("../../../config/dbConfig")
const getUserid = require("../../../utils/userInfo/getUserid")

const getGoals = async (req, res) => {
    try {
        const { userauth } = req.headers
        const { id } = getUserid(userauth)
        const goalData = await pool.query('SELECT * FROM goal WHERE account_id=$1', [id])

        const result = goalData.rows.map((data) => {
            const createdAt = new Date(data.created_at)
            const targetDate = new Date(createdAt)
            targetDate.setDate(createdAt.getDate() + data.time_frame)
            return { ...data, target_date: targetDate }
        })
        res.send(result)
    } catch (error) {
        console.log(error)
        res.status(500).send(error)
    }
}

module.exports = getGoals
