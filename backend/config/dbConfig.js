const fs = require('fs')
const { Pool } = require('pg')
const url = require('url')

const pool = new Pool({
    user: process.env.DBUSER,
    password: process.env.DBPASSWORD,
    host: process.env.DBHOST,
    port: process.env.DBPORT,
    database: process.env.DBNAME,
    ssl: {
        rejectUnauthorized: false,
        ca: process.env.DB_CA,
    },
})
const connectdb = async () => {
    try {
        await pool.connect()
        console.log("Database Connected to PostgreSQL")
    }
    catch (error) {
        console.log(error)
    }
}

module.exports = {pool,connectdb}


