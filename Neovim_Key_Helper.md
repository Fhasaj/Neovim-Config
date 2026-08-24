# 🧠 Neovim Full Key Helper (LazyVim + Your Configuration)

This guide shows **exactly** what keys to press — no symbols, just real keys.

---

## 🔹 Basic Navigation

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Move up/down/left/right | `k`, `j`, `h`, `l` | Press **k** (up), **j** (down), **h** (left), **l** (right) |
| Move by word | `w` / `b` | Press **w** (forward), **b** (backward) |
| Go to start/end of line | `0` / `$` | Press **0** (zero) for start, **Shift + 4 ($)** for end |
| Page up / down | `<C-u>` / `<C-d>` | Hold **Ctrl**, press **u** or **d** |
| Top / bottom of file | `gg` / `G` | Press **g**, then **g** for top; **Shift + g** for bottom |

---

## 🔹 Editing Basics

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Enter insert mode | `i` | Press **i** |
| Append at end of line | `A` | Hold **Shift**, press **a** |
| Undo | `u` / `<C-z>` | Press **u** OR hold **Ctrl**, press **z** |
| Redo | `<C-r>` / `<C-y>` | Hold **Ctrl**, press **r** OR hold **Ctrl**, press **y** |
| Copy | `<C-c>` | Hold **Ctrl**, press **c** |
| Cut | `<C-x>` | Hold **Ctrl**, press **x** |
| Paste | `<C-v>` | Hold **Ctrl**, press **v** |
| Select line | `V` | Hold **Shift**, press **v** |
| Select block (column) | `<A-v>` | Hold **Alt**, press **v** |
| Delete line | `dd` | Press **d**, then **d** |
| Copy (yank) line | `yy` | Press **y**, then **y** |
| Paste after / before | `p` / `P` | Press **p** or **Shift + p** |

---

## 🔹 Window & Buffer Management

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Split window horizontally | `<leader>-` | Press **Space**, then **-** |
| Split window vertically | `<leader>|` | Press **Space**, then **Shift + \\** |
| Split window horizontally (direct) | `<C-->` | Hold **Ctrl**, press **-** |
| Split window vertically (direct) | `<C-\>` | Hold **Ctrl**, press **\** |
| Move between splits | `<C-h/j/k/l>` | Hold **Ctrl**, press **h**, **j**, **k**, or **l** |
| Resize split | `<C-Arrow keys>` | Hold **Ctrl**, then press an arrow key |
| Open file explorer | `<leader>e` | Press **Space**, then **e** |
| Close current window | `<leader>wd` | Press **Space**, then **w**, then **d** |
| Switch buffer | `<S-h>` / `<S-l>` | Hold **Shift**, press **h** (previous) or **l** (next) |
| Delete buffer | `<leader>bd` | Press **Space**, then **b**, then **d** |
---

