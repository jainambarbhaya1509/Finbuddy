const express=require('express')
const indexRoute= express.Router()
//Internal Imports
const authRoute = require('./userAuth')
const investementRoute = require('./investement')
const transactionRoute = require('./transaction')

indexRoute.use('/auth',authRoute)
indexRoute
indexRoute.use('/investement',investementRoute)
indexRoute.use('/transaction',transactionRoute)

module.exports=indexRoute