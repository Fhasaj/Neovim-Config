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
                    root_dir = require("lspconfig.util").root_pattern(
                        "tailwind.config.js","tailwind.config.cjs",
                        "tailwind.config.ts","tailwind.config.mjs",
                        "postcss.config.js","package.json",".git"
                    ),
                },
            },
        },
    },
}
