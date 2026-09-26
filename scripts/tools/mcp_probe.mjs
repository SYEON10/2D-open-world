import { spawn } from "node:child_process";
import { createInterface } from "node:readline";
import { resolve } from "node:path";

const entryPoint = resolve("tools/mcp/node_modules/@satelliteoflove/godot-mcp/dist/cli.js");
const server = spawn(process.execPath, [entryPoint], {
  cwd: process.cwd(),
  stdio: ["pipe", "pipe", "inherit"],
});

const pending = new Map();
let nextId = 1;
createInterface({ input: server.stdout }).on("line", (line) => {
  let message;
  try {
    message = JSON.parse(line);
  } catch {
    process.stderr.write(`Non-JSON server output: ${line}\n`);
    return;
  }
  if (message.id !== undefined && pending.has(message.id)) {
    const { resolve, reject, timer } = pending.get(message.id);
    clearTimeout(timer);
    pending.delete(message.id);
    if (message.error) reject(new Error(JSON.stringify(message.error)));
    else resolve(message.result);
  }
});

function request(method, params = {}) {
  const id = nextId++;
  const payload = { jsonrpc: "2.0", id, method, params };
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error(`${method} timed out`)), 30000);
    pending.set(id, { resolve, reject, timer });
    server.stdin.write(`${JSON.stringify(payload)}\n`);
  });
}

try {
  const initialized = await request("initialize", {
    protocolVersion: "2025-03-26",
    capabilities: {},
    clientInfo: { name: "godot-project-probe", version: "1.0.0" },
  });
  server.stdin.write(`${JSON.stringify({ jsonrpc: "2.0", method: "notifications/initialized" })}\n`);
  console.log("server:", JSON.stringify(initialized.serverInfo));
  const listed = await request("tools/list");
  const requiredTools = ["godot_scene", "godot_node_read", "godot_node_edit", "godot_resource"];
  for (const name of requiredTools) {
    if (!listed.tools.some((tool) => tool.name === name)) throw new Error(`Missing tool: ${name}`);
  }
  async function call(name, args) {
    const result = await request("tools/call", { name, arguments: args });
    console.log(`${name}: ${JSON.stringify(result).slice(0, 2500)}`);
    if (result.isError) throw new Error(`${name} failed`);
    return result;
  }
  await call("godot_scene", {
    action: "open",
    scene_path: "res://scenes/levels/cube_playground.tscn",
  });
  await call("godot_node_read", { action: "get_scene_tree", max_depth: 2 });
  await call("godot_node_edit", {
    action: "update",
    node_path: "Sun",
    properties: { light_energy: 1.25 },
  });
  await call("godot_scene", { action: "save" });
  await call("godot_node_read", { action: "get_properties", node_path: "Sun" });
  await call("godot_resource", {
    action: "get_info",
    resource_path: "res://assets/generated/cube_checker.res",
  });
} finally {
  server.kill();
}
