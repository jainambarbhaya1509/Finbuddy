const { pool } = require("../../config/dbConfig");
const { redis } = require("../../config/redisServer");

const getUserDetails = async (id) => {
    try {
        // Fetch personal details
        const cacheData=await redis.get(`userDetails:${id}`)
        if(cacheData) return JSON.parse(cacheData);

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

        redis.set(`userDetails:${id}`,JSON.stringify({
            personal_details: personalDetails
        }))

        return {
            personal_details: personalDetails
        };
    } catch (error) {
        console.error('Error executing query:', error.stack);
        throw error;
    }
};

module.exports = getUserDetails;
