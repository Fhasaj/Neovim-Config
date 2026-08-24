-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ──────────────────────────────────────────────────────────────
-- Custom keymaps for LazyVim
-- Familiar clipboard, undo/redo, comment toggle, terminal, tabs, splits
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
-- Undo / Redo (standard shortcuts)
-----------------------------------------------------------------
keymap("n", "<C-z>", "u", vim.tbl_extend("force", opts, { desc = "Undo" }))
keymap("n", "<C-y>", "<C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))

-----------------------------------------------------------------
-- Comment toggle (Ctrl + /)
-- NOTE: In Neovim terminals, Ctrl+/ is usually received as <C-_>
-----------------------------------------------------------------
keymap("n", "<C-_>", function()
require("Comment.api").toggle.linewise.current()
end, vim.tbl_extend("force", opts, { desc = "Toggle comment line" }))

keymap("v", "<C-_>", function()
local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
vim.api.nvim_feedkeys(esc, "nx", false)
require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, vim.tbl_extend("force", opts, { desc = "Toggle comment selection" }))

-----------------------------------------------------------------
-- Terminal (ToggleTerm) - horizontal
-----------------------------------------------------------------
-- Some terminals may not send Ctrl+` reliably. If it doesn't work,
-- consider changing this to <A-`> or <leader>th.
keymap({ "n", "t" }, "<C-`>", function()
require("toggleterm").toggle(nil, nil, nil, "horizontal")
end, vim.tbl_extend("force", opts, { desc = "Toggle terminal (horizontal)" }))

-- Terminal: Escape to normal mode
keymap("t", "<Esc>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Terminal: normal mode" }))

-----------------------------------------------------------------
-- Tabs
-----------------------------------------------------------------
keymap("n", "<C-t>", "<cmd>tabnew<cr>", vim.tbl_extend("force", opts, { desc = "New tab" }))

-- Closing tabs: keep it on leader to avoid stealing Ctrl+W from window commands
keymap("n", "<leader>tc", "<cmd>tabclose<cr>", vim.tbl_extend("force", opts, { desc = "Close tab" }))
keymap("n", "]t", "<cmd>tabnext<cr>", vim.tbl_extend("force", opts, { desc = "Next tab" }))
keymap("n", "[t", "<cmd>tabprevious<cr>", vim.tbl_extend("force", opts, { desc = "Previous tab" }))

-----------------------------------------------------------------
-- Splits (direct shortcuts) + navigation
-----------------------------------------------------------------
keymap("n", "<C-\\>", "<cmd>vsplit<cr>", vim.tbl_extend("force", opts, { desc = "Vertical split" }))
keymap("n", "<C-->", "<cmd>split<cr>", vim.tbl_extend("force", opts, { desc = "Horizontal split" }))

-- Move between splits
keymap("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Focus left split" }))
keymap("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Focus below split" }))
keymap("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Focus above split" }))
keymap("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Focus right split" }))

-----------------------------------------------------------------
-- Save + Search (nice-to-have)
-----------------------------------------------------------------
keymap({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", vim.tbl_extend("force", opts, { desc = "Save" }))

-- Telescope: find files / live grep
keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", vim.tbl_extend("force", opts, { desc = "Find files (Telescope)" }))
keymap("n", "<C-f>", "<cmd>Telescope live_grep<cr>", vim.tbl_extend("force", opts, { desc = "Search in files (Telescope)" }))

-----------------------------------------------------------------
-- Optional: move block-visual mode to Alt+v (since <C-v> is paste)
-----------------------------------------------------------------
keymap("n", "<A-v>", "<C-v>", vim.tbl_extend("force", opts, { desc = "Visual block mode (moved from <C-v>)" }))

-----------------------------------------------------------------
-- Ctrl+Click on a symbol -> Go to Definition (any LSP, any file)
-- `mouse = "a"` is already on via LazyVim defaults; this just
-- teaches Ctrl+LeftMouse to move the cursor there first (so it
-- works across windows/wrapped lines) and then ask the LSP.
-----------------------------------------------------------------
keymap("n", "<C-LeftMouse>", function()
    vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true))
    vim.schedule(function()
        vim.lsp.buf.definition()
    end)
end, vim.tbl_extend("force", opts, { desc = "Go to Definition (Ctrl+Click)" }))
