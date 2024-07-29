const { pool } = require("../../../config/dbConfig")
const updateGoalMapCache = require("../../../models/goal/updateGoalMapCache")
const getUserid = require("../../../models/user/getUserid")

const updateGoal = async (req, res) => {
  try {
    const { goal_id, saved_amount, goal_amount, pending_amount, time_frame, interval } = req.body
    const { userauth } = req.headers
    const { id } = getUserid(userauth)

    if (goal_id === undefined || saved_amount === undefined || goal_amount === undefined || time_frame === undefined || interval === undefined) {
      return res.status(400).send({ error: "Missing Parameters" })
    }

    // Check if saved_amount is a valid number
    const savedAmount = parseFloat(saved_amount)
    if (isNaN(savedAmount) || savedAmount <= 0) {
      await updateGoalMapCache(id, goal_id)
      return res.status(400).send({ error: "Invalid saved_amount" })
    }

    // Insert into goal_track
    const insertQuery = `
      INSERT INTO goal_track (goal_id, saved_amount) 
      VALUES ($1, $2)
    `
    await pool.query(insertQuery, [goal_id, savedAmount])

    // Get the count of entries in goal_track for the goal_id
    const result = await pool.query(`SELECT COUNT(*) as count FROM goal_track WHERE goal_id = $1`, [goal_id])
    let duration = interval === "monthly" ? time_frame / 30 : time_frame
    duration -= result.rows[0].count

    // Calculate the total saved amount so far
    const totalSavedResult = await pool.query(`SELECT SUM(saved_amount) as total_saved FROM goal_track WHERE goal_id = $1`, [goal_id])
    const totalSaved = parseFloat(totalSavedResult.rows[0].total_saved) || 0

    // Determine the remaining pending amount
    const remainingPendingAmount = pending_amount !== null ? parseFloat(pending_amount) : parseFloat(goal_amount) - totalSaved

    // Calculate saving_needed
    const saving_needed = remainingPendingAmount / duration

    // Check if saving_needed is less than or equal to zero
    if (saving_needed <= 0) {
      await pool.query(`UPDATE goal SET savings_needed = $1, pending_amount = $2 WHERE id = $3`, [0, 0, goal_id])
      await updateGoalMapCache(id, goal_id)
      return res.send({
        time_frame: duration,
        saving_needed: '0',
        pending_amount: '0'
      })
    }

    // Update goal with saving_needed and remaining pending amount
    const updateQuery = `
      UPDATE goal 
      SET savings_needed = $1, pending_amount = $2
      WHERE id = $3 
      RETURNING *
    `
    const updateResponse = await pool.query(updateQuery, [saving_needed, remainingPendingAmount, goal_id])


    await updateGoalMapCache(id, goal_id)
    return res.send({
      time_frame: duration,
      saving_needed: parseFloat(updateResponse.rows[0].savings_needed),
      pending_amount: parseFloat(updateResponse.rows[0].pending_amount)
    })
  } catch (error) {
    console.log(error)
    res.status(500).send(error)
  }
}

module.exports = updateGoal
