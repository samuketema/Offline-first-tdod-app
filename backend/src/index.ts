import express   from "express";
import cors from 'cors';
import authRouter from "./routes/auth";
const app = express();

app.use(cors());
app.use(express.json());
app.use("/auth",authRouter);



app.get('/' ,(req,res)=>{
    res.send("Our application is RUNNING SMOOTHLY");
});


app.listen(8000,()=>{
    console.log(`Server running on port 8000`);

})