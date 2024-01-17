import express from "express";
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import connectToDatabase from "./database";

const app = express();
const connection = connectToDatabase();

app.use(express.json());

app.listen(process.env.LISTEN_PORT);