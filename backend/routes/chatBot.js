const {Router}=require('express')
const chatPrompt = require('../controllers/chatBot/chat')
const TransactionPrompt = require('../controllers/chatBot/transaction')
const chatRoute=Router()

chatRoute.get('/chat/:userInput',chatPrompt)
chatRoute.get('/transaction/:userInput',TransactionPrompt)

module.exports=chatRoute;