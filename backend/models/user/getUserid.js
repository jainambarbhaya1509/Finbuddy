const jwt = require('jsonwebtoken')

const tokenSecret = process.env.JWTTOKENSECRET

const getUserid=(token)=>{
    try {
        const decoded = jwt.verify(token, tokenSecret)
        const userId = decoded.id

        return { valid: true, error: null,id:userId }
    } catch (err) {
        if (err.name === 'TokenExpiredError' || err.name === 'JsonWebTokenError') {
            return { valid: false, error: "Session Expired" }
        }
        console.error(err)
        return { valid: false, error: "An error occurred" }
    }

}
module.exports = getUserid
