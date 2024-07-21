const GoalTrack = require("../../../../utils/openAi/goalTrack/openAi/goalPrompt")

const inputAnalyse = async (req, res) => {
    try {
        const { userInput } = req.params // Use req.body to get userInput

        if (!userInput) {
            return res.status(400).send({ error: "userInput is required" })
        }

        const gptRes = await GoalTrack(userInput)

        // Extract the JSON part from gptRes
        const jsonString = gptRes.match(/\{[^]*\}/) // Matches the JSON object part

        if (!jsonString) {
            return res.status(200).send({
                "goal_amount": 0,
                "time_frame": 0,
                "goal_name":""
            })
        }

        let responseObject
        try {
            responseObject = JSON.parse(jsonString[0])
        } catch (error) {
            console.error("Error parsing JSON:", error)
            return res.status(500).send({ error: "Error parsing JSON response from GPT" })
        }

        // Ensure goal_amount is a number
        responseObject.goal_amount = parseFloat(responseObject.goal_amount)

        // Send the extracted JSON object as the response
        return res.send(responseObject)

    } catch (error) {
        console.error("Error in inputAnalyse function:", error)
        return res.status(500).send({ error: "An error occurred while processing the request" })
    }
}

module.exports = inputAnalyse
