const getTransactionData = require("../../models/transaction/getTransaction")
const getUserid = require("../../models/user/getUserid")

const getTransaction = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = getUserid(token)
        if (decodeData.error) return res.status(500).send(decodeData.error)

        const data = await getTransactionData(decodeData.id)

        return res.send(data)
    } catch (error) {
        console.log(error)
        res.status(500).send("Something went wrong")
    }
}

module.exports = getTransaction
