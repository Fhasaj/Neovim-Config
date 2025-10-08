-- ~/.config/nvim/lua/plugins/comment.lua
return {
    "numToStr/Comment.nvim",
    lazy = false,
    dependencies = {
        -- optional, enables contextual commenting (JSX, TSX, HTML, etc.)
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
    -- Optional: smart context commenting
    local pre_hook = nil
    local ok, ts_integration = pcall(function()
    return require("ts_context_commentstring.integrations.comment_nvim")
    end)
    if ok and ts_integration then
        pre_hook = ts_integration.create_pre_hook()
        end

        require("Comment").setup({
            padding = true,
            sticky = true,
            ignore = "^$",           -- ignore empty lines
            mappings = { basic = true, extra = true },
            pre_hook = pre_hook,
        })

        -- ✅ Alt + / toggles comment (Normal + Visual modes)
        vim.keymap.set("n", "<leader>c/", require("Comment.api").toggle.linewise.current, { silent = true, desc = "Toggle comment" })
        vim.keymap.set("v", "<leader>c/", function()
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
        end, { silent = true, desc = "Toggle comment (visual)" })
        end,
}
