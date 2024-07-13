const { pool } = require("../../../config/dbConfig");
const mutualFundsGpt = require("../../../utils/mutualFundsGpt");

const mutualFundsPrompt = async (req, res) => {
    try {
        const { userInput } = req.params;
        const promptResult = await mutualFundsGpt(userInput);
        const gptResponse = promptResult.choices[0].message.content;

        console.log("GPT Response:", gptResponse);

        let queryData;
        try {
            // Attempt to parse the response as JSON
            const formattedResponse = gptResponse.replace(/'/g, '"');
            queryData = JSON.parse(formattedResponse);

            // Check for the presence of necessary variables
            if (queryData.fund_age_yr && queryData.risk_level && queryData.returns_1yr) {
                let fundAgeRange;
                switch (queryData.fund_age_yr) {
                    case 'long-term':
                        fundAgeRange = [8, 10];
                        break;
                    case 'mid-term':
                        fundAgeRange = [4, 8];
                        break;
                    case 'short-term':
                        fundAgeRange = [1, 4];
                        break;
                    default:
                        return res.status(400).send("Invalid fund_age_yr value");
                }

                // Define tolerance ranges
                const riskTolerance = 1; // Adjust tolerance as needed
                const returnsTolerance = 1; // Adjust tolerance as needed

                const mutualData = await pool.query(
                    `SELECT * FROM mutual_funds 
                     WHERE fund_age_yr BETWEEN $1 AND $2 
                     AND risk_level BETWEEN $3 AND $4 
                     AND returns_1yr BETWEEN $5 AND $6`,
                    [
                        ...fundAgeRange,
                        queryData.risk_level - riskTolerance,
                        queryData.risk_level + riskTolerance,
                        queryData.returns_1yr - returnsTolerance,
                        queryData.returns_1yr + returnsTolerance
                    ]
                );

                return res.json(mutualData.rows); // Send the rows of the query result as JSON
            } else {
                return res.json({ message: gptResponse }); // Pass the GPT response directly
            }
        } catch (parseError) {
            // If parsing fails, it's likely a simple string response
            return res.json({ message: gptResponse });
        }
    } catch (error) {
        console.error("Error:", error);
        res.sendStatus(500);
    }
};

module.exports = mutualFundsPrompt;
