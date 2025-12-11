import e, { Router, Request, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { auth, AuthRequest } from "../middleware/auth";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
const authRouter = Router();

interface SignUpBody {
    name: string,
    email: string,
    password: string
}
interface LogInBody{
    email:string,
    password:string
}


authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        //get request body
        const { name, email, password } = req.body;
        //check if user already exists
        const existingUser = await db
            .select()
            .from(users)
            .where(eq(users.email, email));
        if (existingUser.length){
            res.status(400).json({msg:"User with the same email already exists"});
            return;
        }
        //hashed password
        const hashedPassword = await bcryptjs.hash(password,8);   
        //create a new user and store it in the database

        const newUser:NewUser = {name,email,password:hashedPassword};
      const [user] =  await db.insert(users).values(newUser).returning();
      res.status(201).json(user);                       
    } catch (e: any) {
  console.error("Signup error:", e);
  res.status(500).json({ error: e.message || "Internal server error" });
}
});
authRouter.post("/login", async (req: Request<{}, {}, LogInBody>, res: Response) => {
    try {
        //get request body
        const { email, password } = req.body;
        //check if user already exists
        const [existingUser] = await db
            .select()
            .from(users)
            .where(eq(users.email, email));
        if (!existingUser){
            res.status(400).json({error:"User with the same email doesn't exist"});
            return;
        }
        //hashed password
        const isMatch = await bcryptjs.compare(password,existingUser.password);   
        //create a new user and store it in the database

        if (!isMatch) {
           res.status(400).json({error: "Incorrect password"});
           return;
        }

        const token = jwt.sign({id:existingUser.id},"passwordKey");
     
      res.json({token,...existingUser});                       
    } catch (e: any) {
  console.error("Signup error:", e);
  res.status(500).json({ error: e.message || "Internal server error" });
}
});

authRouter.post("/tokenIsValid",async (req,res)=>{
    try {
        //get header 
        const token = req.header("x-auth-token");
        if (!token ) {
            res.json(false);
            return;
        }
        const verified = jwt.verify( token,"passwordKey");
        if (!verified) {
            res.json(false);
            return;
        }

        //get user data if the token is valid
        const verifiedToken = verified as {id: string};

        const [user] = await db.select().from(users).where(eq(users.id,verifiedToken.id));
        if (!user) {
            res.json(false);
            return;
        }
        res.json(true);   
    } catch (error) {
        res.status(500).json(false)
    }
});

authRouter.get("/", auth, async (req: AuthRequest, res: Response) => {
  try {
    // req.user is set by middleware (id + email)
    if (!req.user) {
      return res.status(401).json({ error: "Unauthorized" });
    }

    // Fetch user from DB
    const [user] = await db.select().from(users).where(eq(users.id, req.user.id));
    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    res.json({...user, token:req.token});
  } catch (error) {
    console.error("Get user error:", error);
    res.status(500).json({ msg: "Internal server error" });
  }
});

export default authRouter;