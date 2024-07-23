require('dotenv').config()
const express = require('express')
const cors = require('cors')
const http = require('http')
const { connectdb } = require('./config/dbConfig')
const indexRoute = require('./routes/index')
const { setupWebSocket } = require('./websocket/index')

const app = express()
const PORT = 4000

// Middleware
app.use(express.json())
app.use(cors({
    origin: '*', // your client origin
    credentials: true
}))

// Connect to database
connectdb()

// API Routes
app.use('/api', indexRoute)

// Create HTTP server
const server = http.createServer(app)

// Setup WebSocket
setupWebSocket(server)

// Start the server
server.listen(PORT, () => {
    console.log(`Running on port ${PORT}`)
})
