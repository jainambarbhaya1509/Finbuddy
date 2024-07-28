const { pool } = require("../../config/dbConfig")
const getnNotifications = require("../../models/notifications/getnotifications")
const getUserid = require("../../models/user/getUserid")

const readNotification = async (req, res) => {
    try {
        const token = req.headers.userauth
        const { id } = getUserid(token)
        data=await getnNotifications(id)
        return res.send(data)
    } catch (error) {
        res.status(500).send("somthing went wrong")
    }
}
module.exports = readNotification