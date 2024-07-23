const jwt = require('jsonwebtoken')
const { pool } = require('../../config/dbConfig')
const { comparePassword } = require('../../utils/helper')
const getUserDetails = require('../../utils/getUserData')
const tokenSecret = process.env.JWTTOKENSECRET
const tokenOptions = {
    expiresIn: '24h',
}

const validateCredentials = async (accountNumber, pin) => {
    try {
        const findUser = await pool.query(`
            SELECT account.pin, account.id, customer.first_name, customer.last_name 
            FROM account 
            JOIN customer ON account.customer_id = customer.id 
            WHERE account.account_number = $1`,
            [accountNumber]
        )

        if (findUser.rows.length === 0) {
            return { valid: false, error: "Invalid Credentials" }
        }

        const user = findUser.rows[0]
        const userName = `${user.first_name} ${user.last_name}`

        const isPinValid = comparePassword(`${pin}`, user.pin)
        if (!isPinValid) {
            return { valid: false, error: "Invalid Credentials" }
        }

        return { valid: true, userId: user.id, userName: userName, error: null }
    } catch (error) {
        console.error(error)
        return { valid: false, error: "An error occurred" }
    }
}

const generateToken = (userId) => {
    const tokenPayload = { id: userId }
    return jwt.sign(tokenPayload, tokenSecret, tokenOptions)
}

const createUser = async (req, res) => {
    try {
        const { accountNumber, pin } = req.body
        const { valid, userId, userName, error } = await validateCredentials(accountNumber, pin)

        if (!valid) {
            return res.status(200).send({ valid: false, error: error })
        }

        const token = generateToken(userId)
        const Userdetails = await getUserDetails(userId)
        
        return res.status(200).send({ ...Userdetails, valid: true, token: token, name: userName })
    } catch (error) {
        console.error(error)
        return res.status(500).send({ error: "Something went wrong" })
    }
}

module.exports = createUser
