const dotenv=require('dotenv')
const { AzureOpenAI } = require("openai")

dotenv.config()

//const
const endpoint = process.env.OPENAI_ENDPOINT
const apiKey = process.env.OPENAI_APIKEY
const deployment = process.env.OPENAI_DEPLOYMENT
const apiVersion = process.env.OPENAI_API_VERSION

// Initialize the AzureOpenAI client with the API key
const openAi = new AzureOpenAI({
  endpoint: endpoint,
  apiKey: apiKey,
  deployment: deployment,
  apiVersion: apiVersion,
})
module.exports ={openAi}