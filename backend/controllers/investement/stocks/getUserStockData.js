const getStock = require("../../../models/investement/stock/getUserStock")
const getUserid = require("../../../models/user/getUserid")

const getUserStock=async(req,res)=>{
    try {
        const {userauth}=req.headers
        const {id}=getUserid(userauth)
        const data=await getStock(id)
        res.send(data)
    } catch (error) {
    res.status(500).send("Something went wrong")        
    }
}
module.exports=getUserStock