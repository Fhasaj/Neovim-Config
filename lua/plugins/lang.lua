-- Language tooling: which servers/formatters/debuggers Mason installs, plus the
-- handful of server settings worth overriding.
--
-- The languages themselves are enabled as LazyVim extras (see lazyvim.json):
-- clangd, cmake, dart, go, json, markdown, python, sql, tailwind, typescript.
-- Each extra already wires up its LSP, treesitter parsers, formatter and (where
-- one exists) debug adapter, so this file only covers the gaps.
return {
  -- Tools Mason should keep installed. Servers listed under `opts.servers`
  -- below are installed automatically by mason-lspconfig and don't need to be
  -- repeated here; this list is for formatters, linters and debug adapters.
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- C / C++
        "clang-format",
        "codelldb",
        -- Go
        "delve",
        "gofumpt",
        "goimports",
        "gomodifytags",
        "impl",
        "golangci-lint",
        -- Web
        "prettier",
        "js-debug-adapter",
        -- Python
        "ruff",
        "debugpy",
        -- Shell / Lua / misc
        "shfmt",
        "shellcheck",
        "stylua",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- QML. `qmlls` ships with Qt 6 Declarative and is also available
        -- through Mason; it needs to be on PATH either way.
        qmlls = {
          cmd = { "qmlls" },
          filetypes = { "qml", "qmljs" },
          root_markers = { "CMakeLists.txt", ".qmlls.ini", ".git" },
        },

        -- clangd, tuned for Qt/CMake projects. Needs a compile_commands.json —
        -- generate one with `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`.
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--function-arg-placeholders",
            "--pch-storage=memory",
          },
          init_options = {
            clangdFileStatus = true,
            fallbackFlags = { "-std=c++20" },
          },
        },

        -- gopls: the analyses that catch real bugs, plus inlay hints.
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              usePlaceholders = true,
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- Parsers for the languages above plus the ones that show up around them.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "dart",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "python",
        "qmljs",
        "sql",
        "tsx",
        "typescript",
        "yaml",
      })
    end,
  },

  -- QML syntax for the bits treesitter's qmljs parser doesn't cover.
  { "peterhoeg/vim-qml", ft = { "qml", "qmljs" } },
}
