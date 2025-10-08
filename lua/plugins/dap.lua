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

                        -- Go: delve (dlv)
                        if vim.fn.executable("dlv") == 1 then
                            dap.adapters.go = function(cb, _)
                            local port = 38697
                            local handle
                            handle = vim.loop.spawn("dlv", { args = { "dap", "-l", "127.0.0.1:" .. port }, detached = true }, function(code)
                            handle:close()
                            if code ~= 0 then vim.notify("dlv exited with code " .. code, vim.log.levels.ERROR) end
                                end)
                            vim.defer_fn(function() cb({ type = "server", host = "127.0.0.1", port = port }) end, 100)
                            end
                            dap.configurations.go = { { type = "go", name = "Debug", request = "launch", program = "${file}" } }
                            end
                            end,
}
