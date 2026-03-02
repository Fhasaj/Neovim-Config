-- Plugin: akinsho/toggleterm.nvim
-- Fixed version without Git branch issues
return {
    "akinsho/toggleterm.nvim",
    version = "*", -- Use version instead of tag
    config = function()
    require("toggleterm").setup({
        -- Basic config
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
        winblend = 0,
    },
    })
    end,
    event = "VeryLazy",
}
