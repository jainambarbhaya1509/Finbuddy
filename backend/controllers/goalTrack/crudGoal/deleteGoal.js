const { pool } = require("../../../config/dbConfig")
const deleteGoalMapCache = require("../../../models/goal/deleteGoalMapCache")
const updateGoalCache = require("../../../models/goal/updateGoalCache")
const getUserid = require("../../../models/user/getUserid")

const deleteGoal = async (req, res) => {
    try {
        const {userauth}=req.headers
        const{id}=getUserid(userauth)
        const { goal_id } = req.params
        await pool.query('DELETE FROM goal WHERE id=$1', [goal_id])
        res.send("Deleted")
        deleteGoalMapCache(goal_id)
        await updateGoalCache(id)
    } catch (error) {
        console.log(error)
        res.status(500).send(error)
    }
}
module.exports = deleteGoal