const { pool } = require("../../../config/dbConfig");
const { redis } = require("../../../config/redisServer");

const getUserMutualFunds = async (userId) => {
    const cacheData=await redis.get(`userMutualFunds:${userId}`)
    if(cacheData) return JSON.parse(cacheData)

    const investmentDetails = await pool.query(`SELECT 
                mutual_funds_investement.*,
                mutual_funds.scheme_name as fund_name,
                SUM(mutual_funds_investement.investment_amount) OVER () as total_invested_amount,
                SUM(mutual_funds_investement.current_value) OVER () as total_current_value
            FROM account
            LEFT JOIN mutual_funds_investement ON mutual_funds_investement.account_id = account.id
            LEFT JOIN mutual_funds ON mutual_funds_investement.scheme_code = mutual_funds.id
            WHERE account.id = $1
    `, [userId])

    let totalInvestedAmount = 0;
    let totalCurrentValue = 0;
    if (investmentDetails.rows.length > 0) {
        totalInvestedAmount = parseFloat(investmentDetails.rows[0].total_invested_amount);
        totalCurrentValue = parseFloat(investmentDetails.rows[0].total_current_value);
    }
    redis.set(`userMutualFunds:${userId}`,JSON.stringify( {
        investment_details: investmentDetails.rows,
        totals: {
            total_invested_amount: totalInvestedAmount,
            total_current_value: totalCurrentValue,
        },
    }))
    return {
        investment_details: investmentDetails.rows,
        totals: {
            total_invested_amount: totalInvestedAmount,
            total_current_value: totalCurrentValue,
        },
    };
}
module.exports = { getUserMutualFunds }
