const http = require('http')
const WebSocket = require('ws')
const { handleConnection, goalListener } = require('./handler')
const setupWebSocket = (server) => {
    const wss = new WebSocket.Server({ server })
    const onlineUsers = {}

    wss.on('connection', (ws) => {
        handleConnection(ws, onlineUsers)
    })

    wss.on('error', (error) => {
        console.error(`WebSocket server error: ${error.message}`)
    })
    goalListener(onlineUsers) // Start listening for goal reminders when the server starts

    return wss
}

module.exports = { setupWebSocket }