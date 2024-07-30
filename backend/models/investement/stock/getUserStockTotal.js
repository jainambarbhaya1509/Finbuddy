const axios = require('axios')

const base_url=process.env.STOCK_APP_BASE_URL
const getStockTotal = async (token) => {
    try {
        const userInvestment = await axios.post(`${base_url}/fetch_portfolio`,{userauth:token})
        return userInvestment.data
    } catch (error) {
        console.log(`Axios error ${error}`);
    }
}
module.exports = getStockTotal