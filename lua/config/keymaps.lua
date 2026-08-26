-- Keymaps are loaded on the VeryLazy event.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- This file adds a VS Code-style layer on top: familiar clipboard, undo/redo,
-- save, find, comment, terminal, splits and a right-click context menu.
-- Everything LazyVim already binds (<leader>…, gd, ]d, …) still works.

local map = vim.keymap.set

-- ─────────────────────────────────────────────────────────────────
-- Clipboard: Ctrl+C / Ctrl+X / Ctrl+V
--
-- `clipboard = unnamedplus` (options.lua) already routes the unnamed register
-- to the system clipboard, so plain y/d/p share it too.
-- ─────────────────────────────────────────────────────────────────
map("v", "<C-c>", '"+y', { desc = "Copy selection" })
map("n", "<C-c>", '"+yy', { desc = "Copy line" })
map("v", "<C-x>", '"+d', { desc = "Cut selection" })
map("n", "<C-x>", '"+dd', { desc = "Cut line" })
map("n", "<C-v>", '"+p', { desc = "Paste" })
-- In visual mode, paste over the selection without clobbering the clipboard
-- with the text that was replaced.
map("v", "<C-v>", '"_d"+P', { desc = "Paste over selection" })
-- `<C-r><C-o>+` inserts the register literally and leaves the cursor after it,
-- which behaves correctly at the start and end of a line.
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Paste" })
map("c", "<C-v>", "<C-r>+", { desc = "Paste" })
map("t", "<C-v>", [[<C-\><C-n>"+pi]], { desc = "Paste" })

map({ "n", "v" }, "<C-a>", "gg0vG$", { desc = "Select all" })
map("i", "<C-a>", "<Esc>gg0vG$", { desc = "Select all" })

-- Ctrl+V is taken, so visual-block moves to Ctrl+Q (as in Windows Vim) and Alt+V.
map("n", "<C-q>", "<C-v>", { desc = "Visual block mode" })
map("n", "<A-v>", "<C-v>", { desc = "Visual block mode" })

-- ─────────────────────────────────────────────────────────────────
-- Undo / redo: Ctrl+Z and Ctrl+Y (plus Ctrl+Shift+Z where the terminal sends it)
-- ─────────────────────────────────────────────────────────────────
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("v", "<C-z>", "<Esc>u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })
map("n", "<C-S-z>", "<C-r>", { desc = "Redo" })

-- ─────────────────────────────────────────────────────────────────
-- Save / close
-- ─────────────────────────────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<C-S-s>", "<cmd>wall<cr>", { desc = "Save all" })
-- NOTE: Ctrl+W is Neovim's window-command prefix (Ctrl+W then s/v/q/…), so it
-- is deliberately NOT rebound to "close buffer". Use <leader>bd instead.

-- ─────────────────────────────────────────────────────────────────
-- Find: Ctrl+P files, Ctrl+F in-buffer, Ctrl+Shift+F across the project
--
-- LazyVim's picker is snacks.nvim (not Telescope).
-- ─────────────────────────────────────────────────────────────────
map("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Find file" })
map("n", "<C-S-p>", function()
  Snacks.picker.commands()
end, { desc = "Command palette" })
map("n", "<C-f>", "/", { desc = "Find in file" })
map("n", "<C-S-f>", function()
  Snacks.picker.grep()
end, { desc = "Find in project" })
map("n", "<C-b>", function()
  Snacks.explorer()
end, { desc = "Toggle file explorer" })
map("n", "<C-g>", function()
  Snacks.picker.lines()
end, { desc = "Go to line/symbol in file" })

-- ─────────────────────────────────────────────────────────────────
-- Comment toggle: Ctrl+/
--
-- Most terminals send Ctrl+/ as <C-_>; newer ones with the kitty keyboard
-- protocol send a real <C-/>. Bind both to Neovim's built-in `gc` operator.
-- ─────────────────────────────────────────────────────────────────
for _, lhs in ipairs({ "<C-_>", "<C-/>" }) do
  map("n", lhs, "gcc", { remap = true, desc = "Toggle comment" })
  map("v", lhs, "gc", { remap = true, desc = "Toggle comment" })
  map("i", lhs, "<Esc>gcca", { remap = true, desc = "Toggle comment" })
end

-- ─────────────────────────────────────────────────────────────────
-- Buffers as "tabs" (VS Code calls its editors tabs; Neovim tabs are layouts)
-- ─────────────────────────────────────────────────────────────────
map("n", "<C-PageDown>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<C-PageUp>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<C-t>", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<C-S-t>", "<cmd>tabnew<cr>", { desc = "New tab page" })
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab page" })
map("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous tab page" })

-- ─────────────────────────────────────────────────────────────────
-- Window management
--
-- Navigation (<C-h/j/k/l>) and split creation (<leader>| and <leader>-) come
-- from LazyVim. These add resizing and the Alt-key split shortcuts.
-- Resizing is handled by smart-splits (lua/plugins/editor.lua).
-- ─────────────────────────────────────────────────────────────────
map("n", "<A-\\>", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<A-->", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<A-w>", "<C-w>c", { desc = "Close window" })
map("n", "<A-m>", "<cmd>only<cr>", { desc = "Maximize (close other windows)" })
map("n", "<A-=>", "<C-w>=", { desc = "Equalize windows" })

-- ─────────────────────────────────────────────────────────────────
-- Mouse
-- ─────────────────────────────────────────────────────────────────

-- Ctrl+Click a symbol -> go to definition. Move the cursor with the click
-- first so it works across windows and wrapped lines.
map("n", "<C-LeftMouse>", function()
  vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true))
  vim.schedule(vim.lsp.buf.definition)
end, { desc = "Go to definition (Ctrl+Click)" })

-- Right-click context menu.
--
-- Neovim 0.12 already ships a PopUp menu with Cut/Copy/Paste/Select All and
-- LSP "Go to definition" (see :help default-menus), and `mousemodel` above
-- makes the right button open it. These entries are *added* to that menu --
-- clearing it would break the built-in enable/disable logic that greys out
-- entries which don't apply to the buffer under the cursor.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.cmd([[
      anoremenu PopUp.-user-               <Nop>
      anoremenu PopUp.Find\ references     <Cmd>lua vim.lsp.buf.references()<CR>
      anoremenu PopUp.Rename\ symbol       <Cmd>lua vim.lsp.buf.rename()<CR>
      anoremenu PopUp.Code\ action         <Cmd>lua vim.lsp.buf.code_action()<CR>
      nnoremenu PopUp.Toggle\ comment      gcc
      vnoremenu PopUp.Toggle\ comment      gc
      anoremenu PopUp.Format               <Cmd>lua require("conform").format({ lsp_format = "fallback" })<CR>
    ]])
  end,
  desc = "Extend the right-click context menu",
})

-- Middle-click paste from the X11 primary selection, the way most Linux apps
-- behave. (In normal mode <C-r> is redo, hence the different right-hand sides.)
map("n", "<MiddleMouse>", '"*p', { desc = "Paste primary selection" })
map("i", "<MiddleMouse>", "<C-r><C-o>*", { desc = "Paste primary selection" })

-- ─────────────────────────────────────────────────────────────────
-- Terminal
--
-- <C-\> opens/closes the floating terminal (toggleterm, lua/plugins/terminal.lua).
-- These make the terminal buffer itself behave sensibly.
-- ─────────────────────────────────────────────────────────────────
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal: leave insert mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Terminal: window left" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Terminal: window down" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Terminal: window up" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Terminal: window right" })
