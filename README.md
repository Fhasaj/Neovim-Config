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

Below is a list of all the plugins currently installed to match my workflow (C++, Go, Dart, Node/TS).
*(See `lua/plugins/` for exact files.)*

### 🧠 Core / Framework

| Plugin                            | Description                                                                    |
| --------------------------------- | ------------------------------------------------------------------------------ |
| **`folke/lazy.nvim`**             | Plugin manager for LazyVim — controls all installs, updates, and lazy-loading. |
| **`LazyVim/LazyVim`**             | The LazyVim base configuration (keymaps, UI, defaults).                        |
| **`nvim-lua/plenary.nvim`**       | Utility functions used by many plugins (required dependency).                  |
| **`nvim-tree/nvim-web-devicons`** | File icons in status lines, file explorers, etc.                               |

### 🧭 Navigation / UI / Workflow

| Plugin                                                             | Description                                                           |
| ------------------------------------------------------------------ | --------------------------------------------------------------------- |
| **`nvim-tree/nvim-tree.lua`** or **`nvim-neo-tree/neo-tree.nvim`** | File explorer (depending on your LazyVim base).                       |
| **`nvim-telescope/telescope.nvim`**                                | Fuzzy finder for files, symbols, buffers, grep, etc.                  |
| **`nvim-lualine/lualine.nvim`**                                    | Statusline. LazyVim ships with this.                                  |
| **`folke/which-key.nvim`**                                         | Popup helper showing available keybindings after pressing `<leader>`. |
| **`stevearc/dressing.nvim`**                                       | Better-looking UI dialogs and input boxes.                            |
| **`nvim-notify/nvim-notify`**                                      | Enhanced notifications.                                               |
| **`lukas-reineke/indent-blankline.nvim`**                          | Indentation guides.                                                   |
| **`echasnovski/mini.indentscope`**                                 | Optional LazyVim indent scope lines.                                  |

### ⚙️ LSP / Autocompletion / Snippets

| Plugin                                                      | Description                                               |
| ----------------------------------------------------------- | --------------------------------------------------------- |
| **`neovim/nvim-lspconfig`**                                 | Core LSP client configuration.                            |
| **`williamboman/mason.nvim`**                               | Installer for LSP servers, linters, formatters, and DAPs. |
| **`williamboman/mason-lspconfig.nvim`**                     | Bridges Mason and LSPConfig.                              |
| **`hrsh7th/nvim-cmp`**                                      | Autocompletion engine.                                    |
| **`hrsh7th/cmp-nvim-lsp`**                                  | LSP source for completion.                                |
| **`hrsh7th/cmp-buffer`**, **`cmp-path`**, **`cmp-cmdline`** | Extra completion sources.                                 |
| **`L3MON4D3/LuaSnip`**                                      | Snippet engine.                                           |
| **`saadparwaiz1/cmp_luasnip`**                              | Connects LuaSnip to nvim-cmp.                             |
| **`rafamadriz/friendly-snippets`**                          | Collection of ready-to-use snippets.                      |

### 🎨 Syntax / Treesitter

| Plugin                                            | Description                                                               |
| ------------------------------------------------- | ------------------------------------------------------------------------- |
| **`nvim-treesitter/nvim-treesitter`**             | Syntax highlighting, indentation, folding.                                |
| **`nvim-treesitter/nvim-treesitter-textobjects`** | Text objects for functions, loops, etc.                                   |
| **`JoosepAlviste/nvim-ts-context-commentstring`** | Context-aware comment strings for mixed languages (used by Comment.nvim). |

### 💬 Commenting

| Plugin                                            | Description                                                    |
| ------------------------------------------------- | -------------------------------------------------------------- |
| **`numToStr/Comment.nvim`**                       | Line/block commenting plugin (with `<leader>c/` mapping).      |
| **`JoosepAlviste/nvim-ts-context-commentstring`** | (Integrated) detects correct comment syntax for JSX, TSX, etc. |

### 🚧 Diagnostics / Errors / TODOs

