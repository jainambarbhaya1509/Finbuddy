const getUserDetails = require('../../utils/userInfo/getUserData')
const getUserid = require('../../utils/userInfo/getUserid')
const getFinancialAdvice = require('../../utils/openAi/chatbot/chatBot')
const { getUserMutualFunds } = require('../../utils/userInfo/getUserMutualF')


const investementPrompt = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { userInput } = req.params
        const decodeData = getUserid(token)

        const { investment_details } = await getUserMutualFunds(decodeData.id)
        const investment = investment_details.map((invested) => {
            invested.current_value = Number(invested.current_value)
            invested.total_invested_amount = Number(invested.total_invested_amount)
            invested.total_current_value = Number(invested.total_current_value)
            return invested
        })

        const botResponse = await getFinancialAdvice(userInput, `Here is my investement data ${JSON.stringify(investment)}`)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = investementPrompt
