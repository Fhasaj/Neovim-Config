return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    cmd = { "gopls" },
                    filetypes = { "go", "gomod", "gowork", "gotmpl" },
                    -- root_dir intentionally NOT overridden: nvim-lspconfig's bundled default
                    -- uses the newer async `function(bufnr, on_dir)` signature required by
                    -- vim.lsp.enable()'s auto-attach; the old `lspconfig.util.root_pattern(...)`
                    -- (sync, single-arg) silently breaks auto-attach for real buffers.
                },
            },
        },
    },
}
