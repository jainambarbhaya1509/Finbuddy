const getUserid = require('../../utils/userInfo/getUserid')
const getFinancialAdvice = require("../../utils/openAi/chatbot/chatBot")
const { pool } = require("../../config/dbConfig")
const { getTransactionData } = require('../../utils/userInfo/getUserTransaction')

const TransactionPrompt = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { userInput } = req.params

        const decodeData = getUserid(token)
        const data = await getTransactionData(decodeData.id)
        
        const botResponse = await getFinancialAdvice(userInput, `Here is the data of my transaction data: ${JSON.stringify(data)}`)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = TransactionPrompt
