const {Router}=require("express")
const getMutualFunds = require("../controllers/investement/mutualFunds/mutualFunds")
const mutualFundsPrompt = require("../controllers/investement/mutualFunds/mutualFundsPrompt")
const userMutualFunds = require("../controllers/investement/mutualFunds/user/getMutualFunds")
const investementRoute=Router()

investementRoute.get('/getAllMutualFunds/:mutualName',getMutualFunds)
investementRoute.get('/getAllMutualFunds',getMutualFunds)
investementRoute.get('/mutualFundsPrompt/:userInput',mutualFundsPrompt)
investementRoute.get('/getUserMutualFunds',userMutualFunds)

module.exports=investementRoute
