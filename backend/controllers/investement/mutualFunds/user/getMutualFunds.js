const { getUserMutualFunds } = require("../../../../models/investement/mutualFunds/getUserMutualF")
const getUserid = require("../../../../models/user/getUserid")

const userMutualFunds = async (req, res) => {
    try {
        const { userauth } = req.headers
        const { id } = getUserid(userauth)
        const data = await getUserMutualFunds(id)
        const investmentDetails = data.investment_details.map(row => {
            return {
                ...row,
                id: row.id.toString(),
                account_id: row.account_id.toString(),
                scheme_code: row.scheme_code.toString(),
                investment_date: row.investment_date.toString(),
                purchased_price: row.purchased_price.toString(),
                investment_amount: row.investment_amount.toString(),
                units_purchased: row.units_purchased.toString(),
                current_value: parseFloat(row.current_value),
                total_invested_amount: row.total_invested_amount.toString(),
                total_current_value: row.total_current_value.toString(),
            };
        });
        
        res.send({ investment_details: investmentDetails, totals: data.totals })
    } catch (error) {
        console.log(error);
        res.status(500).send("something went wrong")
    }
}

module.exports = userMutualFunds
