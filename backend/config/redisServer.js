// redis.js

const Redis = require('ioredis')

const redis = new Redis({
  host: 'localhost',  // Redis server running locally
  port: 6379,         // Default Redis port
})

redis.on('error', (err) => {
  console.error('Redis connection error:', err)
})

module.exports = {redis}
