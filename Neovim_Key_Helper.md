# Keymap reference

Leader is `<Space>`. This config layers VS Code-style shortcuts on top of
LazyVim's defaults — press `<Space>` and wait to see the leader menu, or
`<leader>sk` to search every keymap.

## Clipboard, undo, save

| Key | Does |
| --- | --- |
| `Ctrl+C` | copy selection (normal mode: copy line) |
| `Ctrl+X` | cut selection (normal mode: cut line) |
| `Ctrl+V` | paste — works in normal, visual, insert, command and terminal mode |
| `Ctrl+A` | select all |
| `Ctrl+Z` | undo (normal, insert, visual) |
| `Ctrl+Y` / `Ctrl+Shift+Z` | redo |
| `Ctrl+S` | save · `Ctrl+Shift+S` save all |
| `Ctrl+Q` / `Alt+V` | visual **block** mode (`Ctrl+V` is paste here) |

`clipboard=unnamedplus` is on, so plain `y`, `d` and `p` use the system
clipboard too.

## Mouse

| Action | Does |
| --- | --- |
| Right-click | context menu: cut/copy/paste, go to definition, find references, rename, code action, toggle comment, format |
| `Ctrl`+left-click | go to definition |
| Middle-click | paste the X11 primary selection |

## Finding things

| Key | Does |
| --- | --- |
| `Ctrl+P` | find file |
| `Ctrl+Shift+P` | command palette |
| `Ctrl+Shift+F` | grep the project |
| `Ctrl+F` | search in the current file (starts a `/` search) |
| `Ctrl+G` | jump to a line in the current file |
| `Ctrl+B` | toggle the file explorer |

## Editing

| Key | Does |
| --- | --- |
| `Ctrl+/` | toggle comment (line, or selection in visual mode) |
| `Ctrl+N` | add a cursor at the next occurrence of the word (VS Code's `Ctrl+D`) |
| `Ctrl+Shift+N` | select all occurrences |
| `Alt+Shift+Up/Down` | move the line or selection |
| `Ctrl+PageUp/PageDown` | previous / next buffer |
| `Ctrl+T` | new buffer · `Ctrl+Shift+T` new tab page |

## Completion

Completion is automatic in every language. `blink.cmp` sources the LSP,
snippets, the buffer and file paths.

| Key | Does |
| --- | --- |
| `Enter` | accept |
| `Tab` / `Shift+Tab` | next / previous item, and jump between snippet fields |
| `Ctrl+Space` | open the menu, or toggle documentation |
| `Ctrl+Up/Down` | scroll the documentation window |
| `Ctrl+E` | dismiss |

## Windows and terminal

| Key | Does |
| --- | --- |
| `Ctrl+H/J/K/L` | move focus between windows (and tmux panes) |
| `Alt+Left/Down/Up/Right` | resize the current window |
| `Alt+Shift+H/J/K/L` | swap this window with its neighbour |
| `Alt+\` / `Alt+-` | split right / split below |
| `Alt+W` close window · `Alt+M` maximize · `Alt+=` equalize |
| `Ctrl+\` (or ``Ctrl+` ``) | toggle the floating terminal |
| `<leader>tf` / `<leader>th` / `<leader>tv` | terminal: float / horizontal / vertical |
| `Esc Esc` | leave terminal insert mode |

## Local AI (`<leader>a`) — Ollama, nothing leaves the machine

| Key | Does |
| --- | --- |
| `<leader>aa` | toggle the chat panel |
| `<leader>an` | new chat |
| `<leader>ai` | inline edit the selection, or prompt at the cursor |
| `<leader>ac` | action palette (explain, fix, tests, commit message…) |
| `<leader>ad` | add the visual selection to the open chat |
| `<leader>am` | pick a different Ollama model (`:CodeCompanionModel`) |

Host and model are set in `lua/config/options.lua` (`vim.g.ollama_host`,
`vim.g.ollama_model`). `<leader>am` lists what the daemon actually has pulled.

## Theme

`<leader>ut` opens the picker: type to filter, move to preview live, `Enter` to
keep it. The choice survives restarts. Themes are declared in
`lua/plugins/colorscheme.lua`.

## Language-specific

| Key | Does |
| --- | --- |
| `<leader>G…` | Go actions — fill struct, if-err, add tags, implement interface… |
| `<leader>Gr` / `<leader>GR` | run the current Go service / pick one (env file loaded) |
| `<leader>f…` | Flutter — hot reload/restart, devices, emulators, outline, dev log |
| `<leader>qd` | open the current file in Qt Designer |
| `<leader>o…` | Overseer tasks — run, task list, quick action |
| `<leader>d…`, `F5`/`F9`/`F10`/`F11` | debugging (see `Go_Backend_Keys.md`) |

Everything LazyVim binds still works: `gd` definition, `gr` references,
`<leader>cr` rename, `<leader>ca` code action, `]d`/`[d` diagnostics,
`<leader>gg` lazygit, `<leader>bd` close buffer.
