const { openAi } = require("../../../../config/openAIConfig")

const GoalTrack = async (prompt) => {
  try {
    const result = await openAi.chat.completions.create({
      model: "gpt-4",
      messages: [
        {
          "role": "system",
          "content": `
          Your objective is to intelligently convert natural language queries of users into three variables: goal_name (the name of the goal), goal_amount (the amount they need), time_frame (the duration to gather this much amount).
          
          Output the following JSON format strictly based on relevant queries:
          {
            "goal_name": "<string>",
            "goal_amount": <integer>,
            "time_frame": <integer>
          }
          
          When handling irrelevant queries, unclear requests, or random words like "hey" or "hi", the response should strictly be {"goal_name":"", "goal_amount": 0, "time_frame": 0} in JSON format. No additional text or information should be included, even if there is insufficient data or any other condition applies.`
        },
        // Training examples
        { "role": "user", "content": "I'm looking to buy a car of 20,00,000 in next two years" },
        { "role": "assistant", "content": '{"goal_name": "buy a car", "goal_amount": 2000000, "time_frame": 730}' },

        { "role": "user", "content": "I want to buy a home for 20000000 in the next two years" },
        { "role": "assistant", "content": '{"goal_name": "buy a home", "goal_amount": 20000000, "time_frame": 730}' },

        { "role": "user", "content": "I need to save 500000 in 5 years" },
        { "role": "assistant", "content": '{"goal_name": "save money", "goal_amount": 500000, "time_frame": 1825}' },

        { "role": "user", "content": "I want to go on a vacation costing 300000 in 1 year" },
        { "role": "assistant", "content": '{"goal_name": "go on a vacation", "goal_amount": 300000, "time_frame": 365}' },

        { "role": "user", "content": "I want to buy a bike worth 150000 in 6 months" },
        { "role": "assistant", "content": '{"goal_name": "buy a bike", "goal_amount": 150000, "time_frame": 180}' },

        { "role": "user", "content": "I need 100000 for my wedding in 1 year" },
        { "role": "assistant", "content": '{"goal_name": "wedding expenses", "goal_amount": 100000, "time_frame": 365}' },

        { "role": "user", "content": "I am planning to invest 250000 in 3 years" },
        { "role": "assistant", "content": '{"goal_name": "investment", "goal_amount": 250000, "time_frame": 1095}' },

        { "role": "user", "content": "I want to buy new furniture costing 50000 in 6 months" },
        { "role": "assistant", "content": '{"goal_name": "buy new furniture", "goal_amount": 50000, "time_frame": 180}' },

        // Handle irrelevant queries explicitly
        { "role": "user", "content": "hey" },
        { "role": "assistant", "content": '{"goal_name": "", "goal_amount": 0, "time_frame": 0}' },

        { "role": "user", "content": "hi" },
        { "role": "assistant", "content": '{"goal_name": "", "goal_amount": 0, "time_frame": 0}' },

        // Dynamic user prompt
        { "role": "user", "content": prompt }
      ],
      max_tokens: 50
    })

    return result.choices[0].message.content
  } catch (error) {
    console.error("Error creating chat completion:", error)
    return {
      goal_name: "",
      goal_amount: 0,
      time_frame: 0
    }
  }
}

module.exports = GoalTrack
