-- lua/plugins/tsserver.lua
return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                ts_ls = {
                    cmd = { "typescript-language-server", "--stdio" },
                    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                    root_dir = require("lspconfig.util").root_pattern(
                        "package.json", "tsconfig.json", "jsconfig.json", ".git"
                    ),
                },
            },
        },
    },
}
