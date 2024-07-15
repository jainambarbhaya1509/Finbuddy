require('dotenv').config()
const express = require('express')
const cors = require('cors')
const indexRoute = require('./routes/index')
const { default: axios } = require('axios')
const { redis } = require('./config/redisServer')
const { connectdb } = require('./config/dbConfig')

const app = express()
const PORT = 4000

app.use(express.json())
connectdb()
app.use('/api', indexRoute)
app.use(cors({
    origin: '*', // your client origin
    credentials: true
}))

app.listen(PORT, () => {
    console.log(`Running on port ${PORT}`)
})