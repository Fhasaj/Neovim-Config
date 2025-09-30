-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- ──────────────────────────────────────────────────────────────
-- Custom keymaps for LazyVim
-- Adds familiar Ctrl+C / Ctrl+X / Ctrl+V clipboard behavior
-- ──────────────────────────────────────────────────────────────

-- Ensure system clipboard is used
vim.opt.clipboard = "unnamedplus"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-----------------------------------------------------------------
-- System clipboard mappings
-----------------------------------------------------------------

-- Copy (normal and visual mode)
keymap({ "n", "v" }, "<C-c>", '"+y', vim.tbl_extend("force", opts, { desc = "Copy to system clipboard" }))

-- Cut (normal and visual mode)
keymap({ "n", "v" }, "<C-x>", '"+d', vim.tbl_extend("force", opts, { desc = "Cut to system clipboard" }))

-- Paste (normal and visual mode)
keymap({ "n", "v" }, "<C-v>", '"+p', vim.tbl_extend("force", opts, { desc = "Paste from system clipboard" }))

-- Paste in insert mode
keymap("i", "<C-v>", '<Esc>"+pa', vim.tbl_extend("force", opts, { desc = "Paste from system clipboard (insert)" }))

-----------------------------------------------------------------
-- Optional: move block-visual mode to Alt+v
-- (since <C-v> is now paste)
-----------------------------------------------------------------
keymap("n", "<A-v>", "<C-v>", vim.tbl_extend("force", opts, { desc = "Visual block mode (moved from <C-v>)" }))

-----------------------------------------------------------------
-- Example: keep some default LazyVim keymaps if needed
-- (add any other keymaps you normally use below)
-----------------------------------------------------------------
