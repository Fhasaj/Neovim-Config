return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Optional: for improved UI
    },
    config = function()
      require("flutter-tools").setup({
        lsp = {
          -- use dartls
          on_attach = function(_, bufnr)
            -- key mappings or LSP features can be added here
          end,
        },
        dev_log = {
          enabled = true,
        },
        widget_guides = {
          enabled = true,
        },
      })
    end,
  },
}
