const { v4: uuidv4 } = require('uuid');
const { pool } = require('../config/dbConfig');
const addNotification = require('../controllers/notification.js/create');
const getUserid = require('../models/user/getUserid');

const handleConnection = (ws, onlineUsers) => {
    const connectionId = uuidv4();
    ws.connectionId = connectionId;
    console.log(`Client connected: ${connectionId}`);

    ws.on('message', async (data) => {
        try {
            let message = Buffer.isBuffer(data) ? data.toString() : data;

            if (typeof message !== 'string') {
                throw new Error('Unexpected message format');
            }

            const userMessage = JSON.parse(message).data;
            console.log(userMessage);

            if (userMessage.event === 'AddNewUser') {
                const { id } = getUserid(userMessage.data);

                if (id) {
                    onlineUsers[id] = ws;
                    console.log(`User added: ${id} with connection ID: ${connectionId}`);
                } else {
                    console.error('Failed to get user ID from token');
                }
            } else {
                console.warn('Unknown event type:', userMessage.event);
            }
        } catch (error) {
            console.error('Error processing message:', error.message);
            ws.send(JSON.stringify({ type: 'error', message: 'Invalid message format' }));
        }
    });

    ws.on('close', () => {
        console.log(`Client disconnected: ${connectionId}`);
        const userId = Object.keys(onlineUsers).find(id => onlineUsers[id].connectionId === connectionId);

        if (userId) {
            delete onlineUsers[userId];
        }
    });

    ws.on('error', (error) => {
        console.error('WebSocket error:', error.message);
    });
};

const goalListener = async (onlineUsers) => {
    const client = await pool.connect();

    client.on('notification', async (msg) => {
        console.log('Received notification:', msg);
        const goalId = msg.payload;

        try {
            const goalData = await client.query('SELECT account_id, name FROM goal WHERE id = $1', [goalId]);
            const goal = goalData.rows[0];

            if (goal) {
                const notification = `Reminder: Goal ${goal.name} needs your attention.`;
                sendNotification(onlineUsers, goal.account_id, notification);
                await addNotification(goal.account_id, notification);
                console.log(`Processed notification for goal_id: ${goalId}`);
            } else {
                console.log(`No goal found with id: ${goalId}`);
            }
        } catch (error) {
            console.error('Error processing notification:', error.message);
        }
    });

    try {
        await client.query('LISTEN goal_reminder_channel');
        console.log('Listening for notifications on goal_reminder_channel');
    } catch (error) {
        console.error('Error starting notification listener:', error.message);
    }

    process.on('SIGINT', async () => {
        await client.end();
        process.exit();
    });
};

const sendNotification = (onlineUsers, userId, notification) => {
    const userSocket = onlineUsers[userId];

    if (userSocket) {
        try {
            userSocket.send(JSON.stringify({ type: 'notification', data: notification }));
        } catch (error) {
            console.error('Error sending notification:', error.message);
        }
    } else {
        console.log(`User with ID ${userId} not found`);
    }
};

module.exports = { handleConnection, goalListener };
