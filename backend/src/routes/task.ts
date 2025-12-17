import { Router } from "express";
import { error } from "node:console";
import { AuthRequest } from "../middleware/auth";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taskRouter = Router();

taskRouter.post('/task',async (req: AuthRequest,res)=>{
    try {
        req.body = {...req.body , uid:req.user};
        const newTask: NewTask = req.body;
        const [task] = await db.insert(tasks).values(newTask).returning();
        res.status(201).json(task);
    } catch (e) {
        res.status(500).json({error:e});

    }
});

taskRouter.get("/", async (req: AuthRequest, res) => {
  try {
  const allTasks = await db.select().from(tasks).where(eq(tasks.uid, req.user!.id));

  } catch (e) {
    console.error("Error fetching tasks:", e);
    res.status(500).json({ error: "Internal server error" });
  }
});

taskRouter.delete("/:id", async (req: AuthRequest, res) => {
  try {
  const { taskId } = req.body as { taskId: string };


     await db
      .delete(tasks)
      .where(
        eq(tasks.id, taskId) // task id
      );

    // optional: check ownership
res.json(true);
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});


export default taskRouter;