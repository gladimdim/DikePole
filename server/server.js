const express = require("express");
const bodyParser = require('body-parser');
const dbBridge = require("../src/Db.bs");
const sqlite = require('sqlite');
const dbPromise = sqlite.open("dev.db", { Promise }).then(db => {
    return db.migrate();
});

const app = express();
app.use(bodyParser.json());
app.post("/api/login", async (req, res) => {
    const token = req.body.token;
    const db = await dbPromise;
    const { count } = await db.get(dbBridge.userExists(req.body.id));
    console.log(count, token);
    if (count === 1) {
        res.send(JSON.stringify({
            message: "user_exist",
            details: `User with id ${req.body.id} already exists. Authorized.`
        }));
    } else {
        const createString = dbBridge.createUser(req.body.id, req.body.token);
        console.log(`result insret: ${createString}`);
        const result = await db.all(dbBridge.createUser(req.body.id, req.body.token));
        console.log(result);
        res.send(JSON.stringify({
            message: "user_created",
            details: `User with id ${req.body.id} was created.`
        }))
    }
})

const port = 3000;
app.listen(port, () => {
    console.log(`App started on port ${port}`);
})