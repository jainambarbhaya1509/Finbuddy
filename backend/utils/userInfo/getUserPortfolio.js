const { fetchBalance } = require("./getUserBalance");
const getUserDetails = require("./getUserData");
const { goalData } = require("./getUserGoal");
const { getUserLoan } = require("./getUserLoan");
const { getUserMutualFunds } = require("./getUserMutualF");
const { getTransactionData } = require("./getUserTransaction");

const getUserPortfolio = async (userId) => {
    console.log(`Userid: ${userId}`);
    try {
        const [transaction, mutualFunds, loan, goal,balance] = await Promise.all([
            getTransactionData(userId),
            getUserMutualFunds(userId),
            getUserLoan(userId),
            goalData(userId),
            fetchBalance(userId)
        ]);

        return {
            transaction,
            mutualFunds,
            loan,
            goal,
            balance
        };
    } catch (error) {
        console.error("Error fetching user portfolio data:", error);
    }
};

module.exports = getUserPortfolio;
