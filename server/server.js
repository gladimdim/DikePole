const express = require("express");

const app = express();

app.post("/api/login", (req, res) => {
    res.send(JSON.stringify({ message: "authorized" }));
});

app.listen(3000, () => {
    console.log(`App started on port 3000`);
})