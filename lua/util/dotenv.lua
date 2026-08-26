-- Shared .env handling for the skypin backend (GoLand "EnvFile" equivalent).
-- Used by nvim-dap (debug), overseer (run/build) and dadbod (db/redis).
local M = {}

-- Checked in order; first hit wins. skypin services use `local.env`.
M.candidates = { "local.env", ".env.local", ".env" }

-- Directory of the Go module owning `path` (defaults to the current buffer).
function M.service_root(path)
  local start = path or vim.fn.expand("%:p:h")
  if start == "" then
    start = vim.fn.getcwd()
  end
  local found = vim.fs.find({ "go.mod" }, { upward = true, path = start })
  return found[1] and vim.fs.dirname(found[1]) or vim.fn.getcwd()
end

-- Absolute path of the env file for a module dir, or nil.
function M.find(dir)
  dir = dir or M.service_root()
  for _, name in ipairs(M.candidates) do
    local p = dir .. "/" .. name
    if vim.uv.fs_stat(p) then
      return p
    end
  end
  return nil
end

-- Parse KEY=VALUE. Mirrors godotenv: double-quoted values get \n / \t / \\
-- unescaped (APPLE_PRIVATE_KEY relies on this), single-quoted stay literal.
function M.parse(path)
  local env = {}
  local f = io.open(path, "r")
  if not f then
    return env
  end
  for line in f:lines() do
    line = line:match("^%s*(.-)%s*$")
    if line ~= "" and not line:match("^#") then
      line = line:gsub("^export%s+", "")
      local key, val = line:match("^([%w_.]+)%s*=%s*(.*)$")
      if key then
        local dq = val:match('^"(.*)"$')
        local sq = val:match("^'(.*)'$")
        if dq then
          val = dq:gsub("\\n", "\n"):gsub("\\t", "\t"):gsub("\\\\", "\\")
        elseif sq then
          val = sq
        else
          val = val:gsub("%s+#.*$", "") -- trailing comment on bare values only
        end
        env[key] = val
      end
    end
  end
  f:close()
  return env
end

-- Env table for a module dir; {} when there is no env file.
function M.load(dir)
  local path = M.find(dir)
  return path and M.parse(path) or {}, path
end

-- Env file values layered *over* the inherited environment, the way GoLand's
-- EnvFile plugin behaves. Required for dap: dlv builds the binary with the
-- launch environment, so dropping HOME/GOMODCACHE/PATH breaks `go build`
-- before the debugger ever starts.
function M.merged(dir)
  local env = vim.fn.environ()
  for k, v in pairs(M.load(dir)) do
    env[k] = v
  end
  return env
end

-- These services are cobra CLIs: the bare binary prints help and exits 0.
-- Detect a `serve` subcommand so run/debug actually start the server rather
-- than looking like the debugger silently did nothing.
function M.serve_args(dir)
  local cmd = dir .. "/cmd/server"
  if not vim.uv.fs_stat(cmd) then
    return {}
  end
  for name, t in vim.fs.dir(cmd) do
    if t == "file" and name:match("%.go$") then
      local f = io.open(cmd .. "/" .. name, "r")
      if f then
        local body = f:read("*a")
        f:close()
        if body:match('Use:%s*"serve"') then
          return { "serve" }
        end
      end
    end
  end
  return {}
end

-- valkey-cli and dadbod's redis adapter reject `redis://:pass@host` -- the empty
-- username is sent literally and the server answers WRONGPASS. go-redis accepts
-- it, which is why the services connect but the CLI/GUI do not. Name the user.
function M.normalize_redis_url(url)
  if not url or url == "" then
    return url
  end
  return (url:gsub("^(rediss?://):", "%1default:"))
end

-- Backend root = the directory holding the service checkouts.
function M.backend_root()
  local marker = vim.fs.find({ "skypin-infra" }, { upward = true, path = vim.fn.getcwd(), type = "directory" })
  if marker[1] then
    return vim.fs.dirname(marker[1])
  end
  return vim.fs.dirname(M.service_root())
end

-- All Go services: { name, dir, main, env_file }
function M.services()
  local root = M.backend_root()
  local out = {}
  for name, t in vim.fs.dir(root) do
    if t == "directory" and vim.uv.fs_stat(root .. "/" .. name .. "/go.mod") then
      local dir = root .. "/" .. name
      local main = vim.uv.fs_stat(dir .. "/cmd/server") and "./cmd/server" or "./..."
      table.insert(out, { name = name, dir = dir, main = main, env_file = M.find(dir) })
    end
  end
  table.sort(out, function(a, b)
    return a.name < b.name
  end)
  return out
end

return M
