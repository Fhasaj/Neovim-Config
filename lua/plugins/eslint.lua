return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                eslint = {
                    -- If Mason manages it, you usually don't need `cmd` here
                    settings = {
                        experimental = {
                            useFlatConfig = true,
                        },
                        -- Important: make ESLint search from the file up to project root
                        workingDirectory = { mode = "auto" },
                    },
                },
            },
        },
    },
}
