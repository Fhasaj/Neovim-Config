# Neovim-Config

My custom Neovim config based on **LazyVim**. Feel free to use it as a base for your own projects.



## TL;DR Quick Start

1. Install dependencies for your OS (see below).
2. if you already have then clone the config if not go to the dependences section and start from there:
   - **Linux/macOS**
     ```bash
     git clone -b linux https://github.com/Fhasaj/Neovim-Config ~/.config/nvim --depth 1 && nvim
     ```
   - **Windows (PowerShell)**
     ```powershell
     git clone -b Windows https://github.com/Fhasaj/Neovim-Config "$Env:USERPROFILE\AppData\Local\nvim" --depth 1; nvim
     ```
   - **Windows (CMD)**
     ```cmd
     git clone -b Windows https://github.com/Fhasaj/Neovim-Config %USERPROFILE%\AppData\Local\nvim --depth 1 && nvim
     ```
3. Inside Neovim:
   - Press **Shift+U**, then **Shift+I**  
     *(or run `:Lazy sync` and `:Mason`)*



## Dependencies

> These cover: Nerd Fonts, Neovim/LazyVim essentials, search tools (**ripgrep**, **fd**), Git, build toolchains (**C/C++**, **CMake/Ninja**), debuggers (**LLDB/GDB**, DAP backends), and language SDKs (**Go**, **Node/TypeScript**, **Dart/Flutter**).  
> Mason will install most **LSP/DAP/formatters** (e.g., `clangd`, `codelldb`, `js-debug-adapter`, `delve`, `prettier`, `eslint_d`), but you still need the **system toolchains** below.  
> **Install only the SDKs you actually use** (skip Go/Flutter etc if you don’t need them).

### Fonts (All OS)

1. Install a **Nerd Font** (e.g., FiraCode Nerd Font): <https://www.nerdfonts.com/font-downloads>  
2. Set your terminal/editor to use it.



### Linux — Arch Linux

```bash
# Core tools
sudo pacman -S --needed neovim git unzip zip ripgrep fd curl

# Build & C/C++ toolchain
sudo pacman -S --needed base-devel cmake ninja pkgconf clang clangd lldb gdb

# Optional: ccache for faster rebuilds
sudo pacman -S --needed ccache

# Languages / SDKs
sudo pacman -S --needed go nodejs npm python-pipx

# Dart & Flutter (available in community)
sudo pacman -S --needed dart flutter

# (Recommended) put Mason bins on PATH (add to your shell rc)
# export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
````



### Linux — Ubuntu / Debian

```bash
sudo apt update

# Core tools
sudo apt install -y neovim git unzip zip ripgrep fd-find curl

# fd is called fdfind on Debian/Ubuntu; optional symlink so commands can use `fd`
sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true

# Build & C/C++ toolchain
sudo apt install -y build-essential cmake ninja-build pkg-config clangd lldb gdb

# Optional: ccache for faster rebuilds
sudo apt install -y ccache

# Languages / SDKs
sudo apt install -y golang nodejs npm python3-pip
# (Optional) Node via NVM is recommended for project-specific versions

# Dart & Flutter (recommended official installers or snaps)
# sudo snap install flutter --classic
# sudo snap install dart --classic
```



### Linux — Fedora

```bash
# Core tools
sudo dnf -y install neovim git unzip zip ripgrep fd-find curl

# Make `fd` alias (binary name is fdfind)
sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true

# Build & C/C++ toolchain
sudo dnf -y install @development-tools cmake ninja-build pkgconf-pkg-config clang-tools-extra lldb gdb

# Optional: ccache
sudo dnf -y install ccache

# Languages / SDKs
sudo dnf -y install golang nodejs npm python3-pip
# Dart/Flutter: prefer official installers or COPR/community repos
```



### Windows (PowerShell; run as Administrator)

```powershell
# Core
winget install Neovim.Neovim Git.Git 7zip.7zip BurntSushi.ripgrep sharkdp.fd

# Build & C/C++ toolchain
winget install Kitware.CMake Ninja-build.Ninja LLVM.LLVM   # (clang/clangd/lldb)
# Optional: MSYS2 for gdb, or VS Build Tools for MSVC + cppvsdbg

# Languages / SDKs
winget install OpenJS.NodeJS GoLang.Go Python.Python
winget install Flutter.Flutter Dart.Dart  # optional for Flutter/Dart work

