const { pool } = require("../../config/dbConfig")
const {updatenNotificationsCache} = require("../../models/notifications/updateNotification")

const updateNotification=async(req,res)=>{
    try {
        const {notificationId}=req.params 
        updatenNotificationsCache(notificationId)
        return res.status(200)
    } catch (error) {
        res.status(500).send("somthing went wrong")
    }
}
module.exports=updateNotification