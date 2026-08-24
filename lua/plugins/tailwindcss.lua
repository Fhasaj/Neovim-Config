return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                tailwindcss = {
                    cmd = { "tailwindcss-language-server", "--stdio" },
                    filetypes = {
                        "html","css","scss","javascript","javascriptreact",
                        "typescript","typescriptreact","vue","svelte"
                    },
                    -- root_dir intentionally NOT overridden: the old sync `lspconfig.util.root_pattern(...)`
                    -- silently breaks vim.lsp.enable()'s auto-attach (see lua/plugins/gopls.lua for details).
                    -- nvim-lspconfig's bundled default already resolves tailwind/postcss config roots correctly.
                },
            },
        },
    },
}
