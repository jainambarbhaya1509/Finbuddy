const getUserid = require("../../../utils/getUserid");
const GoalPlan = require("../../../utils/openAi/goalTrack/saving");

const saveMethod = async (req, res) => {
    try {
        const { goal_amount, time_frame, month_income } = req.body;
        const { userauth } = req.headers;
        const decodedData = getUserid(userauth);

        const goalPlan = await GoalPlan(goal_amount, time_frame, decodedData.id, month_income);
        return res.send(goalPlan);
    } catch (error) {
        console.error("Error in saveMethod:", error);
        return res.status(500).send({ error: "An error occurred while processing your request." });
    }
};

module.exports = saveMethod;