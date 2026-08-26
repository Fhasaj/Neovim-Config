-- Options are loaded before lazy.nvim starts.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Clipboard: yank/put go straight to the system clipboard so the VS Code-style
-- Ctrl+C / Ctrl+V mappings in keymaps.lua share one buffer with other apps.
opt.clipboard = "unnamedplus"

-- Mouse: full support, and right-click opens the context menu defined in
-- keymaps.lua instead of extending the selection.
opt.mouse = "a"
opt.mousemodel = "popup_setpos"

-- Editing feel closer to a GUI editor.
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.splitkeep = "screen"

-- Persistent undo, so Ctrl+Z still works after reopening a file.
opt.undofile = true
opt.undolevels = 10000

-- Python: basedpyright over pyright. Same engine, stricter inference, and it
-- is the one Mason installs for this config.
vim.g.lazyvim_python_lsp = "basedpyright"

-- Which AI backend the CodeCompanion config talks to (see lua/plugins/ai.lua).
vim.g.ai_backend = "ollama"
vim.g.ollama_host = "http://127.0.0.1:11434"
vim.g.ollama_model = "qwen3-coder:30b-64k"
