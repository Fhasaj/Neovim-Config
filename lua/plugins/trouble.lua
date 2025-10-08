return {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
        { "<F12>", "<cmd>Trouble diagnostics toggle<cr>", desc = "Problems (Diagnostics)" }, -- matches your current binding
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
        { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
        { "<leader>xl", "<cmd>Trouble lsp toggle<cr>", desc = "LSP refs/defs/etc." },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    },
}
