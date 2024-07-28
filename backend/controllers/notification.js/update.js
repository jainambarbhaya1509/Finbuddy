const { pool } = require("../../config/dbConfig")
const getUserid = require("../../utils/userInfo/getUserid")

const updateNotification=async(req,res)=>{
    try {
        const {notificationId}=req.params 
        const notifications=await pool.query('UPADTE notifications SET is_read=$1 WHERE id=$2',[Boolean(true),notificationId])
        return res.send(notifications.rows)
    } catch (error) {
        res.status(500).send("somthing went wrong")
    }
}
module.exports=updateNotification