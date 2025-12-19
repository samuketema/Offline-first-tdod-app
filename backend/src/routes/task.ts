import { Router } from "express";
import { error } from "node:console";
import { auth, AuthRequest } from "../middleware/auth";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taskRouter = Router();

taskRouter.post("/", auth, async (req: AuthRequest, res) => {
  try {
    if (!req.user) {
      return res.status(401).json({ error: "Unauthorized" });
    }
    req.body = {
      ...req.body,
      uid: req.user.id,
      // ensure dueAt is always a Date object if provided
      dueAt: req.body.dueAt ? new Date(req.body.dueAt) : undefined,
    };

    const newTask: NewTask = req.body;
    console.log("UID SENT TO DB:", newTask.uid);

    const [task] = await db.insert(tasks).values(newTask).returning();
    res.status(201).json(task);
  } catch (e: any) {
    console.error("ERROR:", e);
    return res.status(500).json({ message: e.message });
  }

});

taskRouter.get("/",auth, async (req: AuthRequest, res) => {
  try {
    const allTasks = await db.select().from(tasks).where(eq(tasks.uid, req.user!.id));
    res.json(allTasks);
  } catch (e) {
    console.error("Error fetching tasks:", e);
    res.status(500).json({ error: "Internal server error" });
  }
});

taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
  try {
    const {taskId}: {taskId:string} = req.body; // ✅ UUID string
    if (!taskId) return res.status(400).json({ error: "Invalid task ID" });

    await db.delete(tasks).where(eq(tasks.id, taskId)); // ✅ old-style delete

    res.json(true);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e instanceof Error ? e.message : e });
  }
});


export default taskRouter;