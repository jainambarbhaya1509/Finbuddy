const { pool } = require("../../config/dbConfig")
const getUserid = require("../../utils/getUserid")

const getTransaction = async(req, res) => {
    try {
        console.log(req.headers)
        const token=req.headers.userauth
        console.log(token)
        const decodeData=await getUserid(token)
        console.log(decodeData)
        if(decodeData.error) return res.send(decodeData.error).sendStatus(500)

        const data = await pool.query("SELECT * FROM transaction WHERE account_id=$1",[decodeData.id])
        res.send(data.rows)
    } catch (error) {
        console.log(error)
        res.send("Something went wrong")
    }
}
module.exports=getTransaction