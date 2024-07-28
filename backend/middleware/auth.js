const jwt = require('jsonwebtoken')

const tokenSecret = process.env.JWTTOKENSECRET
const options = {
    expiresIn: '24h',
}

const validateCredentials = async (token) => {
    try {
        const decoded = jwt.verify(token, tokenSecret)
        const userId = decoded.id

        return { valid: true, error: null }
    } catch (err) {
        if (err.name === 'TokenExpiredError' || err.name === 'JsonWebTokenError') {
            return { valid: false, error: "Session Expired" }
        }
        console.error(err)
        return { valid: false, error: "An error occurred" }
    }
}

const validateUserMiddleware = async (req, res, next) => {
    try {
        if(req.headers.userauth==undefined) console.log(`Userauth:  ${req.headers.userauth}`)
        const token = req.headers.userauth
        if (!token) return res.send({ valid: false, error: "NO token found" })
        const { valid, error } = await validateCredentials(token)
        if (valid == false) {
            console.log("valid failed")
            return res.status(200).send({ valid: valid, error: error })
        }
        next()
    } catch (error) {
        console.log(error)
        return res.status(500).send({ error: "something went wrong" })
    }
}

module.exports = validateUserMiddleware
