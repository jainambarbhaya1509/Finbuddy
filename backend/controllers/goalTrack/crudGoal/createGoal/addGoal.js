const createGoal = require("../../../../models/goal/createGoal")
const getUserid = require("../../../../models/user/getUserid")

const addGoal = async (req, res) => {
    try {
        const { goal_amount, time_frame, saving_needed, interval, name } = req.body
        const { userauth } = req.headers
        const { id } = getUserid(userauth)

        if (goal_amount === undefined || time_frame === undefined || saving_needed === undefined, interval === undefined || name === undefined) {
            return res.status(400).send({ error: "All fields are required: goal_amount, time_frame, saving_needed,interval,goal_name" })
        }

        const goalData = await createGoal(goal_amount,id, time_frame, saving_needed, interval, name)
        // Respond with the inserted data
        res.status(200).send({ goal_id: goalData.rows[0].id, message: "Goal Created" })
    } catch (error) {
        console.error("Error inserting data:", error)
        res.status(500).send({ error: "Failed to insert data" })
    }
}

module.exports = addGoal
