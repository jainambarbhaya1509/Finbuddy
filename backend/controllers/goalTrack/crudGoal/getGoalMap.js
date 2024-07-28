const { pool } = require("../../../config/dbConfig")
const getGoalMap = require("../../../models/goal/getGoalMap")

const getGoalWithTrackDetails = async (req, res) => {
  try {
    const { goal_id } = req.params

    if (!goal_id) {
      return res.status(400).send({ error: "Missing goal_id" })
    }

    const result = await getGoalMap(goal_id)

    if (result.length === 0) {
      return res.status(404).send({ error: "Goal not found" })
    }

    // Extract goal data (assuming goal data is the same for all rows)
    const goalData = {
      id: result[0].goal_id,
      name: result[0].name,
      goal_amount: result[0].goal_amount,
      time_frame: result[0].time_frame,
      savings_needed: result[0].savings_needed,
      created_at: result[0].goal_created_at,
      interval: result[0].interval,
      pending_amount: result[0].pending_amount,
    }

    // Extract goal_track data
    const goalTrackData = result.map(row => ({
      track_id: row.track_id,
      saved_amount: row.saved_amount,
      created_at: row.track_created_at
    })).filter(track => track.track_id !== null) // Filter out null track_id values

    res.send({
      goal: goalData,
      goalTracks: goalTrackData
    })
  } catch (error) {
    console.error('Error executing query', error.stack)
    res.status(500).send(error)
  }
}

module.exports = getGoalWithTrackDetails
