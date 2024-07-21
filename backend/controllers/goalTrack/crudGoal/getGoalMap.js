const { pool } = require("../../../config/dbConfig");

const getGoalWithTrackDetails = async (req, res) => {
  try {
    const { goal_id } = req.params;

    if (!goal_id) {
      return res.status(400).send({ error: "Missing goal_id" });
    }

    const query = `
      SELECT goal.id as goal_id, goal.name, goal.goal_amount, goal.time_frame, goal.savings_needed,goal.completed, 
             goal.created_at as goal_created_at, goal.interval, goal.pending_amount,
             goal_track.id as track_id, goal_track.saved_amount, goal_track.created_at as track_created_at
      FROM goal 
      LEFT JOIN goal_track ON goal.id = goal_track.goal_id 
      WHERE goal.id = $1
    `;
    const values = [goal_id];

    const result = await pool.query(query, values);

    if (result.rows.length === 0) {0
      return res.status(404).send({ error: "Goal not found" });
    }

    // Extract goal data (assuming goal data is the same for all rows)
    const goalData = {
      id: result.rows[0].goal_id,
      name: result.rows[0].name,
      goal_amount: result.rows[0].goal_amount,
      time_frame: result.rows[0].time_frame,
      savings_needed: result.rows[0].savings_needed,
      created_at: result.rows[0].goal_created_at,
      interval: result.rows[0].interval,
      pending_amount: result.rows[0].pending_amount,
    };

    // Extract goal_track data
    const goalTrackData = result.rows.map(row => ({
      track_id: row.track_id,
      saved_amount: row.saved_amount,
      created_at: row.track_created_at
    })).filter(track => track.track_id !== null); // Filter out null track_id values

    res.send({
      goal: goalData,
      goalTracks: goalTrackData
    });
  } catch (error) {
    console.error('Error executing query', error.stack);
    res.status(500).send(error);
  }
};

module.exports = getGoalWithTrackDetails;
