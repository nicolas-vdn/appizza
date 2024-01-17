import mysql from "mysql2";

export default function connectToDatabase(){
    const connection = mysql.createConnection({
        host: process.env.SQL_HOST,
        user: process.env.SQL_USER,
        password: process.env.SQL_PASS,
        database: process.env.SQL_DATABASE
    });

    connection.connect(function (err) {
        if (!err) {
            console.log("Database is connected");
        } else {
            console.log("Database is not connected" + err);
        }
    })

    return connection;
}