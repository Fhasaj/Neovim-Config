-- Plugin: akinsho/toggleterm.nvim
-- Installed via store.nvim

return {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
        require("toggleterm").setup(

        )
    end,
    event = "VeryLazy"
}