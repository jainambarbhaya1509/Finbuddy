const goalData = require("../../models/goal/getUserGoal");
const { getUserMutualFunds } = require("../../models/investement/mutualFunds/getUserMutualF");
const { getUserLoan } = require("../../models/loan/getUserLoan");
const getTransactionData = require("../../models/transaction/getTransaction");
const { fetchBalance } = require("../../models/user/getUserBalance");

const getUserPortfolio = async (userId) => {
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
