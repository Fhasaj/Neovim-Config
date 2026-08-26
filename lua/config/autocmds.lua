-- Autocmds are loaded on the VeryLazy event.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("user", { clear = true })

-- Terminal buffers: no line numbers, and start in insert mode like an
-- integrated terminal panel would.
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
  desc = "Terminal buffers behave like a terminal panel",
})

-- Keep splits proportional when the outer window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "tabdo wincmd =",
  desc = "Equalize splits on resize",
})
