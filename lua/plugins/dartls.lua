return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {
          -- You usually don't need to set `cmd`, as lspconfig handles it
          filetypes = { "dart" },
          root_dir = require("lspconfig.util").root_pattern("pubspec.yaml"),
        },
      },
    },
  },
}
