const express = require('express');
const app = express();
const port = $PORT;

app.get('/', (req, res) => {
  res.json({ date: new Date().toISOString() });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://localhost:${port}/`);
});
