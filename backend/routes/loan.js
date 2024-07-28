const { Router } = require("express")
const getLoan = require("../controllers/loan/getLoan")
const loanRoute = Router()

loanRoute.get('/getLoan', getLoan)

module.exports = loanRoute
