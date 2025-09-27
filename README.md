# Neovim-Config
My custom Neovim config based on NvChad. Do please use this a base for any projects you might have

## Dependencies 
All of these are based on Arch Linx For windows see the windows branch
1. [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
2. Clangd and Zip  `sudo pacman -S clangd && zip`

## Install 
1. Install Using the command listed for your OS
    For Linux and Mac

    `git clone https://github.com/Fhasaj/Neovim-Config ~/.config/nvim --depth 1 && nvim`

    For Windows (POWERSHELL)

    `git clone -b Windows https://github.com/Fhasaj/Neovim-Config "$ENV:USERPROFILE\AppData\Local\nvim" --depth 1 && nvim`

    For Windows (CMD)

    `git clone -b Windows https://github.com/Fhasaj/Neovim-Config %USERPROFILE%\AppData\Local\nvim --depth 1 && nvim`

2. Once Neovim is opened you might need to hit  SHIFT + U to update repo and then SHIFT + I to install. Once you have done that on your keyboard hit q and then :q to quite Neovim. 
3. Open neovim again and then type :MasonInstallAll this will install all the LSP that are needed to autocomple and syntax highlighting.
4. Enjoy 😄

## Plugins
1. Many beautiful themes, theme toggler by our base46 plugin
2. Lightweight & performant ui plugin with NvChad UI It provides statusline modules, tabufline ( tabs + buffer manager) , beautiful cheatsheets, NvChad updater, hide & unhide terminal buffers, theme switcher and much more!
3. File navigation with nvim-tree.lua
4. Beautiful and configurable icons with nvim-web-devicons
5.  Git diffs and more with gitsigns.nvim
6.  NeoVim Lsp configuration with nvim-lspconfig and mason.nvim
7.  Autocompletion with nvim-cmp
8.  File searching, previewing text files and more with telescope.nvim.
9.  Syntax highlighting with nvim-treesitter
10.  Autoclosing braces and html tags with nvim-autopairs
11. Indentlines with indent-blankline.nvim
12.  Useful snippets with friendly snippets + LuaSnip.
13. Popup mappings keysheet whichkey.nvim
14. Clangd LSP for C++
