-- lua/plugins/mason.lua
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "cmake",
        "gopls",
        "ts_ls",       -- was "tsserver"
        "tailwindcss",
      },
    },
  },
}
