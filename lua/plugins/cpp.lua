
vim.g.completion_engine = vim.g.completion_engine or "blink"

local uname = vim.loop.os_uname()
local is_win = (vim.fn.has("win32") == 1) or (uname.sysname or ""):match("Windows")
local is_wsl = (vim.fn.has("wsl") == 1)

local function clangd_cmd()
local cmd = {
    "clangd",
    "--header-insertion=never",
    "--clang-tidy",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=LLVM",
}
if is_win and not is_wsl then
    table.insert(cmd, "--compile-commands-dir=build")
    table.insert(cmd, "--query-driver=" .. table.concat({
        "C:/Program Files/Microsoft Visual Studio/*/*/VC/Tools/MSVC/*/bin/Hostx64/x64/*",
        "C:/msys64/mingw64/bin/*",
        "C:/Program Files/LLVM/bin/*",
    }, ";"))
    else
        table.insert(cmd, "--query-driver=" .. table.concat({
            "/usr/bin/clang*",
            "/usr/local/bin/clang*",
            "/usr/bin/gcc*",
            "/usr/bin/g++*",
        }, ";"))
        end
        return cmd
        end

        -- Build LSP capabilities depending on the selected completion engine
        local function lsp_capabilities()
        local c = vim.lsp.protocol.make_client_capabilities()
        c.offsetEncoding = { "utf-16" } -- clangd prefers this

        if vim.g.completion_engine == "cmp" then
            local ok, cmp = pcall(require, "cmp_nvim_lsp")
            if ok and cmp and cmp.default_capabilities then
                c = cmp.default_capabilities(c)
                end
                elseif vim.g.completion_engine == "blink" then
                    local ok, blink = pcall(require, "blink.cmp")
                    if ok and blink and blink.get_lsp_capabilities then
                        c = vim.tbl_deep_extend("force", c, blink.get_lsp_capabilities())
                        end
                        end
                        return c
                        end

                        return {
                            -- ---------- Toolchain via Mason ----------
                            {
                                "williamboman/mason.nvim",
                                opts = function(_, opts)
                                opts.ensure_installed = opts.ensure_installed or {}
                                vim.list_extend(opts.ensure_installed, {
                                    "clangd",
                                    "clang-format",
                                    "codelldb",
                                    "cmake-language-server",
                                    "cmakelint",
                                    "cmakelang",
                                })
                                end,
                            },

                            -- ---------- Completion engines (gated) ----------
                            -- nvim-cmp stack
                            {
                                "hrsh7th/nvim-cmp",
                                cond = function() return vim.g.completion_engine == "cmp" end,
                                dependencies = {
                                    { "hrsh7th/cmp-nvim-lsp" },
                                    -- add any extras you want:
                                    -- "hrsh7th/cmp-buffer",
                                    -- "hrsh7th/cmp-path",
                                    -- "saadparwaiz1/cmp_luasnip",
                                    -- "L3MON4D3/LuaSnip",
                                },
                                config = function()
                                local cmp = require("cmp")
                                cmp.setup({})
                                end,
                            },
                            {
                                "hrsh7th/cmp-nvim-lsp",
                                cond = function() return vim.g.completion_engine == "cmp" end,
                            },

                            -- blink.cmp stack
                            {
                                "saghen/blink.cmp",
                                cond = function() return vim.g.completion_engine == "blink" end,
                                opts = {
                                    -- your blink config here if needed
                                },
                            },

                            -- ---------- LSP ----------
                            {
                                "neovim/nvim-lspconfig",
                                -- Only depend on cmp-nvim-lsp when using the cmp engine
                                dependencies = function()
                                if vim.g.completion_engine == "cmp" then
                                    return { "hrsh7th/cmp-nvim-lsp" }
                                    else
                                        return {}
                                        end
                                        end,
                                        opts = {
                                            servers = {
                                                clangd = {
                                                    cmd = clangd_cmd(),
                                                    init_options = { clangdFileStatus = true },
                                                    capabilities = lsp_capabilities(),
                                                    on_attach = function(client, bufnr)
                                                    -- Inlay hints (support both new/old APIs)
                                                    local ih = vim.lsp.inlay_hint
                                                    if client.server_capabilities.inlayHintProvider and ih then
                                                        pcall(ih.enable, true, { bufnr = bufnr })
                                                        pcall(ih.enable, bufnr, true) -- old API
                                                        end
                                                        -- Diagnostics UX
                                                        vim.diagnostic.config({
                                                            virtual_text = { prefix = "●", severity = { min = vim.diagnostic.severity.WARN } },
                                                            signs = true,
                                                            underline = true,
                                                            update_in_insert = false,
                                                            severity_sort = true,
                                                            float = { border = "rounded", source = "if_many" },
                                                        })
                                                        -- CLion-ish keymaps
                                                        local map = function(mode, lhs, rhs, desc)
                                                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                                                        end
                                                        map("n", "<C-b>", vim.lsp.buf.definition, "Go to Definition (Ctrl+B)")
                                                        map("n", "<A-F7>", vim.lsp.buf.references, "Find Usages (Alt+F7)")
                                                        map("n", "<S-F6>", vim.lsp.buf.rename, "Rename (Shift+F6)")
                                                        map("n", "<A-CR>", vim.lsp.buf.code_action, "Quick Fix (Alt+Enter)")
                                                        map("n", "K", vim.lsp.buf.hover, "Quick Documentation")
                                                        map("n", "<leader>cd", vim.lsp.buf.definition, "Go to Definition")
                                                        map("n", "<leader>cr", vim.lsp.buf.references, "Find References")
                                                        map("n", "<leader>cn", vim.lsp.buf.rename, "Rename")
                                                        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                                                        map("n", "<leader>oh", function() vim.cmd("ClangdSwitchSourceHeader") end, "Switch Header/Source")
                                                        end,
                                                },
                                                cmake = {},
                                            },
                                        },
                            },

                            -- ---------- Format on save (Conform) ----------
                            {
                                "stevearc/conform.nvim",
                                optional = true,
                                opts = {
                                    formatters_by_ft = {
                                        c = { "clang_format" },
                                        cpp = { "clang_format" },
                                        objc = { "clang_format" },
                                        objcpp = { "clang_format" },
                                    },
                                    format_on_save = function(bufnr)
                                        local ft = vim.bo[bufnr].filetype
                                        if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" then
                                            return { timeout_ms = 2000, lsp_fallback = true }
                                            end
                                            end,
                                },
                            },

                            -- ---------- Debugging (DAP + UI) ----------
                            {
                                "mfussenegger/nvim-dap",
                                dependencies = {
                                    "jay-babu/mason-nvim-dap.nvim",
                                    "rcarriga/nvim-dap-ui",
                                },
                                config = function()
                                require("mason-nvim-dap").setup({
                                    ensure_installed = { "codelldb" },
                                    automatic_setup = true,
                                })
                                local dap, dapui = require("dap"), require("dapui")
                                dapui.setup()
                                dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
                                dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
                                dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

                                vim.keymap.set("n", "<F9>", dap.continue, { desc = "Debug: Start/Continue" })
                                vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Debug: Step Over" })
                                vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Debug: Step Into" })
                                vim.keymap.set("n", "<S-F8>", dap.step_out, { desc = "Debug: Step Out" })
                                vim.keymap.set("n", "<F5>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
                                vim.keymap.set("n", "<A-F9>", function()
                                dap.set_breakpoint(vim.fn.input("Condition: "))
                                end, { desc = "Debug: Conditional Breakpoint" })

                                -- Leader fallbacks
                                vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue/Start" })
                                vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
                                vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
                                vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
                                vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

                                -- Fallback config so you can launch even without :CMakeDebug
                                local sep = (is_win and "\\" or "/")
                                dap.configurations.cpp = dap.configurations.cpp or {
                                    {
                                        name = "Launch file",
                                        type = "codelldb",
                                        request = "launch",
                                        program = function()
                                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. sep .. "build" .. sep, "file")
                                        end,
                                        cwd = "${workspaceFolder}",
                                        stopOnEntry = false,
                                        args = {},
                                        runInTerminal = true,
                                    },
                                }
                                dap.configurations.c = dap.configurations.cpp
                                dap.configurations.rust = dap.configurations.cpp
                                end,
                            },

                            -- ---------- CMake integration ----------
                            {
                                "Civitasv/cmake-tools.nvim",
                                ft = { "c", "cpp", "cmake" },
                                opts = function(_, opts)
                                opts.cmake_command = "cmake"
                                opts.cmake_build_directory = "build"
                                opts.cmake_generate_options = opts.cmake_generate_options or {}
                                if is_win and not is_wsl then
                                    opts.cmake_generate_options = { "-G", "Ninja", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }
                                    opts.cmake_soft_link_compile_commands = false
                                    else
                                        opts.cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }
                                        opts.cmake_soft_link_compile_commands = true
                                        end
                                        opts.cmake_regenerate_on_save = true
                                        opts.cmake_notification = { status = true }

                                        -- Wire to DAP so :CMakeDebug exists
                                        opts.cmake_dap_configuration = {
                                            name = "CMake Debug",
                                            type = "codelldb",
                                            request = "launch",
                                            stopOnEntry = false,
                                            runInTerminal = true,
                                            cwd = "${workspaceFolder}",
                                            args = {},
                                        }
                                        end,
                                        keys = {
                                            { "<leader>cm", "<cmd>CMakeGenerate<CR>", desc = "CMake: Configure" },
                                            { "<leader>cb", "<cmd>CMakeBuild<CR>",    desc = "CMake: Build" },
                                            { "<leader>cr", "<cmd>CMakeRun<CR>",      desc = "CMake: Run target" },
                                            { "<leader>cd", "<cmd>CMakeDebug<CR>",    desc = "CMake: Debug target" },
                                            { "<leader>ct", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake: Select Target" },
                                            { "<leader>cc", "<cmd>CMakeClean<CR>",    desc = "CMake: Clean" },
                                        },
                            },

                            -- ---------- Problems & Outline ----------
                            {
                                "folke/trouble.nvim",
                                opts = { use_diagnostic_signs = true },
                                keys = {
                                    { "<F12>", "<cmd>Trouble diagnostics toggle<CR>", desc = "Problems (Diagnostics List)" },
                                },
                            },
                            {
                                "stevearc/aerial.nvim",
                                opts = {},
                                keys = {
                                    { "<A-7>", "<cmd>AerialToggle!<CR>", desc = "Toggle Outline" },
                                },
                            },
                        }
