return {
    {
        "alex-popov-tech/store.nvim",
        dependencies = { "OXY2DEV/markview.nvim" },
        cmd = "Store",
        keys = {
            { "<leader>ps", "<cmd>Store<cr>", desc = "Open Plugin Store" },
        },
        opts = {
            width = 0.9,
            height = 0.9,
            logging = "off",
            -- plugins_folder = vim.fn.expand("~/.local/share/nvim/store-plugins"),
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        for _, lang in ipairs({ "markdown", "markdown_inline" }) do
            if not vim.tbl_contains(opts.ensure_installed, lang) then
                table.insert(opts.ensure_installed, lang)
                end
                end
                end,
    },
}
