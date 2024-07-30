const { redis } = require("../../../config/redisServer");
const getFinancialAdvice = require("../../../utils/openAi/chatbot/chatBot");
const getStockNews = require("./getStockNews");
const getStockPrice = require("./getStockPrice");
const getStock = require("./getUserStock");

const allStock = async (userId,) => {
    try {
        // Fetch the user's stock data
        const stocks = await getStock(userId);
        if (!stocks || stocks.length === 0) {
            return "Stock data not found";
        }

        // Extract symbols and names from stocks
        const stockSymbols = stocks.map(stock => stock.symbol_name);
        const stockNames = stocks.map(stock => stock.stock_name);

        // Fetch stock prices and news
        const stockPriceData = await getStockPrice(stockSymbols);
        const stockNews = await getStockNews(stockNames);

        // Initialize an array to store stock information
        const stockDataArray = [];

        for (let i = 0; i < stocks.length; i++) {
            const stockData = stocks[i];
            const currentPrice = stockPriceData[stockData.symbol_name];
            if (!currentPrice) continue;

            const investedAmount = Number(stockData.purchased_price) * stockData.quantity;
            const totalCurrentValue = currentPrice * stockData.quantity;

            // Filter relevant news for the current stock
            const relevantNews = stockNews.filter(news => news.name.includes(stockData.stock_name));

            const stockCurrentValue = {
                stockName: stockData.stock_name,
                invested: investedAmount,
                unit: stockData.quantity,
                currentValue: currentPrice,
                totalValue: totalCurrentValue,
                profitLoss: totalCurrentValue - investedAmount,
                latest_news: relevantNews.length > 0 ? relevantNews : "No news available"
            };

            stockDataArray.push(stockCurrentValue);
        }
        return stockDataArray;
    } catch (error) {
        console.error(error);
        return "Try again later";
    }
};

module.exports = allStock;
