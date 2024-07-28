const fs = require('fs')
const path = require('path')
const yaml = require('yaml')
const { openAi } = require('../../../../config/openAIConfig')

const promptyPath = path.resolve(__dirname, '../../chatbot/chat.prompty')
let prompty
const max_tokens=process.env.MAX_TOKENS_PROMPT
try {
  const file = fs.readFileSync(promptyPath, 'utf8')
  const documents = yaml.parseAllDocuments(file)
  prompty = documents[0].toJSON() // Assuming there's only one document
} catch (error) {
  console.error('Error reading or parsing chat.prompty file:', error)
  throw error // Throw error to handle it in the caller or logging mechanism
}

const getFinancialAdviceOnSavingGoal = async (chatInput) => {
  if (!prompty || !prompty.model || !prompty.model.parameters) {
    console.error('Invalid prompty structure: model or parameters are missing or undefined.')
    return { message: null, error: 'Invalid prompty structure' }
  }

  const systemMessage = {
    role: 'system',
    content: 'You are an AI assistant who acts as a financial advisor' // Manually define or retrieve system response
  }

  const userMessage = {
    role: 'user',
    content:  `I made a plan to achive my goal I want to achive in here is the data of it ${JSON.stringify(chatInput)}, cuurency unit:- ruppes(INR) time_frame unit:- days, is theplan feasible and recommend how to improve the plan give a specific answer in ${max_tokens} words`
  }

  const messages = [systemMessage, userMessage]

  try {
    const response = await openAi.chat.completions.create({
      messages: messages,
      max_tokens: 300,
      temperature: prompty.model.parameters.temperature,
    })
    if ( response.choices && response.choices.length > 0) {
      const generatedMessage = response.choices[0].message
      return { message: generatedMessage.content, error: null }
    } else {
      console.log('No valid response received from the API.')
      return { message: null, error: 'No valid response received' }
    }
  } catch (error) {
    console.error('Error:', error)
    return { message: null, error: error.message }
  }
}

module.exports = getFinancialAdviceOnSavingGoal
