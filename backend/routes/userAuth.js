const createUser = require('../controllers/auth/createUser')
const validateUser = require('../controllers/auth/validateUser')

const Router=require('express').Router
const authRoute=Router()

authRoute.post('/createUser',createUser)
authRoute.post('/validateUser',validateUser)

module.exports=authRoute