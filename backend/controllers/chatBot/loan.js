const getFinancialAdvice = require('../../utils/openAi/chatbot/chatBot')
const { getUserLoan } = require('../../models/loan/getUserLoan')
const getUserid = require('../../models/user/getUserid')

const loanPrompt = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { userInput } = req.params
        
        const decodeData = getUserid(token)
        const data = await getUserLoan(decodeData.id)

        const botResponse = await getFinancialAdvice(decodeData.id, `Here is the data of my loan: ${JSON.stringify(data)} ,`)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = loanPrompt
