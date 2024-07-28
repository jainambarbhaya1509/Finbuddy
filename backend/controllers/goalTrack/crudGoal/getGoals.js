const goalData = require("../../../models/goal/getUserGoal")
const getUserid = require("../../../models/user/getUserid")

const getGoals = async (req, res) => {
    try {
        const { userauth } = req.headers
        const { id } = getUserid(userauth)

        const goal = await goalData(id)
        const result = goal.map((data) => {
            const createdAt = new Date(data.created_at)
            const targetDate = new Date(createdAt)
            targetDate.setDate(createdAt.getDate() + data.time_frame)
            return { ...data, target_date: targetDate }
        })
        
        res.send(result)
    } catch (error) {
        console.log(error)
        res.status(500).send(error)
    }
}

module.exports = getGoals
