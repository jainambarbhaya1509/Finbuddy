const { pool } = require("../../../config/dbConfig");
const mutualFundsGpt = require("../../../utils/openAi/mutualFundsGpt");

const mutualFundsPrompt = async (req, res) => {
  try {
    const { userInput } = req.params;
    const promptResult = await mutualFundsGpt(userInput);
    const gptResponse = promptResult.choices[0].message.content;


    // Function to extract JSON object from the GPT response
    const extractJson = (text) => {
      const jsonMatch = text.match(/{.*}/);
      if (jsonMatch) {
        return jsonMatch[0].replace(/'/g, '"'); // Convert single quotes to double quotes
      }
      return null;
    };

    // Function to convert string to title case
    const toTitleCase = (str) => {
      return str.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
    };

    let jsonResponse = extractJson(gptResponse);

    if (jsonResponse) {
      try {
        const queryData = JSON.parse(jsonResponse);

        // Check if any value is 0 and return the GPT response directly
        if (queryData.fund_age_yr === 0 && queryData.risk_level === 0 && queryData.returns_1yr === 0) {
          return res.send({ message: gptResponse });
        }

        let params = { fund_age_yr: toTitleCase(queryData.fund_age_yr) };
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

        // Determine risk range
        if (queryData.risk_level >= 0 && queryData.risk_level <= 2) {
          params = { ...params, risk_range: "Low" };
        } else if (queryData.risk_level >= 2 && queryData.risk_level <= 4) {
          params = { ...params, risk_range: "Medium" };
        } else {
          params = { ...params, risk_range: "High" };
        }

        // Determine returns range
        if (queryData.returns_1yr >= 0 && queryData.returns_1yr <= 3) {
          params = { ...params, returns_1yr: "Low" };
        } else if (queryData.returns_1yr >= 4 && queryData.returns_1yr <= 6) {
          params = { ...params, returns_1yr: "Medium" };
        } else {
          params = { ...params, returns_1yr: "High" };
        }

        // Define tolerance ranges
        const riskTolerance = 1; // Adjust tolerance as needed
        const returnsTolerance = 1; // Adjust tolerance as needed

        // Query the database
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

        return res.send({ ...params, mutualData: mutualData.rows });
      } catch (parseError) {
        // If parsing fails, fall through to returning the message directly
        console.error("Failed to parse JSON:", parseError);
      }
    }

    // If the JSON object is irrelevant or not present, return the GPT response directly
    return res.send({ message: "I am an AI tool for mutual funds, please prompt specific to mutual funds" });
  } catch (error) {
    console.error("Error:", error);
    res.sendStatus(500);
  }
};

module.exports = mutualFundsPrompt;