# Add Mason bin dir to PATH (User env):
setx PATH "$($Env:USERPROFILE)\AppData\Local\nvim-data\mason\bin;$Env:PATH"
```

> **Note (Windows C++):** With **LLVM** you’ll debug via **LLDB** (`codelldb`). If you use **MSVC**, configure the **cppvsdbg** adapter (different DAP). This config targets `codelldb`.



### Why these are needed (quick map)

* **ripgrep** & **fd** → required by Telescope/LazyVim pickers for **fast search**.
* **cmake**, **ninja**, **clang/gcc**, **pkg-config** → build C/C++ projects; generate `compile_commands.json` for **clangd**.
* **lldb/gdb** → native debuggers used by **nvim-dap** adapters (e.g., `codelldb`).
* **Go / Node / Dart** → language SDKs for tools, LSPs, tests, and DAP.
* **zip/unzip** → some plugin installers and tasks expect them.
* **Nerd Fonts** → icons in UI (statusline, file explorer, diagnostics).



### After installing system deps

Open Neovim and let **Mason** handle the language servers & debuggers:

```vim
:Mason
```

Install at least:

* **C/C++**: `clangd`, `codelldb`, `clang-format`
* **Go**: `gopls`, `delve`
* **Node/TS/JS**: `js-debug-adapter`, `prettier`, `eslint_d`
* **Dart/Flutter**: (flutter-tools wires DAP; install Dart/Flutter SDKs system-wide)



## Installing the config

* **Linux/macOS**

  ```bash
  git clone -b linux https://github.com/Fhasaj/Neovim-Config ~/.config/nvim --depth 1 && nvim
  ```
* **Windows (PowerShell)**

  ```powershell
  git clone -b Windows https://github.com/Fhasaj/Neovim-Config "$Env:USERPROFILE\AppData\Local\nvim" --depth 1; nvim
  ```
* **Windows (CMD)**

  ```cmd
  git clone -b Windows https://github.com/Fhasaj/Neovim-Config %USERPROFILE%\AppData\Local\nvim --depth 1 && nvim
  ```

### First run

* Press **Shift+U**, then **Shift+I**
  *(or run the commands below)*

```vim
:Lazy sync
:Mason
```

* Quit Neovim: press **q** (if a floating window asks), then type `:q` and press **Enter**.



## Plugins

Plugin installs are managed by **lazy.nvim** and pinned in `lazy-lock.json` — that file (and `lua/plugins/*.lua`) is the source of truth, and this section is kept in sync with it. Two things feed the install list:

* **LazyVim extras** enabled in [`lazyvim.json`](./lazyvim.json): `lang.clangd`, `lang.cmake`, `lang.dart`, `lang.go`, `lang.typescript`, `lang.tailwind`, `lang.json`, `lang.markdown`, `lang.git`, `lang.ember`, `ai.copilot`, `coding.yanky`, `ui.dashboard-nvim`, `util.dot`, `util.gitui`. These pull in most of the C++/Go/Dart/TypeScript language tooling automatically.
* **Custom specs** in `lua/plugins/*.lua` — project-specific server settings, keymaps, and extra DAP configs layered on top.

*(66 theme variants across ~45 colorscheme plugins, picked via `themery.nvim`, are omitted from the tables below for brevity — full list in the [Themes](#-themes) section and `lua/plugins/themery.lua`.)*

### 🧠 Core / Framework

| Plugin                            | Description                                                                    |
| ---------------------------------- | --------------------------------------------------------------------------------- |
| **`folke/lazy.nvim`**             | Plugin manager for LazyVim — controls all installs, updates, and lazy-loading. |
| **`LazyVim/LazyVim`**             | The LazyVim base configuration (keymaps, UI, defaults).                        |
| **`nvim-lua/plenary.nvim`**       | Utility functions used by many plugins (required dependency).                  |
| **`nvim-tree/nvim-web-devicons`** | File icons in status lines, pickers, etc.                                      |
| **`folke/snacks.nvim`**           | LazyVim's UI/editor toolkit — picker, explorer, terminal, notifier, dashboard. |
| **`folke/lazydev.nvim`**          | Better Lua LSP experience when editing this Neovim config itself.              |

### 🧭 Navigation / UI / Workflow

| Plugin                               | Description                                                            |
| -------------------------------------- | -------------------------------------------------------------------------- |
| **`nvim-telescope/telescope.nvim`**  | Fuzzy finder for files, symbols, buffers, grep, etc.                   |
| **`nvim-lualine/lualine.nvim`**      | Statusline.                                                             |
| **`akinsho/bufferline.nvim`**        | Buffer/tab line at the top.                                             |
| **`folke/which-key.nvim`**           | Popup helper showing available keybindings after pressing `<leader>`.  |
| **`stevearc/dressing.nvim`**         | Better-looking UI dialogs and input boxes.                              |
| **`folke/noice.nvim`**               | Redesigned cmdline, messages, and popups.                               |
| **`folke/flash.nvim`**               | Fast, labeled motion jumps.                                             |
| **`folke/persistence.nvim`**         | Session save/restore per project.                                       |
| **`lewis6991/gitsigns.nvim`**        | Git change signs in the gutter, hunk staging/preview.                   |
| **`MagicDuck/grug-far.nvim`**        | Project-wide find & replace UI.                                         |
| **`nvimdev/dashboard-nvim`**         | Start screen (via `ui.dashboard-nvim` extra).                           |
| **`kdheepak/themery.nvim`**          | Theme picker/switcher (`<leader>ut`) across all installed colorschemes — see [Themes](#-themes). |
| **`akinsho/toggleterm.nvim`**        | Managed terminal windows (`<C-\`>`, `<leader>t*`).                      |

### ⚙️ LSP / Completion / Snippets

| Plugin                                | Description                                                                          |
| ---------------------------------------- | ----------------------------------------------------------------------------------------- |
| **`neovim/nvim-lspconfig`**           | Core LSP client configuration.                                                        |
| **`mason-org/mason.nvim`**            | Installer for LSP servers, linters, formatters, and DAP adapters.                     |
| **`mason-org/mason-lspconfig.nvim`**  | Bridges Mason and lspconfig.                                                          |
| **`saghen/blink.cmp`**                | Primary autocompletion engine (fast, Rust-backed fuzzy matching, built-in snippets).  |
| **`giuxtaposition/blink-copilot`**    | Copilot suggestions surfaced as blink.cmp completions.                                |
| **`rafamadriz/friendly-snippets`**    | Collection of ready-to-use snippets, consumed by blink.cmp.                           |
| **`zbirenbaum/copilot.lua`**          | GitHub Copilot engine (via `ai.copilot` extra).                                       |

> An `nvim-cmp` stack (`hrsh7th/nvim-cmp` + `cmp-nvim-lsp`) is wired up behind `vim.g.completion_engine = "cmp"` in `lua/plugins/cpp.lua`, but **blink.cmp is the default** (`vim.g.completion_engine = "blink"`), so `nvim-cmp` isn't actually installed unless you flip that flag.

### 🎨 Syntax / Treesitter

| Plugin                                            | Description                                                                |
| ---------------------------------------------------- | -------------------------------------------------------------------------------- |
| **`nvim-treesitter/nvim-treesitter`**             | Syntax highlighting, indentation, folding.                                |
| **`nvim-treesitter/nvim-treesitter-textobjects`** | Text objects for functions, loops, etc.                                   |
| **`windwp/nvim-ts-autotag`**                      | Auto-close/rename matching JSX/TSX/HTML tags — a big win for React/Next.js. |
| **`folke/ts-comments.nvim`**                      | Correct comment strings in embedded/mixed languages (JSX, Vue, etc.).     |

### 💬 Commenting

| Plugin                        | Description                                                |
| -------------------------------- | -------------------------------------------------------------- |
| **`numToStr/Comment.nvim`**   | Line/block commenting plugin (`<C-_>`, `<leader>c/`, `gc`). |
| **`folke/ts-comments.nvim`**  | Treesitter-aware comment strings feeding `Comment.nvim`.   |

### 🚧 Diagnostics / Errors / TODOs

| Plugin                          | Description                                                             |
| ---------------------------------- | ----------------------------------------------------------------------------- |
| **`folke/trouble.nvim`**        | VSCode-like "Problems" list for diagnostics, refs, symbols (`<F12>`).   |
| **`folke/todo-comments.nvim`**  | Highlights and lists `TODO`, `FIXME`, `NOTE`, etc. in your code.        |
| **`mfussenegger/nvim-lint`**    | Linter manager (clang-tidy, eslint, golangci-lint, dart analyze).       |

### 🧱 Build / Run / Debug

| Plugin                          | Description                                                                     |
| ---------------------------------- | -------------------------------------------------------------------------------------- |
| **`Civitasv/cmake-tools.nvim`** | Integrates CMake with Neovim (build, run, debug) — see `lua/plugins/cpp.lua`.        |
| **`mfussenegger/nvim-dap`**     | Core Debug Adapter Protocol implementation.                                          |
| **`rcarriga/nvim-dap-ui`**      | Debugger side panels (variables, stack, breakpoints).                                |
| **`leoluz/nvim-dap-go`**        | Go DAP integration (delve), installed via the `lang.go` extra.                       |
| **`nvim-neotest/nvim-nio`**     | Async library required by `nvim-dap-ui`.                                             |

### 🧩 Language-Specific Plugins

| Language                                       | Plugin(s)                                                                                                  | Config file(s)                                                          |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **C / C++**                                    | `clangd` + `clangd_extensions.nvim` (inlay hints, AST, symbol info), `cmake-tools.nvim`, `codelldb` DAP    | `lua/plugins/cpp.lua`, `lua/plugins/dap.lua`                            |
| **Go**                                         | `gopls`, `fatih/vim-go` (build/test/run helpers), `delve` + `nvim-dap-go` DAP, `.env`-aware debug configs  | `lua/plugins/gopls.lua`, `lua/plugins/golang.lua`, `lua/plugins/dap.lua` |
| **Dart / Flutter**                             | `dartls`, `akinsho/flutter-tools.nvim` (auto DAP integration, dev log, widget guides)                      | `lua/plugins/dartls.lua`, `lua/plugins/flutter.lua`                     |
| **TypeScript / JavaScript / React / Next.js**  | `ts_ls`, `eslint`, `tailwindcss` LSP, `nvim-ts-autotag` (JSX/TSX tags), `js-debug-adapter` DAP              | `lua/plugins/ts_ls.lua`, `lua/plugins/eslint.lua`, `lua/plugins/tailwindcss.lua`, `lua/plugins/dap.lua` |

### 🧰 Formatting & Linting

| Plugin                       | Description                                                        |
| ------------------------------- | ----------------------------------------------------------------------- |
| **`stevearc/conform.nvim`**  | Formatter manager (`clang-format`, `prettier`, `goimports`, etc.). |
| **`mfussenegger/nvim-lint`** | Linter manager (`clang-tidy`, `eslint`, `golangci-lint`).           |

### 🤖 AI Assistants

| Plugin                              | Description                                                                     |
| --------------------------------------- | ------------------------------------------------------------------------------------ |
| **`olimorris/codecompanion.nvim`**  | Chat/inline-edit/actions AI assistant — the only AI chat plugin now, wired to a local Ollama model (`qwen2.5-coder:14b` by default, see `lua/plugins/codecompanion.lua`). |

> `NickvanDyke/opencode.nvim` was removed — it drove the external `opencode` CLI, which has no local-model config and would default to cloud providers, and having two overlapping AI chat plugins was redundant now that the workflow is local-only. GitHub Copilot (`zbirenbaum/copilot.lua`, `blink-copilot`) stays installed via the `ai.copilot` extra but is explicitly disabled in `lua/plugins/ai-coding.lua` — also cloud-based, so it's off by default.

See the **AI Code Assistant** section in the Key Helper — CodeCompanion's keymaps live under the `<leader>c*` prefix, shared with clangd and CMake.

### 🧑‍💻 Custom Keymaps (not tied to a specific plugin)

| Added Feature                            | Source                                                                |
| ------------------------------------------- | -------------------------------------------------------------------------- |
| Copy/Cut/Paste keymaps                   | `<C-c>` / `<C-x>` / `<C-v>` in `lua/config/keymaps.lua`               |
| System clipboard support                 | `vim.opt.clipboard = 'unnamedplus'`                                   |
| Alt + v for block select                 | Manual mapping                                                        |
| Ctrl+Z / Ctrl+Y undo-redo                | Manual mapping                                                        |
| Ctrl+P / Ctrl+F find files / live grep   | Telescope, mapped directly (in addition to `<leader>ff` / `<leader>/`) |
| Toggle numbers / wrap / format           | LazyVim default mappings                                              |

## 🐞 Go Debugging with `.env` files

Standard `dlv`/DAP launches don't read your shell environment or a `.env` file, which breaks anything reading config via `os.Getenv`. `lua/plugins/dap.lua` adds three extra Go debug configurations that load a `.env` file **at launch time**:

* **Debug (.env)** — debug the current file (`${file}`) with `.env` variables injected.
* **Debug package (.env)** — debug the package containing the current file (`${fileDirname}`).
* **Debug test (.env)** — run `dlv test` on the current package with `.env` variables injected.

**How to use it:**
1. Press **F5** in a `.go` buffer (`dap.continue()`).
2. Since there's more than one Go configuration available, a picker pops up — choose one of the `(.env)` entries.
3. The `.env` file is located by starting at the debugged file's directory and walking upward to the nearest `go.mod` or `.git`, then parsed as `KEY=VALUE` lines (surrounding quotes and `#` comments are stripped) and passed to Delve as extra process environment.

No extra plugin or dependency is required — it's a small parser inside `lua/plugins/dap.lua`. If no `.env` is found at the resolved project root you'll get a `WARN` notification and the process still launches (with nothing extra injected). The plain **Debug** entry (no `.env`) is still available when you don't want env injection.

## 🎨 Themes

Press **`<leader>ut`** (Space, then **u**, then **t**) to open the `themery.nvim` picker — arrow through the list for a live preview, **Enter** to apply. All colorscheme plugins are installed lazily, so nothing loads until you pick it. Most entries come in a light/dark pair.

<details>
<summary>All 45 colorscheme families (66 variants) — click to expand</summary>

Everforest · Tokyo Night · Catppuccin · Kanagawa · Nightfox / Dayfox · GitHub · Rosé Pine · Gruvbox · Gruvbox Material · Gruvbox Baby · OneDark Pro · One Dark (navarasu) · Material · Ayu · Nightfly · Moonfly · Dracula · Nord (shaunsingh) · Nordic · Sonokai · Edge · Moonlight · VSCode · Melange · Zenbones / Zenwritten · Doom One · Tokyodark · One Monokai · Monokai · Monokai Nightasty · Solarized · Modus Vivendi / Operandi · Bamboo · Cyberdream · Nightcity · Poimandres · Adwaita · Night Owl · Onenord · Palenight · Arctic · Everblush · Mellifluous · Fluoromachine · Evergarden

</details>

Themes (and their plugin dependencies) are added/removed in `lua/plugins/themery.lua` — each entry needs both an item in the `themes` table **and** a matching plugin in the `dependencies` list; removing only one half leaves a broken/orphaned picker entry (`Oxocarbon` was one such orphan and has been removed).

## 🔧 Git

Git tooling is confirmed working: `git` (2.55) and `lazygit` are on system `PATH`, and `gitui` is installed by Mason (`util.gitui` extra, `ensure_installed = { "gitui" }`) and reachable on Neovim's runtime `PATH` even without a shell rc change.

The `util.gitui` extra **replaces** LazyVim's default Lazygit keys with GitUI, and removes two file/log-history keys in favor of it:

| Key | Action |
| --- | --- |
| `<leader>gg` | Open **GitUI** at the project root |
| `<leader>gG` | Open **GitUI** at the current working directory |
| `<leader>gL` | Git log (cwd) |
| `<leader>gb` | Git blame line (picker) |
| `<leader>gB` | Git browse (open remote in browser) |
| `<leader>gY` | Copy git-permalink for selection/line |

Plus the usual `gitsigns.nvim` hunk keys (unaffected by the extra) — see the Key Helper's Git section.



## Key Helper

This shows **exactly** what to press (Ctrl, Space, etc.).
The latest version lives here → [`Neovim_Key_Helper.md`](./Neovim_Key_Helper.md)



## Troubleshooting

* **Fonts not showing icons** → ensure your terminal’s font is set to a **Nerd Font**.
* **`fd` not found** → on Ubuntu/Fedora the binary is `fdfind`; the README includes a symlink step.
* **LSP not working for C++** → make sure `compile_commands.json` exists (CMake configure step), and `clangd` is installed via Mason.
* **Debugger doesn’t start** → install `codelldb` (Mason) and make sure your program is built with **Debug** (`-g`).
* **Go debug `.env` not applied** → check the `WARN` notification for the path it searched; the file must be named exactly `.env` and sit at (or above) the nearest `go.mod`/`.git` to the file you're debugging.
* **`<leader>c...` does something unexpected** → that prefix is shared by clangd (buffer-local, C/C++ files only), CMake, and CodeCompanion; buffer-local mappings win inside a `.cpp`/`.h` buffer, otherwise the last-loaded plugin's global mapping wins. Check `lua/plugins/cpp.lua`, `lua/plugins/codecompanion.lua` if a key doesn't do what you expect.
* **PATH issues** → ensure `~/.local/share/nvim/mason/bin` (Linux) or `%USERPROFILE%\AppData\Local\nvim-data\mason\bin` (Windows) is on PATH.

