const bcrypt=require('bcrypt')

const saltRound=10 //number of rounds you want to encrypt higher number = high complexity 

const hashPassword=(password)=>{
    const salt=bcrypt.genSaltSync(saltRound) 
    return bcrypt.hashSync(password,salt)
}
const comparePassword=(plainPassword,hashPassword)=>{
    return bcrypt.compareSync(plainPassword,hashPassword) //to check at login either password is correct not
}
module.exports={hashPassword,comparePassword}