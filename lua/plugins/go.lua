-- go.nvim supplies the GoLand-style code generation actions.
-- LSP (gopls), formatting (conform) and the DAP adapter (nvim-dap-go) all come
-- from the LazyVim `lang.go` extra, so they are deliberately disabled here to
-- avoid two plugins fighting over the same buffer.
return {
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false,        -- LazyVim/nvim-lspconfig owns gopls
      lsp_keymaps = false,
      lsp_inlay_hints = { enable = false }, -- LazyVim toggles these (<leader>uh)
      dap_debug = false,      -- nvim-dap-go owns the Go adapter
      trouble = true,
      luasnip = false,
    },
    -- `<leader>g` is LazyVim's git prefix, so Go actions live under `<leader>G`.
    keys = {
      { "<leader>G", "", desc = "+go" },
      { "<leader>Gi", "<cmd>GoImports<cr>", desc = "Organize imports" },
      { "<leader>Gs", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
      { "<leader>Gw", "<cmd>GoFillSwitch<cr>", desc = "Fill switch" },
      { "<leader>Ge", "<cmd>GoIfErr<cr>", desc = "Insert if err != nil" },
      { "<leader>Gt", "<cmd>GoAddTag<cr>", desc = "Add struct tags" },
      { "<leader>GT", "<cmd>GoRmTag<cr>", desc = "Remove struct tags" },
      { "<leader>Gm", "<cmd>GoImpl<cr>", desc = "Implement interface" },
      { "<leader>Ga", "<cmd>GoAlt<cr>", desc = "Alternate file (test ↔ impl)" },
      { "<leader>Gc", "<cmd>GoCoverage<cr>", desc = "Test coverage" },
      { "<leader>Gg", "<cmd>GoGenerate<cr>", desc = "go generate" },
      { "<leader>Gd", "<cmd>GoDoc<cr>", desc = "Go doc" },
    },
  },
}
