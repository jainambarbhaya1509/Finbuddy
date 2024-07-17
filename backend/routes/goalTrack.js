const { Router } = require('express')
const inputAnalyse = require('../controllers/goalTrack/inputAnalyse')
const saveMethod = require('../controllers/goalTrack/investMethod/saving')
const goalTrackRoute=Router()

goalTrackRoute.get('/inputAnalyse/:userInput',inputAnalyse)

//Investement Methods
goalTrackRoute.post('/saveMethod',saveMethod)
module.exports=goalTrackRoute