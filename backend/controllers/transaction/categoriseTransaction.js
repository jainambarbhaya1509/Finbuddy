const categoriseTransactionData = require("../../models/transaction/categoryTransaction")
const getUserid = require("../../models/user/getUserid")

const categoriseTransaction = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = getUserid(token)
        data=await categoriseTransactionData(decodeData.id)
        return res.send(data)
    } catch (error) {
        console.log(error)
        res.status(500).send("Something went wrong")
    }
}

module.exports = categoriseTransaction
