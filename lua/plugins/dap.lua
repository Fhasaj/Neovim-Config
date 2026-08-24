-- Debugger. Go configs are env-file aware: launching a service loads its
-- local.env exactly like a GoLand run configuration with an EnvFile.
return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  -- Loaded *with* dap, not on their own keymaps: both register dap.listeners at
  -- config time, and a session that starts before they load gets no UI at all.
  dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text" },
  config = function()
    -- `go install` puts dlv in ~/go/bin, which is not on the login PATH.
    local gobin = vim.fn.expand("~/go/bin")
    if not vim.env.PATH:find(gobin, 1, true) then
      vim.env.PATH = gobin .. ":" .. vim.env.PATH
    end

    local dap = require("dap")
    local dotenv = require("util.dotenv")

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignInfo" })

    local map = vim.keymap.set
    map("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue/Start" })
    map("n", "<F9>", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
    map("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
    map("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
    map("n", "<S-F11>", function() dap.step_out() end, { desc = "DAP Step Out" })
    map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
    map("n", "<leader>dB", function()
      vim.ui.input({ prompt = "Breakpoint condition: " }, function(c)
        if c then dap.set_breakpoint(c) end
      end)
    end, { desc = "DAP Conditional Breakpoint" })
    map("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "DAP REPL" })
    map("n", "<leader>dx", function() dap.terminate() end, { desc = "DAP Terminate" })

    local mason = vim.fn.stdpath("data") .. "/mason/packages"

    -- C/C++: codelldb
    local codelldb = mason .. "/codelldb/extension/adapter/codelldb"
    if vim.uv.fs_stat(codelldb) then
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = { command = codelldb, args = { "--port", "${port}" } },
      }
      dap.configurations.cpp = {
        {
          name = "Launch (codelldb)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to exe: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end

    -- JS/TS: js-debug
    local jsdbg = mason .. "/js-debug-adapter"
    if vim.uv.fs_stat(jsdbg) then
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = { command = "node", args = { jsdbg .. "/js-debug/src/dapDebugServer.js", "${port}" } },
      }
      for _, ft in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[ft] = {
          { type = "pwa-node", request = "launch", name = "Launch file", program = "${file}", cwd = "${workspaceFolder}" },
          { type = "pwa-node", request = "attach", name = "Attach", processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
        }
      end
    end

    -- Go: the adapter itself comes from nvim-dap-go (LazyVim go extra).
    -- Everything below only *adds* env-file-aware configurations to it.
    -- Resolved at launch time so it always reads the current service's env file.
    local function env_for_current_buffer()
      local root = dotenv.service_root()
      local path = dotenv.find(root)
      local env = dotenv.merged(root)
      if not path then
        vim.notify(("no env file in %s (looked for %s)"):format(root, table.concat(dotenv.candidates, ", ")), vim.log.levels.WARN)
      else
        vim.notify("debug env: " .. vim.fn.fnamemodify(path, ":~"), vim.log.levels.INFO)
      end
      return env
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        -- Backend/ holds four independent modules and has no go.mod of its own.
        -- dlv runs `go build` in the directory it was *spawned* in -- nvim's cwd --
        -- not in the launch config's `cwd`, so opening nvim at Backend/ makes every
        -- Go config die with "go.mod file not found". Spawn dlv inside the module
        -- that owns the current file instead. Set here, after nvim-dap-go's setup.
        dap.adapters.go = function(callback, config)
          callback({
            type = "server",
            port = "${port}",
            executable = {
              command = vim.fn.exepath("dlv"),
              args = { "dap", "-l", "127.0.0.1:${port}" },
              -- NOTE: `cwd` sits directly on `executable` for server adapters.
              -- Nesting it under `options` (the executable-adapter shape) is ignored.
              cwd = config.cwd and config.cwd ~= "" and config.cwd or dotenv.service_root(),
            },
          })
        end

        dap.configurations.go = dap.configurations.go or {}
        local seen = {}
        for _, c in ipairs(dap.configurations.go) do
          seen[c.name] = true
        end

        local extra = {
          -- The one you want most of the time: runs cmd/server of the service
          -- the current file belongs to, with its env file loaded.
          {
            type = "go",
            name = "Debug service (env file)",
            request = "launch",
            program = function() return dotenv.service_root() .. "/cmd/server" end,
            cwd = function() return dotenv.service_root() end,
            env = env_for_current_buffer,
          },
          {
            type = "go",
            name = "Debug package (env file)",
            request = "launch",
            program = "${fileDirname}",
            cwd = function() return dotenv.service_root() end,
            env = env_for_current_buffer,
          },
          {
            type = "go",
            name = "Debug test (env file)",
            request = "launch",
            mode = "test",
            program = "${fileDirname}",
            env = env_for_current_buffer,
          },
          -- Attach to a service already running in Docker with `dlv --headless`.
          {
            type = "go",
            name = "Attach remote (127.0.0.1:40000)",
            request = "attach",
            mode = "remote",
            port = 40000,
            host = "127.0.0.1",
            substitutePath = { { from = "${workspaceFolder}", to = "/app" } },
          },
        }

        for _, c in ipairs(extra) do
          if not seen[c.name] then
            table.insert(dap.configurations.go, c)
          end
        end
      end,
    })
  end,
}
