const getUserid = require("../user/getUserid")
const { getUserMutualFunds } = require("./mutualFunds/getUserMutualF")
const getStockTotal = require("./stock/getUserStockTotal")

const investmentPortfolio = async (token,userId) => {
    try {
        const stock = await getStockTotal(token)
        const mutualFunds = await getUserMutualFunds(userId)
        const totals = {
            total_invested_amount: (mutualFunds.totals.total_invested_amount) + (stock.total_invested),
            total_current_value: (mutualFunds.totals.total_invested_amount) + (stock.total_current_value)
        }
        return totals
    } catch (error) {
        console.log(error)
        return null
    }
}
module.exports = investmentPortfolio