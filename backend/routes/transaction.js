const { Router } = require("express")
const getTransaction = require("../controllers/transaction/gettransaction")
const categoriseTransaction = require("../controllers/transaction/categoriseTransaction")
const transactionRoute = Router()

transactionRoute.get('/getTransaction', getTransaction)
transactionRoute.get('/categoriseTransaction', categoriseTransaction)

module.exports = transactionRoute
