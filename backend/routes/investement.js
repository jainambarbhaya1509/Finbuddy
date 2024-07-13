const {Router}=require("express")
const getMutualFunds = require("../controllers/investement/mutualFunds/mutualFunds")
const mutualFundsPrompt = require("../controllers/investement/mutualFunds/mutualFundsPrompt")
const investementRoute=Router()

investementRoute.get('/getAllMutualFunds/:mutualName',getMutualFunds)
investementRoute.get('/getAllMutualFunds',getMutualFunds)
investementRoute.get('/mutualFundsPrompt/:userInput',mutualFundsPrompt)

module.exports=investementRoute
