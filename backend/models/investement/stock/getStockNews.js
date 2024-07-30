const axios = require('axios')

const base_url=process.env.STOCK_APP_BASE_URL
const getStockNews = async (data) => {
    try {
        const userInvestment = await axios.post(`${base_url}/fetch_news`,{stock_names:data})
        return userInvestment.data
    } catch (error) {
        console.log(`Axios error ${error}`);
    }
}
module.exports = getStockNews  