const fs = require('fs')
const path = require('path')
const yaml = require('yaml')
const { openAi } = require('../../../config/openAIConfig')
const { MAX_TOKENS } = require('../maxToken')

const promptyPath = path.resolve(__dirname, './chat.prompty')
let prompty
const max_tokens=MAX_TOKENS
try {
  const file = fs.readFileSync(promptyPath, 'utf8')
  const documents = yaml.parseAllDocuments(file)
  prompty = documents[0].toJSON() // Assuming there's only one document
} catch (error) {
  console.error('Error reading or parsing chat.prompty file:', error)
  throw error // Throw error to handle it in the caller or logging mechanism
}

const getFinancialAdvice = async (chatInput,data) => { //data->if transaction or anything
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
    content: `${chatInput} and ${data} and currency unit is rupees (INR), also state the reason of your advice in maximum  ${max_tokens} tokens only`
  }

  const messages = [systemMessage, userMessage]

  try {
    const response = await openAi.chat.completions.create({
      messages: messages,
      max_tokens: max_tokens,
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

module.exports = getFinancialAdvice
