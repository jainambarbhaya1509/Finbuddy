const { getUserLoan } = require("../../models/loan/getUserLoan")
const getUserid = require("../../models/user/getUserid")

const getLoan = async (req, res) => {
    try {
        const token = req.headers.userauth
        const decodeData = getUserid(token)
        if (decodeData.error) return res.status(500).send(decodeData.error)
        
        const data = await getUserLoan(decodeData.id)
        return res.send(data)
    } catch (error) {
        console.log(error);
        return res.status(500).send('Please try again later')
    }
}

module.exports=getLoan