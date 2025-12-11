import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: "postgresql",
  schema: "./db/schema.ts",
  out: "./drizzle",
  dbCredentials: {
    host: "localhost",          // Docker service name
    port: 5432,
    user: "postgres",
    password: "postgres", // <-- your password here
    database: "mydb",
    ssl:false,
  },
});