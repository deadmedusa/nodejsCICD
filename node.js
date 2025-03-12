// Simple Node.js Web App using Express

const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Basic route
app.get('/', (req, res) => {
  res.send('Hello, World!');
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

// Export app for testing or further development
module.exports = app;
