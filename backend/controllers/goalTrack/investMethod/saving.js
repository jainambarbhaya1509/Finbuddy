const { pool } = require("../../../config/dbConfig")
const getUserid = require("../../../utils/getUserid")
const getFinancialAdviceOnSavingGoal = require("../../../utils/openAi/goalTrack/openAi/savingMethod")
const GoalPlan = require("../../../utils/openAi/goalTrack/saving")

const fetchLoan = async (userId) => {
    try {
        const { rows } = await pool.query(
            'SELECT * FROM loan JOIN loan_type ON loan.loan_type_id = loan_type.id WHERE loan.account_id = $1',
            [userId]
        )
        return rows
    } catch (error) {
        console.error("Error fetching loan data:", error)
        throw error
    }
}

const fetchTransaction = async (userId) => {
    try {
        const { rows } = await pool.query(
            'SELECT * FROM transaction WHERE account_id = $1',
            [userId]
        )
        return rows
    } catch (error) {
        console.error("Error fetching transaction data:", error)
        throw error
    }
}

const fetchBalance = async (userId) => {
    try {
        const { rows } = await pool.query(
            'SELECT balance FROM account WHERE id = $1',
            [userId]
        )
        return rows[0].balance
    } catch (error) {
        console.error("Error fetching balance data:", error)
        throw error
    }
}

const   saveMethod = async (req, res) => {
    try {
        const { goal_amount, time_frame, month_income, loan, transaction, balance } = req.body
        const { userauth } = req.headers
        const decodedData = getUserid(userauth)

        const [loan_data, transaction_data, balance_data] = await Promise.all([
            loan ? fetchLoan(decodedData.id) : Promise.resolve([]),
            transaction ? fetchTransaction(decodedData.id) : Promise.resolve([]),
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