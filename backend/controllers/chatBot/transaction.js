const transactionBot = require("../../utils/openAi/chatbot/transactionBot")
const getUserid = require('../../utils/getUserid')

const TransactionPrompt = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { userInput } = req.params
        const decodeData = getUserid(token)

        const botResponse = await transactionBot(decodeData.id, userInput)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = TransactionPrompt
