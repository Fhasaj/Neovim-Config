return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "dartls",
        "clangd",
        "cmake",
        "gopls",
        "tsserver",
        "tailwindcss",
      },
    },
  },
}
