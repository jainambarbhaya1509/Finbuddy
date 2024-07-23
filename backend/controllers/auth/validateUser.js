const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const { pool } = require('../../config/dbConfig')
const { comparePassword } = require('../../utils/helper')
const getUserDetails = require('../../utils/getUserData')
const getUserid = require('../../utils/getUserid')

const tokenSecret = process.env.JWTTOKENSECRET
const options = {
    expiresIn: '24h',
}

const validateCredentials = async (token, pin) => {
    try {
        const decoded = jwt.verify(token, tokenSecret)
        const userId = decoded.id

        const findUser = await pool.query("SELECT pin,account_number FROM account WHERE id=$1", [userId])

        if (findUser.rows.length === 0) {
            return { valid: false, error: "Invalid Credentials" }
        }

        const userPin = findUser.rows[0].pin
        const isPasswordValid = comparePassword(`${pin}`, userPin) //pass pin as string

        if (isPasswordValid == false) {
            return { valid: false, error: "Invalid Credentials" }
        }

        return { valid: true, error: null }
    } catch (err) {
        if (err.name === 'TokenExpiredError' || err.name === 'JsonWebTokenError') {
            return { valid: false, error: "Session Expired" }
        }
        console.error(err)
        return { valid: false, error: "An error occurred" }
    }
}

const validateUser = async (req, res) => {
    try {
        const { token, pin } = req.body
        const { valid, error } = await validateCredentials(token, pin)

        if (!valid) {
            return res.status(200).send({ valid: false, error: error })
        }
        const { id } = getUserid(token)
        const Userdetails = await getUserDetails(id)
        return res.status(200).send({ ...Userdetails, valid: true, name: `${Userdetails.personal_details.first_name} ${Userdetails.personal_details.last_name}` })
    } catch (error) {
        console.error(error)
        return res.status(500).send({ error: "Something went wrong" })
    }
}

module.exports = validateUser
