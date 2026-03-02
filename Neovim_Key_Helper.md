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

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Configure CMake project | `<leader>mc` | Press **Space**, then **m**, then **c** |
| Build current target | `<leader>mb` | Press **Space**, then **m**, then **b** |
| Select build target | `<leader>mt` | Press **Space**, then **m**, then **t** |
| Run target | `<leader>mr` | Press **Space**, then **m**, then **r** |
| Debug target | `<leader>md` | Press **Space**, then **m**, then **d** |

---

## 🔹 Debugging (nvim-dap + dap-ui)

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Start / Continue | `<F5>` | Press **F5** |
| Step Over | `<F10>` | Press **F10** |
| Step Into | `<F11>` | Press **F11** |
| Step Out | `<S-F11>` | Hold **Shift**, press **F11** |
| Toggle breakpoint | `<leader>db` | Press **Space**, then **d**, then **b** |
| Conditional breakpoint | `<leader>dB` | Press **Space**, then **d**, then **Shift + b** |
| Open REPL (interactive console) | `<leader>dr` | Press **Space**, then **d**, then **r** |
| Toggle DAP UI (debug panels) | `<leader>du` | Press **Space**, then **d**, then **u** |

---

## 🔹 LSP (Language Server)

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Go to definition | `gd` | Press **g**, then **d** |
| Find references | `gr` | Press **g**, then **r** |
| Show hover docs | `K` | Press **Shift + k** |
| Rename symbol | `<leader>cr` | Press **Space**, then **c**, then **r** |
| Code actions (quick fix) | `<leader>ca` | Press **Space**, then **c**, then **a** |
| Format file | `<leader>cf` | Press **Space**, then **c**, then **f** |

---


## 🔹 AI Code Assistant (CodeCompanion)

| Action | Key Combo | What to Press |
|---------|------------|----------------|
| Toggle AI chat | `<leader>zz` | Press **Space**, then **z**, then **z** |
| AI actions menu | `<leader>za` | Press **Space**, then **z**, then **a** |
| Add selection to chat | `<leader>zc` | Select code, then **Space**, **z**, **c** |
| AI edit selection | `<leader>ze` | Select code, then **Space**, **z**, **e** |
| AI fix code | `<leader>zf` | Select code, then **Space**, **z**, **f** |
| AI refactor | `<leader>zr` | Select code, then **Space**, **z**, **r** |
| AI explain | `<leader>zx` | Select code, then **Space**, **z**, **x** |
| AI add docstring | `<leader>zd` | Select code, then **Space**, **z**, **d** |
| AI generate tests | `<leader>zt` | Select code, then **Space**, **z**, **t** |
| AI custom prompt | `<leader>zi` | Select code, then **Space**, **z**, **i**, type instruction |

---


## 🔹 LazyVim UI Toggles

| Action | Key Combo | What to Press |
|---------|------------|----------------|
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
| Build (CMake) | **Space + m + b** |
| Debug (CMake / DAP) | **Space + m + d** |
| Toggle breakpoint | **Space + d + b** |
| Step / Continue | **F10** / **F5** |
| Toggle DAP UI | **Space + d + u** |

---

Made for **LazyVim + Your Configuration (C++, Go, Dart, Node.js)**.
