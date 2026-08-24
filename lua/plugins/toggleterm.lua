-- Terminal. Also provides the "just run the service with its env file" path,
-- which is the plain `go run` equivalent of GoLand's green Run button (as
-- opposed to <leader>or, which runs it as a managed task with an output pane).
local function run_service(pick)
  local dotenv = require("util.dotenv")

  local function launch(svc)
    local args = table.concat(dotenv.serve_args(svc.dir), " ")
    local cmd = ("go run %s%s"):format(svc.main, args ~= "" and (" " .. args) or "")
    local envfile = dotenv.find(svc.dir)
    vim.notify(
      ("%s: %s\nenv: %s"):format(svc.name, cmd, envfile and vim.fn.fnamemodify(envfile, ":~") or "none"),
      vim.log.levels.INFO
    )
    -- clear_env stays false, so these layer over the inherited environment.
    require("toggleterm.terminal").Terminal
      :new({
        cmd = cmd,
        dir = svc.dir,
        env = dotenv.load(svc.dir),
        direction = "float",
        close_on_exit = false,
        display_name = svc.name,
      })
      :toggle()
  end

  if pick then
    local services = dotenv.services()
    vim.ui.select(services, {
      prompt = "Run service",
      format_item = function(s)
        return ("%-14s %s"):format(s.name, s.env_file and vim.fn.fnamemodify(s.env_file, ":t") or "no env file")
      end,
    }, function(choice)
      if choice then launch(choice) end
    end)
  else
    local dir = dotenv.service_root()
    launch({
      name = vim.fn.fnamemodify(dir, ":t"),
      dir = dir,
      main = vim.uv.fs_stat(dir .. "/cmd/server") and "./cmd/server" or "./...",
    })
  end
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  keys = {
    { "<leader>Gr", function() run_service(false) end, desc = "Run current service (env file)" },
    { "<leader>GR", function() run_service(true) end, desc = "Run a service…(pick)" },
  },
  opts = {
    size = 15,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = { border = "curved", winblend = 0 },
  },
}
