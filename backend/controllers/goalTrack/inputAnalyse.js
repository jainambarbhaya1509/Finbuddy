const GoalTrack = require("../../utils/openAi/goalTrack/goalTracking");

const inputAnalyse = async (req, res) => {
    try {
        const { userInput } = req.params;
        const gptRes = await GoalTrack(userInput);

        // Extract the JSON part from gptRes
        const jsonString = gptRes.match(/\{.*\}/); // Matches the JSON object part

        if (!jsonString) {
            return res.status(200).send({
                "goal_amount": 0,
                "time_frame": 0
            });
        }

        const responseObject = JSON.parse(jsonString[0]);

        // Send the extracted JSON object as the response
        return res.send(responseObject);
        
    } catch (error) {
        console.error("Error in inputAnalyse function:", error);
        return res.status(500).send({ error: "An error occurred while processing the request" });
    }
}

module.exports = inputAnalyse;