| Plugin                         | Description                                                      |
| ------------------------------ | ---------------------------------------------------------------- |
| **`folke/trouble.nvim`**       | VSCode-like “Problems” list for diagnostics, refs, symbols.      |
| **`folke/todo-comments.nvim`** | Highlights and lists `TODO`, `FIXME`, `NOTE`, etc. in your code. |

### 🧱 Build / Run / Debug

| Plugin                          | Description                                                                 |
| ------------------------------- | --------------------------------------------------------------------------- |
| **`Civitasv/cmake-tools.nvim`** | Integrates CMake with Neovim (build, run, debug).                           |
| **`mfussenegger/nvim-dap`**     | Core Debug Adapter Protocol implementation.                                 |
| **`rcarriga/nvim-dap-ui`**      | Debugger side panels (variables, stack, breakpoints).                       |
| **`nvim-neotest/nvim-nio`**     | Needed for DAP-UI async handling.                                           |
| **`williamboman/mason.nvim`**   | Also used to install adapters like `codelldb`, `js-debug-adapter`, `delve`. |

### 🧩 Language-Specific Plugins

| Language                 | Plugin(s)                                                         |
| ------------------------ | ----------------------------------------------------------------- |
| **C/C++**                | `p00f/clangd_extensions.nvim` (optional), uses `clangd` via Mason |
| **Go**                   | `ray-x/go.nvim`, `ray-x/guihua.lua`, `leoluz/nvim-dap-go`         |
| **Dart / Flutter**       | `akinsho/flutter-tools.nvim` (auto DAP integration)               |
| **TypeScript / Node.js** | `pmizio/typescript-tools.nvim`, `mxsdev/nvim-dap-vscode-js`       |

### 🧰 Formatting & Linting

| Plugin                       | Description                                                 |
| ---------------------------- | ----------------------------------------------------------- |
| **`stevearc/conform.nvim`**  | Formatter manager (clang-format, prettier, goimports, etc.) |
| **`mfussenegger/nvim-lint`** | Linter manager (clang-tidy, eslint, golangci-lint).         |

### 🧑‍💻 Utilities / Extra

| Plugin                             | Description                                    |
| ---------------------------------- | ---------------------------------------------- |
| **`mbbill/undotree`**              | Visual undo tree viewer.                       |
| **`stevearc/overseer.nvim`**       | Task runner (build/test/run commands).         |
| **`aznhe21/actions-preview.nvim`** | Previews code actions before applying.         |
| **`smjonas/inc-rename.nvim`**      | Inline rename UI for symbols.                  |
| **`stevearc/aerial.nvim`**         | Symbols outline (like CLion’s structure view). |

### From Your Keymaps.lua Customizations

| Added Feature                            | Plugin Used                         |
| ---------------------------------------- | ----------------------------------- |
| Copy/Cut/Paste keymaps                   | Native (`<C-c>`, `<C-x>`, `<C-v>`)  |
| System clipboard support                 | `vim.opt.clipboard = 'unnamedplus'` |
| Alt + v for block select                 | Manual mapping                      |
| Clear search highlight (`Space + u + r`) | LazyVim default                     |
| Toggle numbers / wrap / format           | LazyVim default mappings            |



## Key Helper

This shows **exactly** what to press (Ctrl, Space, etc.).
The latest version lives here → [`Neovim_Key_Helper.md`](./Neovim_Key_Helper.md)



## Troubleshooting

* **Fonts not showing icons** → ensure your terminal’s font is set to a **Nerd Font**.
* **`fd` not found** → on Ubuntu/Fedora the binary is `fdfind`; the README includes a symlink step.
* **LSP not working for C++** → make sure `compile_commands.json` exists (CMake configure step), and `clangd` is installed via Mason.
* **Debugger doesn’t start** → install `codelldb` (Mason) and make sure your program is built with **Debug** (`-g`).
* **PATH issues** → ensure `~/.local/share/nvim/mason/bin` (Linux) or `%USERPROFILE%\AppData\Local\nvim-data\mason\bin` (Windows) is on PATH.

