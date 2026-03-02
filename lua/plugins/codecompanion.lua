return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "stevearc/dressing.nvim",
    },
    config = function()
    local cc = require("codecompanion")
    cc.setup({
        -- 🎨 VSCODE-STYLE DISPLAY
        display = {
            chat = {
                window = {
                    layout = "vertical", -- Side panel like VSCode
                    width = 0.3, -- 30% of screen width
                    height = 1.0, -- Full height
                    relative = "editor",
                    border = "single",
                    title = " CodeCompanion",
                    title_pos = "center",
                },
                intro_message = "Welcome! Use /file, /buffer, or /tree to add project context.",
                show_settings = true,
                show_token_count = true,
                render_headers = true,
            },
            diff = {
                provider = "default",
                layout = "vertical",
            },
            inline = {
                layout = "vertical",
            },
        },

        -- 🔌 OLLAMA ADAPTER
        adapters = {
            ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "ollama",
                schema = {
                    model = {
                        default = "qwen14coder:latest",
                    },
                    num_ctx = {
                        default = 8192,
                    },
                },
                env = {
                    url = "http://127.0.0.1:11434",
                },
            })
            end,
        },

        -- 🧠 STRATEGIES
        strategies = {
            chat = { adapter = "ollama" },
            inline = { adapter = "ollama" },
            agent = { adapter = "ollama" },
        },

        -- 📁 PROJECT CONTEXT - Slash Commands
        slash_commands = {
            ["buffer"] = {
                callback = "strategies.chat.slash_commands.buffer",
                description = "Insert current buffer",
                opts = {
                    contains_code = true,
                },
            },
            ["file"] = {
                callback = "strategies.chat.slash_commands.file",
                description = "Insert a file from project",
                opts = {
                    contains_code = true,
                    max_lines = 1000,
                },
            },
            ["files"] = {
                callback = "strategies.chat.slash_commands.files",
                description = "Insert multiple files",
                opts = {
                    contains_code = true,
                },
            },
            ["symbols"] = {
                callback = "strategies.chat.slash_commands.symbols",
                description = "Insert symbols from current buffer",
            },
            ["tree"] = {
                callback = function()
                local tree = vim.fn.system("tree -L 3 -I 'node_modules|.git|dist|build|target' --gitignore 2>/dev/null || find . -maxdepth 3 -type d")
                return "Project Structure:\n```\n" .. tree .. "\n```"
                end,
                description = "Insert project tree structure",
            },
            ["help"] = {
                callback = function()
                return [[Available Commands:
                - /buffer - Add current file
                - /file - Search and add a file
                - /files - Add multiple files
                - /symbols - Add code symbols
                - /tree - Show project structure
                - /help - Show this help]]
                end,
                description = "Show available commands",
            },
        },

        -- 🎯 ENHANCED PROMPTS
        prompt_library = {
            ["Senior Engineer"] = {
                strategy = "chat",
                description = "Act as a senior software engineer",
                prompts = {
                    {
                        role = "system",
                        content = [[You are a senior software engineer integrated into an IDE.

                        PROJECT CONTEXT:
                        - You have access to the full project via /file and /buffer commands
                        - Use /tree to see project structure
                        - Use /symbols to see code symbols

                        WHEN EDITING CODE:
                        - Make minimal, surgical changes
                        - Prefer unified diffs
                        - Do not rewrite unchanged code
                        - Only explain if explicitly asked
                        - Consider the broader project context

                        RESPONSE STYLE:
                        - Be concise and actionable
                        - Show code first, explain second
                        - Use markdown formatting for clarity]],
                    },
                },
            },
            ["Code Review"] = {
                strategy = "chat",
                description = "Review code for quality and best practices",
                prompts = {
                    {
                        role = "system",
                        content = [[You are an expert code reviewer. Analyze the code for:
                        - Bugs and edge cases
                        - Performance issues
                        - Security vulnerabilities
                        - Best practices and patterns
                        - Readability and maintainability

                        Provide specific, actionable feedback.]],
                    },
                },
            },
            ["Explain"] = {
                strategy = "chat",
                description = "Explain code in detail",
                prompts = {
                    {
                        role = "system",
                        content = [[Explain the code clearly and thoroughly:
                        - What it does
                        - How it works
                        - Key concepts and patterns
                        - Potential gotchas

                        Use simple language and examples.]],
                    },
                },
            },
            ["Fix"] = {
                strategy = "inline",
                description = "Fix the selected code",
                prompts = {
                    {
                        role = "system",
                        content = "Fix any bugs or issues in the selected code. Return only the corrected code without explanations.",
                    },
                },
            },
            ["Optimize"] = {
                strategy = "inline",
                description = "Optimize the selected code",
                prompts = {
                    {
                        role = "system",
                        content = "Optimize the selected code for performance and readability. Return only the optimized code.",
                    },
                },
            },
        },

        -- 🎨 ADDITIONAL OPTIONS
        opts = {
            log_level = "ERROR",
            send_code = true,
            use_default_actions = true,
            use_default_prompts = true,
        },
    })

    -- 🔑 FIXED KEYMAPS (using only available commands)
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Open/Toggle chat panel
    map("n", "<leader>cc", "<cmd>CodeCompanionChat<cr>",
        vim.tbl_extend("force", opts, { desc = "󰭹 AI Chat" }))
    map("v", "<leader>cc", "<cmd>CodeCompanionChat<cr>",
        vim.tbl_extend("force", opts, { desc = "󰭹 AI Chat with selection" }))

    -- Close chat with simple buffer close
    map("n", "<leader>cq", function()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("codecompanion") then
            vim.api.nvim_buf_delete(buf, { force = true })
            end
            end
            end, vim.tbl_extend("force", opts, { desc = "󰅖 Close AI Chat" }))

    -- Inline editing
    map("v", "<leader>ce", "<cmd>CodeCompanionInline<cr>",
        vim.tbl_extend("force", opts, { desc = " AI Edit Selection" }))
    map("v", "<leader>ci", "<cmd>CodeCompanionInline<cr>",
        vim.tbl_extend("force", opts, { desc = " AI Inline Edit" }))

    -- Actions menu
    map("n", "<leader>ca", "<cmd>CodeCompanionActions<cr>",
        vim.tbl_extend("force", opts, { desc = "󰘳 AI Actions" }))
    map("v", "<leader>ca", "<cmd>CodeCompanionActions<cr>",
        vim.tbl_extend("force", opts, { desc = "󰘳 AI Actions" }))

    -- Quick prompts
    map("n", "<leader>cr", function()
    vim.cmd("CodeCompanionChat Code Review")
    end, vim.tbl_extend("force", opts, { desc = " Code Review" }))

    map("n", "<leader>cx", function()
    vim.cmd("CodeCompanionChat Explain")
    end, vim.tbl_extend("force", opts, { desc = "󰋼 Explain Code" }))

    -- Add current buffer to chat
    map("n", "<leader>cb", function()
    vim.cmd("CodeCompanionChat")
    vim.defer_fn(function()
    -- Find codecompanion buffer and add /buffer
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("codecompanion") and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_set_current_buf(buf)
            vim.api.nvim_feedkeys("i/buffer", "n", false)
            break
            end
            end
            end, 200)
    end, vim.tbl_extend("force", opts, { desc = "󰈔 Add Buffer to Chat" }))

    -- Quick inline fixes
    map("v", "<leader>cf", "<cmd>CodeCompanionInline Fix<cr>",
        vim.tbl_extend("force", opts, { desc = " Fix Code" }))

    map("v", "<leader>cp", "<cmd>CodeCompanionInline Optimize<cr>",
        vim.tbl_extend("force", opts, { desc = "󰚩 Optimize Code" }))

    -- Add current file with visual selection
    map("v", "<leader>cb", function()
    -- Yank the visual selection
    vim.cmd('normal! "vy')
    local selection = vim.fn.getreg('v')

    vim.cmd("CodeCompanionChat")
    vim.defer_fn(function()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("codecompanion") and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_set_current_buf(buf)
            -- Insert the selection into chat
            local lines = vim.split(selection, "\n")
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"```"})
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"```"})
            break
            end
            end
            end, 200)
    end, vim.tbl_extend("force", opts, { desc = "󰈔 Add Selection to Chat" }))
    end,
}
