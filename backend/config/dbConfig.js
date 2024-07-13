const fs = require('fs');
const { Pool } = require('pg');
const url = require('url');

const pool = new Pool({
    user: process.env.DBUSER,
    password: process.env.DBPASSWORD,
    host: process.env.DBHOST,
    port: process.env.DBPORT,
    database: process.env.DBNAME,
    ssl: {
        rejectUnauthorized: true,
        ca: `-----BEGIN CERTIFICATE-----
MIIEQTCCAqmgAwIBAgIUCWcQ7extnp9ELgWmCGmCPQNrYLAwDQYJKoZIhvcNAQEM
BQAwOjE4MDYGA1UEAwwvZGI5NTU5MTQtNTIxYy00M2NkLWIxYzQtZDBlMjAzYzM3
YTY2IFByb2plY3QgQ0EwHhcNMjQwNzExMDczMjI1WhcNMzQwNzA5MDczMjI1WjA6
MTgwNgYDVQQDDC9kYjk1NTkxNC01MjFjLTQzY2QtYjFjNC1kMGUyMDNjMzdhNjYg
UHJvamVjdCBDQTCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBAMtJpHjv
k211a2ONxjXUQ3dDIHdYdt0IpHCHMOpaWWA2U4Mm7QMSAYpKOoTu6cSHlK+R07r2
dGB5K6Q9ZAXmZ8q47L4WHqtXlJsY1eOy3d39/8Qc7Eq2/07SP74UxYyd0Uz0Kluu
6Ndv8flOyv1pv+L50LYd1cRzcO6jyhSgthBin29F+yhp63bY+6YPZsUIREVN6DzH
LyjBvvlfidhxvxoCBBgozqWWMIu+PTXzf6aOlzoEosHHNCbaPa9F/zd7B6tiAtSR
WMGrSz4MdIgXbXXlmztEWvvzcDblu2KP+M5fHr25M7e7TIumd1w61J4qX6vWHDJp
GjKhBOdiYBFxOwQTr6PbE0LV8RRU0gDJdAxZx0JGwf6PW+G1jUfOUtbX+4fR2S+k
16G81bS1QIPpRix/0mwmNPV2+AYp30g6ppErai0LslUTyS+gSjnglQ2lLL31y0V5
vdnVq36dFx5xPTy4mfftVRBPUqX1Y0CyPHdp6p9+DfS+fsPMg84vYnLKDwIDAQAB
oz8wPTAdBgNVHQ4EFgQUscLFxQPzMUPiFuG3SCTR5JUV6OswDwYDVR0TBAgwBgEB
/wIBADALBgNVHQ8EBAMCAQYwDQYJKoZIhvcNAQEMBQADggGBAAk37LUKBmES1tNv
V6JC7P9gf821SnK61xwGCeRPQPtVjQHw3Ytoig52k0aAy0iChu7kZut0DHzfyxlq
ebkjhMZdk/m4YN26SLMlkwMsCO8N8YnepShjO+s7rO6FXqtGIiVKVGmBgmJNJ+UE
GRZT0pJlTUjxReOAHmGa67bnaOkPCKL/gVkCcC103NReNGiHmLVxPRzsqqG5JxkL
QfHfK5TqhMtGWDsi9/WsL+QqHTGmtev7RFaXj95TWom4fWk/UXv8AfDsUu2WxSRD
U7S8oJwDY4jRLkqAN7LDKA8IObJEdLiHCSaRifPNurhSKwgN2xO28KceYYyUsTIO
eFZrrReXIf5UE6gtHEFo0yGjaHYISwj3nO7OElj+Cj9R4HUMveVMUZ1Az8zdkjlW
lZsR6Wn79pEWiyGLcUgfLMhH5tZnqVqGtTxzEBRbyoqDBkcRNemlaWC3cobhlZZk
n0B2qqdwGxX7FTja/Bv3vOAeGCDuVhkHlzaZIiUXEW4bFe9MBg==
-----END CERTIFICATE-----`,
    },
})
const connectdb = async () => {
    try {
        await pool.connect();
        console.log("Database Connected to PostgreSQL");
    }
    catch (error) {
        console.log(error)
    }
}

module.exports = {pool,connectdb}


