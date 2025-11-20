-- ~/.config/nvim/lua/plugins/spell.lua
return {
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
        table.insert(opts.sources, { name = "spell" })
        end,
    },
}
