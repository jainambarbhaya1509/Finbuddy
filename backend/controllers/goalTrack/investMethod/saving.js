const getFinancialAdviceOnSavingGoal = require("../../../utils/openAi/goalTrack/openAi/savingMethod")
const GoalPlan = require("../../../utils/openAi/goalTrack/saving")
const getTransactionData = require("../../../models/transaction/getTransaction")
const getUserid = require("../../../models/user/getUserid")
const { getUserLoan } = require("../../../models/loan/getUserLoan")
const { fetchBalance } = require("../../../models/user/getUserBalance")


const   saveMethod = async (req, res) => {
    try {
        const { goal_amount, time_frame, month_income, loan, transaction, balance } = req.body
        const { userauth } = req.headers
        const decodedData = getUserid(userauth)
        
        const [loan_data, transaction_data, balance_data] = await Promise.all([
            loan ? getUserLoan(decodedData.id) : Promise.resolve([]),
            transaction ? getTransactionData(decodedData.id) : Promise.resolve([]),
            balance ? fetchBalance(decodedData.id) : Promise.resolve(0)
        ])

        const goalPlan = await GoalPlan(goal_amount, time_frame, month_income, loan_data, transaction_data, balance_data)
        const gptRes=await getFinancialAdviceOnSavingGoal(goalPlan)
        
        res.send({...goalPlan,message:gptRes.message})
    } catch (error) {
        console.error("Error in saveMethod:", error)
        return res.status(500).send({ error: "An error occurred while processing your request." })
    }
}

module.exports = saveMethod