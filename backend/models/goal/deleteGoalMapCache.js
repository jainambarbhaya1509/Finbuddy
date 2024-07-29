const { redis } = require("../../config/redisServer")

const deleteGoalMapCache = async (goalId) => {
    try {
        redis.del(`goalMap:${goalId}`)
    } catch (error) {
        console.log(error);
    }
}
module.exports=deleteGoalMapCache