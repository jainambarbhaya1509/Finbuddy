const { Router } = require('express')
const saveMethod = require('../controllers/goalTrack/investMethod/saving')
const addGoal = require('../controllers/goalTrack/crudGoal/createGoal/addGoal')
const inputAnalyse = require('../controllers/goalTrack/crudGoal/createGoal/inputAnalyse')
const updateGoal = require('../controllers/goalTrack/crudGoal/updateGoal')
const getGoalMap = require('../controllers/goalTrack/crudGoal/getGoalMap')
const deleteGoal = require('../controllers/goalTrack/crudGoal/deleteGoal')
const getGoals = require('../controllers/goalTrack/crudGoal/getGoals')
const goalTrackRoute=Router()

//CRUD
goalTrackRoute.get('/inputAnalyse/:userInput',inputAnalyse) //Create
goalTrackRoute.post('/addGoalData',addGoal) //Create
goalTrackRoute.get('/getGoalMap/:goal_id',getGoalMap) //Read
goalTrackRoute.get('/getGoals',getGoals) //Read
goalTrackRoute.post('/UpdateGoal',updateGoal) 
goalTrackRoute.delete('/deleteGoal/:goal_id',deleteGoal) 

//Investement Methods
goalTrackRoute.post('/saveMethod',saveMethod)
module.exports=goalTrackRoute