import "dotenv/config";
import { initDb } from "./models";

const start = async () => {
  await initDb();
  console.log("Backend started");
};

start();