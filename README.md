# Neovim config

LazyVim-based Neovim config for C/C++ (incl. Qt/QML), Dart/Flutter, Go, Python
and TypeScript/JavaScript, with a local LLM, a large theme picker and
VS Code-style keybindings.

```bash
git clone -b linux https://github.com/Fhasaj/Neovim-Config ~/.config/nvim --depth 1 && nvim
```

First start installs everything. `:Lazy sync` and `:Mason` to check on it.

## What's in it

| | |
| --- | --- |
| **Plugin manager** | lazy.nvim, on the LazyVim distro |
| **Languages** | C/C++, CMake, QML, Dart/Flutter, Go, Python, TypeScript/JavaScript, Tailwind, SQL, JSON, Markdown |
| **Completion** | blink.cmp — LSP, snippets, buffer and path, in every language above |
| **LSP/tools** | Mason, auto-installing servers, formatters, linters and debug adapters |
| **AI** | CodeCompanion talking to a local Ollama. No hosted service, no Copilot |
| **Themes** | Themery — ~150 entries, live preview, choice persists |
| **Terminal** | toggleterm, floating by default |
| **Tasks/Debug** | Overseer run configurations, nvim-dap with dap-ui and inline variable values |
| **Keys** | VS Code-style clipboard, undo/redo, find, comment, right-click menu |

Startup is ~75 ms; 101 plugins installed, about half of them loaded eagerly.

## Keys

See **[Neovim_Key_Helper.md](Neovim_Key_Helper.md)** for the full reference, and
**[Go_Backend_Keys.md](Go_Backend_Keys.md)** for the Go/backend run-and-debug
workflow.

The short version: `Ctrl+C`/`Ctrl+V` copy and paste, `Ctrl+Z`/`Ctrl+Y` undo and
redo, `Ctrl+S` save, `Ctrl+P` find file, `Ctrl+Shift+F` grep, `Ctrl+/` comment,
`Ctrl+\` terminal, right-click for a context menu. Leader is `<Space>`; press it
and wait to see everything else.

## Local LLM

CodeCompanion is pointed at Ollama on `127.0.0.1:11434`. Change the host or
model in `lua/config/options.lua`:

```lua
vim.g.ollama_host = "http://127.0.0.1:11434"
vim.g.ollama_model = "qwen3-coder:30b-64k"
```

`<leader>am` (or `:CodeCompanionModel`) lists the models the daemon actually
has pulled and switches to one — which avoids the usual failure where the
configured model was never `ollama pull`ed and every request 404s.

`<leader>aa` chat · `<leader>ai` inline edit · `<leader>ac` action palette.

## Layout

```
init.lua
lua/config/
  lazy.lua          bootstrap
  options.lua       options, and the Ollama host/model
  keymaps.lua       the VS Code-style layer
  autocmds.lua
lua/plugins/
  ai.lua            CodeCompanion + Ollama
  colorscheme.lua   Themery and the theme packs
  completion.lua    blink.cmp
  lang.lua          Mason tools, LSP overrides, treesitter parsers
  flutter.lua       flutter-tools
  go.lua            go.nvim code actions
  qt.lua            Qt Designer integration
  dap.lua           debugger, with env-file-aware Go configs
  dap-ui.lua
  overseer.lua      run configurations per Go service
  terminal.lua      toggleterm, and "run this service"
  editor.lua        window management, multi-cursor
lua/util/dotenv.lua .env parsing shared by dap, overseer and the terminal runner
lazyvim.json        which LazyVim extras are enabled
```

To add a language: enable its LazyVim extra with `:LazyExtras`, then add any
server tweaks to `lua/plugins/lang.lua`.

To add a theme: add the repo and its colorscheme names to `packs` in
`lua/plugins/colorscheme.lua`.

## Dependencies

Neovim 0.12+, git, a C compiler, `ripgrep`, `fd`, a Nerd Font, and whichever
toolchains you need: `go`, `flutter`, `clang`/`cmake`, `node`, `python`.
Everything else (language servers, formatters, debug adapters) comes from Mason.

Qt Designer is optional — install `qt6-tools` for `<leader>qd` and the `.ui`
auto-open. `qmlls` ships with Qt 6 Declarative and is also available via Mason.
