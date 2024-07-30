const { redis } = require("../../../config/redisServer");
const getFinancialAdvice = require("../../../utils/openAi/chatbot/chatBot");
const getStockNews = require("./getStockNews");
const getStockPrice = require("./getStockPrice");
const getStock = require("./getUserStock");

const stockAnalysePrompt = async (userId,stockId) => {
    try {
        const cacheData=await redis.get(`stockAnalyse:${stockId}`)
        if(cacheData) return JSON.parse(cacheData)
        // Fetch the user's stock data
        const stock = await getStock(userId);
        if (!stock || stock.length === 0) {
            return "Stock data not found"
        }

        // Find the specific stock by stockId
        const stockData = stock.find((s) => Number(s.id) === Number(stockId));
        if (!stockData) {
            return "Stock not found"
        }

        // Fetch the current price of the stock
        const stockPriceData = await getStockPrice([stockData.symbol_name]);
        const stockNews = await getStockNews([stockData.stock_name])
        if (!stockPriceData || !stockPriceData[stockData.symbol_name]) {
            return "Current stock price not available";
        }

        const currentPrice = stockPriceData[stockData.symbol_name];
        const stockName = stockData.stock_name;
        const investedAmount = Number(stockData.purchased_price) * stockData.quantity;
        const totalCurrentValue = currentPrice * stockData.quantity;

        const stockCurrentValue = {
            stockName: stockName,
            invested: investedAmount,
            unit: stockData.quantity,
            currentValue: currentPrice,
            totalValue: totalCurrentValue,
            profitLoss: totalCurrentValue - investedAmount,
            latest_news: stockNews
        };
        const gptResponse = await getFinancialAdvice(`Given the following recent news articles about the stock, determine the overall market sentiment as either positive or negative.
                                                     Additionally, assess the potential impact of this news on the stocks recent price movement. 
                                                    Provide a brief summary explaining your assessment in simple language.`,
                                                    JSON.stringify(stockCurrentValue))
        redis.set(`stockAnalyse:${stockId}`,JSON.stringify(gptResponse),'EX',1800)
        return gptResponse
    } catch (error) {
        console.error(error);
        return "Try again later"
    }
};

module.exports = stockAnalysePrompt;
