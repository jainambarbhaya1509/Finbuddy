const Redis = require('ioredis');

const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT, // Use port 6380 for SSL
  password: process.env.REDIS_PASSWORD,
  tls: {} // Ensure TLS/SSL is used for the connection
});

redis.on('connect', function() {
  console.log('Connected to Redis');
});

// Handle connection errors
redis.on('error', function(err) {
  console.error('Redis error: ' + err);
});

module.exports = { redis };
