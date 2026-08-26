-- Run configurations. Each Go service gets build/run/test/tidy tasks that load
-- its env file, plus docker compose tasks for skypin-infra.
return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerRunCmd", "OverseerQuickAction" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task list" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Task quick action" },
    { "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "Run shell command" },
  },
  opts = {
    task_list = { direction = "bottom", min_height = 15, bindings = { ["<C-h>"] = false, ["<C-l>"] = false } },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    local dotenv = require("util.dotenv")
    local ok, services = pcall(dotenv.services)
    if not ok then
      return
    end

    for _, svc in ipairs(services) do
      local defs = {
        {
          suffix = "run",
          label = "run",
          cmd = vim.list_extend({ "go", "run", svc.main }, dotenv.serve_args(svc.dir)),
          env = true,
        },
        { suffix = "build", label = "build", cmd = { "go", "build", "-o", "bin/" .. svc.name, svc.main } },
        { suffix = "test", label = "test", cmd = { "go", "test", "./..." }, env = true },
        { suffix = "vet", label = "vet", cmd = { "go", "vet", "./..." } },
        { suffix = "tidy", label = "mod tidy", cmd = { "go", "mod", "tidy" } },
      }
      for _, d in ipairs(defs) do
        overseer.register_template({
          name = ("%s: %s"):format(svc.name, d.label),
          builder = function()
            return {
              cmd = d.cmd,
              cwd = svc.dir,
              -- Read at build time so edits to local.env take effect on re-run.
              env = d.env and dotenv.load(svc.dir) or nil,
              components = { "default" },
            }
          end,
          condition = {
            callback = function()
              return vim.uv.fs_stat(svc.dir) ~= nil
            end,
          },
        })
      end
    end

    local infra = dotenv.backend_root() .. "/skypin-infra"
    if vim.uv.fs_stat(infra) then
      local compose = {
        { "infra: compose up (dev)", { "docker", "compose", "-f", "docker-compose.dev.yml", "up", "-d" } },
        { "infra: compose up", { "docker", "compose", "up", "-d" } },
        { "infra: compose down", { "docker", "compose", "down" } },
        { "infra: compose ps", { "docker", "compose", "ps" } },
        { "infra: compose logs -f", { "docker", "compose", "logs", "-f", "--tail=200" } },
      }
      for _, c in ipairs(compose) do
        overseer.register_template({
          name = c[1],
          builder = function()
            return { cmd = c[2], cwd = infra, components = { "default" } }
          end,
        })
      end
    end
  end,
}
