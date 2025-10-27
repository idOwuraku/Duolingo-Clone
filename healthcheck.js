const http = require('http');

const PORT = process.env.PORT || 3003;
const PATH = process.env.HEALTH_PATH || '/';

const options = {
  host: '127.0.0.1', 
  port: PORT,
  path: PATH,
  timeout: 2000,

  headers: {
    'Host': 'localhost'
  }
};

const req = http.get(options, (res) => {
  console.log(`HEALTHCHECK: Status Code ${res.statusCode}`);
  if (res.statusCode === 200) {
    process.exit(0); 
  } else {
    process.exit(1); 
  }
});

req.on('error', (err) => {
  console.error(`HEALTHCHECK: Error: ${err.message}`);
  process.exit(1); 
});

