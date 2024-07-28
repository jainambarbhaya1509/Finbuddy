const getFinancialAdvice = require("../../utils/openAi/chatbot/chatBot")

const chatPrompt = async (req, res) => {
    try {
        const { userInput } = req.params
        const responseAdvice = await getFinancialAdvice(userInput,"")
        return res.send(responseAdvice)
    } catch (error) {
        console.log(error)
        return res.status(500).send("Something went wrong")
    }
}
module.exports = chatPrompt