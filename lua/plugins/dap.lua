return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
    local dap = require("dap")

    -- Signs
    vim.fn.sign_define("DapBreakpoint",         { text = "●", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "◌", texthl = "DiagnosticSignWarn"  })
    vim.fn.sign_define("DapStopped",            { text = "▶", texthl = "DiagnosticSignInfo"  })

    -- Keys
    local map = vim.keymap.set
    map("n", "<F5>",    function() dap.continue() end,               { desc = "DAP Continue/Start" })
    map("n", "<F10>",   function() dap.step_over() end,              { desc = "DAP Step Over" })
    map("n", "<F11>",   function() dap.step_into() end,              { desc = "DAP Step Into" })
    map("n", "<S-F11>", function() dap.step_out() end,               { desc = "DAP Step Out" })
    map("n", "<leader>db", function() dap.toggle_breakpoint() end,   { desc = "DAP Toggle Breakpoint" })
    map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP Conditional Breakpoint" })
    map("n", "<leader>dr", function() dap.repl.toggle() end,         { desc = "DAP REPL" })

    -- Adapter roots (Mason)
    local mason = vim.fn.stdpath("data") .. "/mason/packages"

    -- C/C++: codelldb
    do
        local is_win = vim.loop.os_uname().sysname == "Windows_NT"
        local ext = is_win and "exe" or ""
        local base = mason .. "/codelldb/extension/"
        local exe = base .. "adapter/codelldb" .. (ext ~= "" and ".exe" or "")
        if vim.loop.fs_stat(exe) then
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = { command = exe, args = { "--port", "${port}" } },
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
            end

            -- JS/TS: js-debug
            do
                local jsdbg = mason .. "/js-debug-adapter"
                if vim.loop.fs_stat(jsdbg) then
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
                        end

                        -- Go: delve (dlv), plus .env-aware launch configs
                        do
                            -- naive .env parser: KEY=VALUE per line, supports quotes and # comments
                            local function load_dotenv(path)
                                local env = {}
                                local f = io.open(path, "r")
                                if not f then return env end
                                for line in f:lines() do
                                    line = line:match("^%s*(.-)%s*$")
                                    if line ~= "" and not line:match("^#") then
                                        local key, val = line:match("^([%w_]+)=(.*)$")
                                        if key then
                                            val = val:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
                                            env[key] = val
                                        end
                                    end
                                end
                                f:close()
                                return env
                            end

                            -- nearest go.mod/.git to the file being debugged, falling back to cwd
                            local function project_root()
                                local found = vim.fs.find({ "go.mod", ".git" }, {
                                    upward = true,
                                    path = vim.fn.expand("%:p:h"),
                                })
                                if found and found[1] then
                                    return vim.fs.dirname(found[1])
                                end
                                return vim.fn.getcwd()
                            end

                            -- evaluated by nvim-dap at launch time, so it always reads the
                            -- current project's .env instead of a stale, config-load-time one
                            local function env_from_dotenv()
                                local root = project_root()
                                local env = load_dotenv(root .. "/.env")
                                if vim.tbl_isempty(env) then
                                    vim.notify("go debug: no .env found at " .. root .. "/.env", vim.log.levels.WARN)
                                end
                                return env
                            end

                            if vim.fn.executable("dlv") == 1 and not dap.adapters.go then
                                dap.adapters.go = function(cb, _)
                                    local port = 38697
                                    local handle
                                    handle = vim.loop.spawn("dlv", { args = { "dap", "-l", "127.0.0.1:" .. port }, detached = true }, function(code)
                                        handle:close()
                                        if code ~= 0 then vim.notify("dlv exited with code " .. code, vim.log.levels.ERROR) end
                                    end)
                                    vim.defer_fn(function() cb({ type = "server", host = "127.0.0.1", port = port }) end, 100)
                                end
                            end

                            -- Appended on FileType so it also picks up whatever nvim-dap-go's
                            -- own setup (via the LazyVim go extra) already put in this list.
                            if vim.fn.executable("dlv") == 1 then
                                vim.api.nvim_create_autocmd("FileType", {
                                    pattern = "go",
                                    callback = function()
                                        dap.configurations.go = dap.configurations.go or {}
                                        local existing = {}
                                        for _, c in ipairs(dap.configurations.go) do
                                            existing[c.name] = true
                                        end

                                        local envAware = {
                                            {
                                                type = "go", name = "Debug (.env)", request = "launch",
                                                program = "${file}", env = env_from_dotenv,
                                            },
                                            {
                                                type = "go", name = "Debug package (.env)", request = "launch",
                                                program = "${fileDirname}", env = env_from_dotenv,
                                            },
                                            {
                                                type = "go", name = "Debug test (.env)", request = "launch",
                                                mode = "test", program = "${fileDirname}", env = env_from_dotenv,
                                            },
                                        }
                                        for _, c in ipairs(envAware) do
                                            if not existing[c.name] then
                                                table.insert(dap.configurations.go, c)
                                            end
                                        end
                                    end,
                                })
                            end
                        end
                        end,
}
