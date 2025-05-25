const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Witaj w aplikacji Node.js uruchomionej w Dockerze!');
});

app.listen(port, () => {
    console.log(`Aplikacja działa na http://localhost:${port}`);
});
