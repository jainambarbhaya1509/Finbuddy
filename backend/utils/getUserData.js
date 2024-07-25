const { pool } = require("../config/dbConfig");

const getUserDetails = async (id) => {
    try {
        // Fetch personal details
        const personalDetailsQuery = `
            SELECT account.account_number, account.balance, customer.first_name, customer.last_name
            FROM account
            LEFT JOIN customer ON account.customer_id = customer.id
            WHERE account.id = $1
        `;
        const personalDetailsResult = await pool.query(personalDetailsQuery, [id]);
        if (personalDetailsResult.rows.length === 0) {
            throw new Error(`Account with ID ${id} not found`);
        }

        // Parse balance to float
        const personalDetails = personalDetailsResult.rows[0];
        personalDetails.balance = parseFloat(personalDetails.balance);

        // Fetch investment details with mutual funds information and calculate sums
        const investmentDetailsQuery = `
            SELECT 
                mutual_funds_investement.*,
                mutual_funds.scheme_name as fund_name,
                SUM(mutual_funds_investement.investment_amount) OVER () as total_invested_amount,
                SUM(mutual_funds_investement.current_value) OVER () as total_current_value
            FROM account
            LEFT JOIN mutual_funds_investement ON mutual_funds_investement.account_id = account.id
            LEFT JOIN mutual_funds ON mutual_funds_investement.scheme_code = mutual_funds.id
            WHERE account.id = $1
        `;
        const investmentDetailsResult = await pool.query(investmentDetailsQuery, [id]);

        // Extract total sums (if there are any investments)
        let totalInvestedAmount = 0;
        let totalCurrentValue = 0;
        if (investmentDetailsResult.rows.length > 0) {
            totalInvestedAmount = parseFloat(investmentDetailsResult.rows[0].total_invested_amount);
            totalCurrentValue = parseFloat(investmentDetailsResult.rows[0].total_current_value);
        }

        // Return combined details
        return {
            personal_details: personalDetails,
            investment_details: investmentDetailsResult.rows,
            totals: {
                total_invested_amount: totalInvestedAmount,
                total_current_value: totalCurrentValue,
            },
        };
    } catch (error) {
        console.error('Error executing query:', error.stack);
        throw error;
    }
};

module.exports = getUserDetails;
