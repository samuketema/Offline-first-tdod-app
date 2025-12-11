import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
  user?: { id: string; email?: string };
  token?: string;
}

export const auth = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ error: "No token provided" });
    }

    // Verify token
    const verifiedToken = jwt.verify(token, "passwordKey") as { id: string; email?: string };
    if (!verifiedToken) {
      return res.status(401).json({ error: "Invalid token" });
    }

    // Check user exists in DB
    const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));
    if (!user) {
      return res.status(401).json({ error: "User not found" });
    }

    // Attach decoded user info to request
    req.user = { id: user.id, email: user.email };
    req.token = token;

    next();
  } catch (error) {
    console.error("Auth error:", error);
    return res.status(401).json({ error: "Token verification failed" });
  }
};