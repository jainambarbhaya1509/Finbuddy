const { pool } = require("../../../../config/dbConfig")
const getUserid = require("../../../../utils/getUserid")


const addGoal = async (req, res) => {
    try {
        const { goal_amount, time_frame, saving_needed, interval, name } = req.body
        const { userauth } = req.headers
        const { id } = getUserid(userauth)
        if (goal_amount === undefined || time_frame === undefined || saving_needed === undefined, interval === undefined || name === undefined) {
            return res.status(400).send({ error: "All fields are required: goal_amount, time_frame, saving_needed,interval,goal_name" })
        }

        const query = `INSERT INTO goal (goal_amount, account_id, time_frame, savings_needed, interval, pending_amount, name,completed) VALUES ($1, $2, $3,$4,$5,$6,$7,$8) RETURNING *`
        const goalData = await pool.query(query, [goal_amount, id, time_frame, saving_needed, interval, goal_amount, name, Boolean(false)])

        // Respond with the inserted data
        res.status(200).send({ goal_id: goalData.rows[0].id, message: "Goal Created" })
    } catch (error) {
        console.error("Error inserting data:", error)
        res.status(500).send({ error: "Failed to insert data" })
    }
}

module.exports = addGoal
