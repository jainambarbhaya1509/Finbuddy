const { pool } = require("../../config/dbConfig")
const { updateCache } = require("../../models/notifications/updateNotification")

const deleteNotification=async(req,res)=>{
    try {
        const {notificationId}=req.params 
        const notifications=await pool.query('DELETE FROM notifications WHERE id=$1',[notificationId])
        updateCache();
        return res.send(notifications.rows)
    } catch (error) {
        res.status(500).send("somthing went wrong")
    }
}
module.exports=deleteNotification