const {Router}=require('express')
const chatPrompt = require('../controllers/chatBot/chat')
const TransactionPrompt = require('../controllers/chatBot/transaction')
const loanPrompt = require('../controllers/chatBot/loan')
const chatRoute=Router()

chatRoute.get('/chat/:userInput',chatPrompt)
chatRoute.get('/transaction/:userInput',TransactionPrompt)
chatRoute.get('/loans/:userInput',loanPrompt)

module.exports=chatRoute;