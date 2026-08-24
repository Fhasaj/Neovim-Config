return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {
          -- You usually don't need to set `cmd`, as lspconfig handles it
          filetypes = { "dart" },
          -- root_dir intentionally NOT overridden: the old sync `lspconfig.util.root_pattern(...)`
          -- silently breaks vim.lsp.enable()'s auto-attach (see lua/plugins/gopls.lua for details).
          -- nvim-lspconfig's bundled default (`root_markers = { "pubspec.yaml" }`) works correctly.
        },
      },
    },
  },
}
