# skypin Backend in Neovim — GoLand equivalents

Leader is `<Space>`. `<leader>g` = git, `<leader>G` = Go, `<leader>d` = debug, `<leader>o` = tasks.

## Code intelligence (gopls)
| GoLand | Neovim |
|---|---|
| Go to declaration | `gd` |
| Go to implementation / type | `gI` / `gy` |
| Find usages | `gr` |
| Quick documentation | `K` |
| Rename | `<leader>cr` |
| Show intentions / quick-fix | `<leader>ca` |
| Reformat + optimize imports | on save (conform + gopls) |
| Problems view | `<leader>xx` (Trouble) |
| Type hints toggle | `<leader>uh` |

## Go code generation (`<leader>G`)
`Gi` imports · `Gs` fill struct · `Gw` fill switch · `Ge` insert `if err != nil`
`Gt`/`GT` add/remove struct tags · `Gm` implement interface · `Ga` alternate test↔impl
`Gc` coverage · `Gg` go generate · `Gd` go doc

## Run / Build (`<leader>o`) — GoLand Run Configurations
`<leader>or` pick a task · `<leader>ot` task list · `<leader>oq` action on a task (restart/stop/output)

Tasks are generated per service and **inject that service's env file automatically**
(`local.env`, else `.env.local`, else `.env`):

    auth-svc: run | build | test | vet | mod tidy
    flight-svc: ...   notify-svc: ...   timeline-svc: ...
    infra: compose up (dev) | up | down | ps | logs -f

Re-running a task re-reads the env file, so edits to `local.env` take effect immediately.

## Debug (`<leader>d` / F-keys) — GoLand Debugger
`<F5>` start/continue · `<F9>`/`<leader>db` breakpoint · `<leader>dB` conditional
`<F10>` step over · `<F11>` step into · `<S-F11>` step out
`<leader>du` toggle debug UI · `<leader>de` evaluate (also in visual mode)
`<leader>dr` REPL · `<leader>dx` terminate

Pick these configurations at `<F5>`:
- **Debug service (env file)** — runs `cmd/server` of the service owning the current
  file, with its env file loaded. This is the everyday one.
- **Debug package (env file)** / **Debug test (env file)**
- **Attach remote (127.0.0.1:40000)** — for a container started with
  `dlv --headless --listen=:40000 --api-version=2 exec /app/server`

Variable values appear inline next to the code.

## Removed
The dadbod database/Redis integration that used to live under `<leader>D` was
dropped in the 2026-08 config rebuild. `lua/util/dotenv.lua` still parses
`DATABASE_URL` / `REDIS_URL`, so it can be re-added from the `linux` branch.
