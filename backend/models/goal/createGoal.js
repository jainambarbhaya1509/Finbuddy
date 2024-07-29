const { pool } = require("../../config/dbConfig");
const updateGoalCache = require("./updateGoalCache");

const createGoal = async (goal_amount, userId, time_frame, saving_needed, interval, goal_name,) => {
    try {
        const data = pool.query(`INSERT INTO goal (goal_amount, account_id, time_frame, savings_needed, interval, pending_amount, name,completed) VALUES ($1, $2, $3,$4,$5,$6,$7,$8) RETURNING *`, [goal_amount, userId, time_frame, saving_needed, interval, goal_amount, goal_name, Boolean(false)])
        await updateGoalCache(userId);
        return data
    } catch (error) {
        console.log(error)
    }

}
module.exports = createGoal