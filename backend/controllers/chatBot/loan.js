const getUserid = require('../../utils/getUserid')
const LoanBot = require('../../utils/openAi/chatbot/loanBot')

const loanPrompt = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { userInput } = req.params
        const decodeData = getUserid(token)

        const botResponse = await LoanBot(decodeData.id, userInput)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = loanPrompt
