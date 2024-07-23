const {Router}=require('express')
const readNotification = require('../controllers/notification.js/read')
const updateNotification = require('../controllers/notification.js/update')
const deleteNotification = require('../controllers/notification.js/delete')
const notificationRoute=Router()

notificationRoute.get('/read',readNotification)
notificationRoute.get('/update/:notificationId',updateNotification)
notificationRoute.get('/delete/:notificationId',deleteNotification)

module.exports=notificationRoute