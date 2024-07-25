const getUserid = require('../../utils/getUserid')
const InvestementBot = require('../../utils/openAi/chatbot/investment')

const investementPrompt = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { userInput } = req.params
        const decodeData = getUserid(token)

        const botResponse = await InvestementBot(decodeData.id, userInput)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = investementPrompt
