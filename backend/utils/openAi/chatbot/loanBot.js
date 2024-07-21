const fs = require('fs')
const dotenv = require('dotenv')
const { pool } = require('../../../config/dbConfig')
const { openAi } = require('../../../config/openAIConfig')

dotenv.config()

// Load environment variables
const config = {
    AZURE_CHAT_MODEL: process.env.AZURE_CHAT_MODEL
}

// Function to fetch data from database
const fetchDataFromDatabase = async (userId) => {
    try {
        const { rows } = await pool.query(`
      SELECT * FROM loan_type 
      JOIN loan ON loan_type.id = loan.loan_type_id 
      WHERE loan.account_id = $1`, [userId])
      console.log(rows)
        return rows
    } catch (error) {
        console.error('Error fetching data from database:', error)
        throw error
    }
}

// Example query to OpenAI
const getFinancialAdvice = async (chatInput) => {
    try {
        const response = await openAi.chat.completions.create({
            model: config.AZURE_CHAT_MODEL,
            messages: [{ role: 'user', content: chatInput }],
            max_tokens: 50,
            temperature: 0.2
        })

        if (response.choices && response.choices.length > 0) {
            return response.choices[0].message.content
        } else {
            throw new Error('No valid response received from the API.')
        }
    } catch (error) {
        console.error('Error querying OpenAI:', error)
        throw error
    }
}

const LoanBot = async (userId, userInput) => {
    try {
        const data = await fetchDataFromDatabase(userId)

        const chatInput = `${userInput},also state the reason of your advice, Here is the data of my loan: ${JSON.stringify(data)}`
        const response = await getFinancialAdvice(chatInput)

        return { message: response, error: null }
    } catch (error) {
        console.error('Error:', error)
        return { message: null, error: error }
    }
}

module.exports = LoanBot
