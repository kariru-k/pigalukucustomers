const functions = require('firebase-functions');
const express = require('express');

const app = express()

app.get("/", (req: any, resp: any) => {
    resp.status(200).json(
        {
            greeting: "Hiii",
            message: "Helloo"
        }
    )
});
app.get("/test", (req: any, resp: any) => {
    resp.status(200).json(
        {
            status: "Live",
            message: "Helloo"
        }
    )
});
export const helloWorld = functions.https.onRequest(app);





