const getMutalFundsData  = require("../../../models/investement/mutualFunds/getMutualFunds")
const searchMutualFunds = require("../../../models/investement/mutualFunds/searchMutualF")

const getMutualFunds = async (req, res) => {
    try {
        const mutualName  = req.params.mutualName
        if (mutualName == null) {
            const data=await getMutalFundsData()
            return res.send(data)
        }
        const dataFunds=searchMutualFunds(mutualName)
        if (dataFunds!=null) return res.send("Not found") 

        return res.send(dataFunds)
    } catch (error) {
        console.log(error)
        return res.send(error)
    }
}

module.exports = getMutualFunds