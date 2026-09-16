import concurrently from "concurrently";
import { globSync } from "node:fs";
import { basename, dirname, resolve } from "node:path";
import manifest from "../package.json" with { type: "json" };

const cwd = resolve(import.meta.dirname, "..");
const fix = process.argv.includes("--fix");
const commands = [
    {
        name: "prettier",
        command: `npm exec -- prettier --${fix ? "write" : "check"} --log-level warn .`,
    },
    { name: "tsc", command: "npm exec --workspaces -- tsc --incremental" },
    ...globSync("checks/*/check.mjs", { cwd })
        .sort()
        .map((path) => ({
            name: basename(dirname(path)),
            command: `node ${path}`,
        })),
];
const eslint = globSync(
    manifest.workspaces.map((pattern) => `${pattern}/package.json`),
    { cwd },
)
    .sort()
    .map((path) => ({
        name: `eslint:${dirname(path)}`,
        command: `npm exec -- eslint ${fix ? "--fix " : ""}--max-warnings 0`,
        cwd: resolve(cwd, dirname(path)),
    }));

try {
    await Promise.all([
        concurrently(commands, { cwd }).result,
        concurrently(eslint, { maxProcesses: 4 }).result,
    ]);
} catch {
    process.exitCode = 1;
}
