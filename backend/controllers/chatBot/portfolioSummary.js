const getPortfolioAdvice = require("../../utils/openAi/chatbot/portfolioSummary")
const getUserid = require("../../utils/userInfo/getUserid")
const getUserPortfolio = require("../../utils/userInfo/getUserPortfolio")

const portfolioSummary = async (req, res) => {
    try {
        const {userauth}=req.headers
        const {id}=getUserid(userauth)
        const data = await getUserPortfolio(id)
        
        const gptRespose = await getPortfolioAdvice(data);
        console.log(gptRespose.message);

        if (gptRespose.error) {
            console.log(gptRespose.error);
            res.status(500).send("Please try again later")
        }
        res.send(gptRespose.message)
    } catch (error) {
        console.log(error)
        res.status(500).send("Please try again later")
    }
}
module.exports = portfolioSummary