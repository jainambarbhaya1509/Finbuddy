const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const getGoalMap = async (goal_id) => {
    try {
        const cacheData=await redis.get(`goalMap:${goal_id}`)
        if(cacheData) return JSON.parse(cacheData)

        const { rows } = await pool.query(`
        SELECT goal.id as goal_id, goal.name, goal.goal_amount, goal.time_frame, goal.savings_needed,goal.completed, 
               goal.created_at as goal_created_at, goal.interval, goal.pending_amount,
               goal_track.id as track_id, goal_track.saved_amount, goal_track.created_at as track_created_at
        FROM goal 
        LEFT JOIN goal_track ON goal.id = goal_track.goal_id 
        WHERE goal.id = $1
      `, [goal_id])
      
      redis.set(`goalMap:${goal_id}`,JSON.stringify(rows))
      return rows
    } catch (error) {
        console.log(error);
    }
}
module.exports = getGoalMap