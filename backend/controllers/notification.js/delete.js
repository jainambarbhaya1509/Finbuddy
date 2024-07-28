const { pool } = require("../../config/dbConfig")
const getUserid = require("../../utils/userInfo/getUserid")

const deleteNotification=async(req,res)=>{
    try {
        const {notificationId}=req.params 
        const notifications=await pool.query('DELETE FROM notifications WHERE id=$1',[notificationId])
        return res.send(notifications.rows)
    } catch (error) {
        res.status(500).send("somthing went wrong")
    }
}
module.exports=deleteNotification