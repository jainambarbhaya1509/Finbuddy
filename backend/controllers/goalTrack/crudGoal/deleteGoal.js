const { pool } = require("../../../config/dbConfig")
const updateGoalCache = require("../../../models/goal/updateGoalCache")

const deleteGoal = async (req, res) => {
    try {
        const { goal_id } = req.params
        pool.query('DELETE FROM goal WHERE id=$1', [goal_id])
        res.send("Deleted")
        await updateGoalCache()
    } catch (error) {
        console.log(error)
        res.status(500).send(error)
    }
}
module.exports = deleteGoal