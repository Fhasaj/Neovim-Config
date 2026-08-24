return {
    {
        "fatih/vim-go",
        build = ":GoUpdateBinaries",
        ft = { "go", "gomod", "gowork", "gotmpl" },
        init = function()
            -- Disable features that overlap with gopls/nvim-lspconfig
            vim.g.go_gopls_enabled = 0
            vim.g.go_code_completion_enabled = 0
            vim.g.go_def_mapping_enabled = 0
            vim.g.go_doc_keywordprg_enabled = 0
            vim.g.go_fmt_autosave = 0        -- let gopls/conform/none-ls handle formatting
            vim.g.go_imports_autosave = 0    -- let gopls handle goimports
            vim.g.go_diagnostics_enabled = 0
            vim.g.go_metalinter_autosave = 0

            -- Keep vim-go's nice-to-haves
            vim.g.go_fmt_command = "goimports"
            vim.g.go_highlight_types = 1
            vim.g.go_highlight_fields = 1
            vim.g.go_highlight_functions = 1
            vim.g.go_highlight_function_calls = 1
            vim.g.go_highlight_operators = 1
            vim.g.go_highlight_extra_types = 1
            vim.g.go_highlight_build_constraints = 1
            vim.g.go_highlight_generate_tags = 1
            vim.g.go_auto_type_info = 0 -- gopls hover handles this, avoid duplicate
        end,
        config = function()
            local map = vim.keymap.set
            local opts = { silent = true }

            map("n", "<leader>gr", ":GoRun<CR>", opts)
            map("n", "<leader>gb", ":GoBuild<CR>", opts)
            map("n", "<leader>gt", ":GoTest<CR>", opts)
            map("n", "<leader>gtf", ":GoTestFunc<CR>", opts)
            map("n", "<leader>gc", ":GoCoverageToggle<CR>", opts)
            map("n", "<leader>ga", ":GoAlternate<CR>", opts)
            map("n", "<leader>gi", ":GoImports<CR>", opts)
            map("n", "<leader>gs", ":GoFillStruct<CR>", opts)
            map("n", "<leader>ge", ":GoIfErr<CR>", opts)
            map("n", "<leader>gd", ":GoDoc<CR>", opts)
            map("n", "<leader>gv", ":GoDef<CR>", opts) -- optional, gopls def is usually better
        end,
    },
}
