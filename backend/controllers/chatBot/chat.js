const { redis } = require("../../config/redisServer")
const getFinancialAdvice = require("../../utils/openAi/chatbot/chatBot")

const chatPrompt = async (req, res) => {
    try {
        const { userInput } = req.params
        const cacheData=await redis.get(userInput) 
        if (cacheData) {
            return res.send(JSON.parse(cacheData))
        }
        const responseAdvice = await getFinancialAdvice(userInput)
        redis.set(userInput,JSON.stringify(responseAdvice))
        return res.send(responseAdvice)
    } catch (error) {
        console.log(error)
        return res.status(500).send("Something went wrong")
    }
}
module.exports = chatPrompt