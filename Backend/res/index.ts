import express, { json, query } from "express";
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import connectToDatabase from "./database";
import { validationChamps, formatData } from "./functions";
import { JSONRegister, JSONAuthType } from "./interfaces";
import dotenv from "dotenv";
import { ResultSetHeader, RowDataPacket } from "mysql2";

dotenv.config();

const app = express();
const connection = connectToDatabase();

app.use(express.json());

app.post('/register', (req: Request, res: Response) => {
    let jsonAuth : JSONRegister = req.body;

    if (!validationChamps(jsonAuth)) {
        res.status(400);

        res.json({error: "Incorrect values"});

        return;
    }

    jsonAuth = formatData(jsonAuth);

    const queryEmail = `SELECT email from ${process.env.USER_TABLE}`;

    connection.query<RowDataPacket[]>(queryEmail, (_err, rows) => {
        if (_err) throw _err;

        let jsonToSend : JSONAuthType = Object.assign(jsonAuth);

        let exists : boolean = false;

        rows.forEach(element => {
            exists = element.email == jsonAuth.email;
        })

        if (exists) {
            res.status(400);

            res.json({error: "Email already exists"});

            return;
        }

        jsonToSend.salt = bcrypt.genSaltSync(10);
        jsonToSend.password = bcrypt.hashSync(jsonAuth.password, jsonToSend.salt);
    
        jsonToSend.authToken = jwt.sign({name: jsonToSend.name}, process.env.SECRET_AUTH_KEY as string);

        const queryInsert = `INSERT INTO ${process.env.USER_TABLE} (name, password, email, salt, authToken) VALUES (?, ?, ?, ?, ?)`;

        connection.query<ResultSetHeader>(queryInsert, Object.values(jsonToSend), (_err, result) => {
            if (_err) throw _err;

            if (result) {
                res.status(200);
                res.json({"authToken": jsonToSend.authToken});
            }
        })
    })
})

app.listen(process.env.PORT);