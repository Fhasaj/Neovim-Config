-- Create ~/.config/nvim/lua/plugins/lualine.lua
return {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 1, {
        function()
        return "🤖"
        end,
        cond = function()
        return vim.fn.executable("ollama") == 1
        end,
    })
    end,
}
