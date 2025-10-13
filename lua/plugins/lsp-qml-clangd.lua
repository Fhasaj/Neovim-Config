return {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
    opts.servers = opts.servers or {}

    -- QML Language Server (ships with Qt 6 Declarative)
    opts.servers.qmlls = {
        cmd = { "qmlls" },             -- ensure it's on PATH (Qt6)
        filetypes = { "qml" },
        root_dir = function(fname)
        local lspconfig = require("lspconfig")
        return lspconfig.util.root_pattern("CMakeLists.txt", ".git")(fname)
        or lspconfig.util.path.dirname(fname)
        end,
        settings = {},                 -- defaults are fine
    }

    -- C/C++ (Qt projects via CMake + compile_commands.json)
    -- LazyVim usually sets clangd; keep it but add nice flags
    opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd or {}, {
        cmd = { "clangd",
            "--background-index",
            "--clang-tidy",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--pch-storage=memory",
        },
        init_options = {
            clangdFileStatus = true,
            fallbackFlags = { "-std=c++20" },
        },
    })

    return opts
    end,
}