## 🔹 File Management

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Save file | `<C-s>` | Hold **Ctrl**, press **s** |
| Save & Quit | `:wq` | Type **:wq** then press **Enter** |
| Quit without saving | `:q!` | Type **:q!** then press **Enter** |
| Open file finder | `<leader>ff` | Press **Space**, then **f**, then **f** |
| Open file finder (Telescope) | `<C-p>` | Hold **Ctrl**, press **p** |
| Search text (grep) | `<leader>/` | Press **Space**, then **/** |
| Search in files (Telescope live grep) | `<C-f>` | Hold **Ctrl**, press **f** |
| Recent files | `<leader>fr` | Press **Space**, then **f**, then **r** |
---


---


## 🔹 Terminal & Tabs

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Toggle horizontal terminal | `<C-`>` | Hold **Ctrl**, press **`** (backtick). If it doesn’t work in your terminal, use **Space + t + h** instead |
| Terminal → normal mode | `Esc` (in terminal) | While the cursor is inside the terminal, press **Escape** |
| New tab | `<C-t>` | Hold **Ctrl**, press **t** |
| Close tab | `<leader>tc` | Press **Space**, then **t**, then **c** |
| Next / Previous tab | `gt` / `gT` | Press **g**, then **t** for next; press **g**, then **Shift + t** for previous |

## 🔹 Commenting (Comment.nvim)

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Toggle comment (line / selection) | `<C-_>` | Hold **Ctrl**, press **/** (this is sent as Ctrl+underscore in Neovim) |
| Toggle line comment | `<leader>c/` | Press **Space**, then **c**, then **/** |
| Toggle block comment | `gbc` | Press **g**, then **b**, then **c** |
| Comment selected text | Visual select → `gc` | Select text, then press **g**, then **c** |
| Comment below / above | `gco` / `gcO` | Press **g**, then **c**, then **o** (or **Shift + o**) |
---

## 🔹 Troubleshooting / Diagnostics (Trouble.nvim)

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Open workspace diagnostics | `<leader>xx` | Press **Space**, then **x**, then **x** |
| Open file diagnostics | `<leader>xX` | Press **Space**, then **x**, then **Shift + x** |
| Show symbols (outline) | `<leader>xs` | Press **Space**, then **x**, then **s** |
| Show references/defs | `<leader>xl` | Press **Space**, then **x**, then **l** |
| Open quickfix list | `<leader>xq` | Press **Space**, then **x**, then **q** |
| Open Trouble (quick key) | `<F12>` | Press **F12** |

---

## 🔹 CMake Tools (for C++ Projects)

> ⚠️ These keys live under `<leader>c*`, the same prefix as clangd's LSP keys and CodeCompanion. Outside a `.cpp`/`.h` buffer (e.g. a `CMakeLists.txt`), the table below applies. Inside a C/C++ buffer, `<leader>cr`/`<leader>cd` are shadowed by clangd's buffer-local **Find References** / **Go to Definition** — see the C/C++ (clangd) section below for those.

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Configure CMake project | `<leader>cm` | Press **Space**, then **c**, then **m** |
| Select target & build | `<leader>cb` | Press **Space**, then **c**, then **b** |
| Select target & run | `<leader>cr` | Press **Space**, then **c**, then **r** |
| Select target & debug | `<leader>cd` | Press **Space**, then **c**, then **d** |
| Select build target only | `<leader>ct` | Press **Space**, then **c**, then **t** |
| Clean build | `<leader>cc` | Press **Space**, then **c**, then **c** |

---

## 🔹 C/C++ (clangd) — buffer-local LSP keys

These only apply while your cursor is in a `.c`/`.h`/`.cpp`/`.hpp` buffer (set in `lua/plugins/cpp.lua`); they override the generic LSP keys below and the CMake keys above for the same buffer.

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Go to definition | `<C-b>` | Hold **Ctrl**, press **b** |
| Go to definition (alt) | `<leader>cd` | Press **Space**, then **c**, then **d** |
| Find references / usages | `<A-F7>` | Hold **Alt**, press **F7** |
| Find references (alt) | `<leader>cr` | Press **Space**, then **c**, then **r** |
| Rename symbol | `<S-F6>` | Hold **Shift**, press **F6** |
| Rename symbol (alt) | `<leader>cn` | Press **Space**, then **c**, then **n** |
| Quick fix / code action | `<A-CR>` | Hold **Alt**, press **Enter** |
| Quick fix (alt) | `<leader>ca` | Press **Space**, then **c**, then **a** |
| Hover docs | `K` | Press **Shift + k** |
| Switch header ↔ source | `<leader>oh` | Press **Space**, then **o**, then **h** |

---

## 🔹 Go (vim-go)

Build/run/test helpers from `fatih/vim-go` (`lua/plugins/golang.lua`); gopls handles completion/diagnostics/formatting separately.

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Run current file/package | `<leader>gr` | Press **Space**, then **g**, then **r** |
| Build | `<leader>gb` | Press **Space**, then **g**, then **b** |
| Run all tests in file | `<leader>gt` | Press **Space**, then **g**, then **t** |
| Run test under cursor | `<leader>gtf` | Press **Space**, then **g**, then **t**, then **f** |
| Toggle coverage overlay | `<leader>gc` | Press **Space**, then **g**, then **c** |
| Jump to alternate file (test ↔ impl) | `<leader>ga` | Press **Space**, then **g**, then **a** |
| Run goimports | `<leader>gi` | Press **Space**, then **g**, then **i** |
| Fill struct literal | `<leader>gs` | Press **Space**, then **g**, then **s** |
| Insert `if err != nil` | `<leader>ge` | Press **Space**, then **g**, then **e** |
| Show GoDoc | `<leader>gd` | Press **Space**, then **g**, then **d** |
| Go to definition (vim-go) | `<leader>gv` | Press **Space**, then **g**, then **v** |

### 🐞 Go Debugging (nvim-dap + `.env` support)

Uses the standard DAP keys below. When you press **F5** in a `.go` file, since more than one Go configuration is registered, Neovim shows a picker — pick the one you need:

| Configuration in picker | What it does |
|---------|----------------|
| **Debug** | Debug current file, no extra environment injected |
| **Debug (.env)** | Debug current file with variables from the nearest `.env` injected |
| **Debug package (.env)** | Debug the package containing the current file, with `.env` injected |
| **Debug test (.env)** | `dlv test` the current package, with `.env` injected |

The `.env` lookup walks upward from the debugged file to the nearest `go.mod`/`.git`. See [`README.md`](./README.md#-go-debugging-with-env-files) for details.

---

## 🔹 Flutter / Dart (flutter-tools.nvim)

No custom leader keys are bound for Flutter — use these commands directly (type `:` then the command, press **Enter**). DAP debugging (`<F5>`, breakpoints, etc. — see below) works automatically once a Flutter app is running.

| Action | Command |
|---------|----------------|
| Run the app | `:FlutterRun` |
| Hot reload | `:FlutterHotReload` |
| Hot restart | `:FlutterHotRestart` |
| Pick a device | `:FlutterDevices` |
| Open dev log | `:FlutterLogClear` then `:FlutterLogToggle` |
| Quit the running app | `:FlutterQuit` |
| Toggle widget outline guides | Enabled by default (`widget_guides.enabled = true`) |

---

## 🔹 Debugging (nvim-dap + dap-ui) — C/C++, Go, TypeScript/JavaScript, Dart

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Start / Continue (shows config picker if more than one applies) | `<F5>` | Press **F5** |
| Step Over | `<F10>` | Press **F10** |
| Step Into | `<F11>` | Press **F11** |
| Step Out | `<S-F11>` | Hold **Shift**, press **F11** |
| Toggle breakpoint | `<leader>db` | Press **Space**, then **d**, then **b** |
| Conditional breakpoint | `<leader>dB` | Press **Space**, then **d**, then **Shift + b** |
| Open REPL (interactive console) | `<leader>dr` | Press **Space**, then **d**, then **r** |
| Toggle DAP UI (debug panels) | `<leader>du` | Press **Space**, then **d**, then **u** |

---

## 🔹 LSP (Language Server) — generic default keys

Applies to any language without its own buffer-local overrides (Go, Dart, TypeScript/JavaScript). C/C++ has its own set — see the clangd section above.

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Go to definition | `gd` | Press **g**, then **d** |
| **Go to definition (mouse, any file)** | `<C-LeftMouse>` | Hold **Ctrl**, **left-click** a symbol — jumps to its definition, opening another file if needed |
| Find references | `gr` | Press **g**, then **r** |
| Show hover docs | `K` | Press **Shift + k** |
| Rename symbol | `<leader>cr` | Press **Space**, then **c**, then **r** |
| Code actions (quick fix) | `<leader>ca` | Press **Space**, then **c**, then **a** |
| Format file | `<leader>cf` | Press **Space**, then **c**, then **f** |

> Ctrl+Click works everywhere an LSP is attached — Go, TypeScript/JS, Dart, and C/C++ (clangd's `<C-b>` keeps working too). Set up in `lua/config/keymaps.lua`. If it does nothing in your terminal, the terminal emulator itself may be intercepting Ctrl+click (common for opening URLs) before it reaches Neovim — check your terminal's keybinding settings.

---


## 🔹 AI Code Assistant — CodeCompanion (`<leader>c*`)

Chat/inline-edit assistant wired to a local Ollama model (`lua/plugins/codecompanion.lua`). Shares the `<leader>c*` prefix with clangd/CMake — see the troubleshooting note in `README.md` if a key seems to do the "wrong" thing outside a C/C++ buffer.

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Open/toggle AI chat | `<leader>cc` | Press **Space**, then **c**, then **c** (also works on a visual selection) |
| Close AI chat | `<leader>cq` | Press **Space**, then **c**, then **q** |
| Inline edit selection | `<leader>ce` or `<leader>ci` | Select code, then **Space**, **c**, **e** (or **i**) |
| Actions menu | `<leader>ca` | Press **Space**, then **c**, then **a** |
| Code Review prompt | `<leader>cr` | Press **Space**, then **c**, then **r** |
| Explain code prompt | `<leader>cx` | Press **Space**, then **c**, then **x** |
| Add current buffer to chat | `<leader>cb` | Press **Space**, then **c**, then **b** |
| Add visual selection to chat | `<leader>cb` (visual mode) | Select code, then **Space**, **c**, **b** |
| Quick inline fix | `<leader>cf` | Select code, then **Space**, **c**, **f** |
| Quick inline optimize | `<leader>cp` | Select code, then **Space**, **c**, **p** |

> `opencode.nvim` (a second AI chat plugin) was removed — CodeCompanion above is now the only AI chat assistant, since it's already wired to a local Ollama model and there's no need for two overlapping tools.

---

## 🔹 Git (gitui + gitsigns)

Confirmed working: `git`, `lazygit`, and `gitui` are all available (`gitui` via Mason, on Neovim's runtime `PATH`). The `util.gitui` extra swaps LazyVim's default Lazygit keys for GitUI and drops two history keys in its favor.

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Open GitUI (project root) | `<leader>gg` | Press **Space**, then **g**, then **g** |
| Open GitUI (cwd) | `<leader>gG` | Press **Space**, then **g**, then **Shift + g** |
| Git log (cwd) | `<leader>gL` | Press **Space**, then **g**, then **Shift + l** |
| Git blame line (picker) | `<leader>gb` | Press **Space**, then **g**, then **b** |
| Git browse (open remote) | `<leader>gB` | Press **Space**, then **g**, then **Shift + b** |
| Copy git permalink | `<leader>gY` | Press **Space**, then **g**, then **Shift + y** |

### Gitsigns hunks (in any file under git)

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Next / previous hunk | `]h` / `[h` | Press **]**, then **h** (next) or **[**, then **h** (previous) |
| Last / first hunk | `]H` / `[H` | Press **]**/**[**, then **Shift + h** |
| Stage hunk | `<leader>ghs` | Press **Space**, then **g**, **h**, **s** |
| Reset hunk | `<leader>ghr` | Press **Space**, then **g**, **h**, **r** |
| Undo stage hunk | `<leader>ghu` | Press **Space**, then **g**, **h**, **u** |
| Preview hunk inline | `<leader>ghp` | Press **Space**, then **g**, **h**, **p** |
| Blame current line | `<leader>ghb` | Press **Space**, then **g**, **h**, **b** |
| Blame whole buffer | `<leader>ghB` | Press **Space**, then **g**, **h**, **Shift + b** |
| Select hunk (text object) | `ih` | e.g. `dih` deletes the current hunk |

---

## 🔹 LazyVim UI Toggles

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Switch theme (Themery picker) | `<leader>ut` | Press **Space**, then **u**, then **t** — see [Themes](./README.md#-themes) |
| Toggle relative numbers | `<leader>uL` | Press **Space**, then **u**, then **Shift + l** |
| Toggle wrap | `<leader>uw` | Press **Space**, then **u**, then **w** |
| Clear search highlights | `<leader>ur` | Press **Space**, then **u**, then **r** |
| Toggle autoformat on save | `<leader>uf` | Press **Space**, then **u**, then **f** |

---

## 🏁 TL;DR Most Important Keys

| What You’ll Do Most | Press This |
|----------------------|-------------|
| Save | **Ctrl + S** |
| Quit | **:q** or **:wq** |
| Comment line | **Ctrl + /** (or **Space + c + /**) |
| Open file finder | **Space + f + f** |
| Open diagnostics (Trouble) | **F12** |
| Configure CMake | **Space + c + m** |
| Build (CMake) | **Space + c + b** |
| Debug (CMake) | **Space + c + d** |
| Debug (Go/C++/TS/Dart, DAP) | **F5** (then pick a config, e.g. Go's `.env` variants) |
| Toggle breakpoint | **Space + d + b** |
| Step / Continue | **F10** / **F5** |
| Toggle DAP UI | **Space + d + u** |
| AI chat (CodeCompanion, local Ollama) | **Space + c + c** |
| Switch theme | **Space + u + t** |
| Open GitUI | **Space + g + g** |

---

Made for **LazyVim + Your Configuration (C++, Go, Dart/Flutter, TypeScript/JavaScript, Next.js/React)**.
