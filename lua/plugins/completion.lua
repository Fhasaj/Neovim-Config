-- Autocompletion.
--
-- LazyVim's engine is blink.cmp. It already completes from the LSP, snippets,
-- the current buffer and file paths for every language — including all the ones
-- enabled in lazyvim.json — so this file only changes the feel of it:
-- VS Code-style keys and a slightly more eager popup.
return {
  {
    "saghen/blink.cmp",
    dependencies = { "olimorris/codecompanion.nvim" },
    opts = {
      keymap = {
        -- Enter accepts, Tab/Shift-Tab move through the list and jump between
        -- snippet placeholders, Ctrl+Space opens it on demand, Ctrl+E dismisses.
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        -- Ctrl+Up/Down scroll the documentation window.
        ["<C-Up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-Down>"] = { "scroll_documentation_down", "fallback" },
      },

      completion = {
        -- Show the popup quickly but not on the very first keystroke, which
        -- otherwise fires a request per character on large Go/C++ projects.
        trigger = { show_on_trigger_character = true },
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { border = "rounded", draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 150, window = { border = "rounded" } },
        -- Grey inline preview of the selected item (LazyVim already enables
        -- this; left to its default so it defers to AI suggestions correctly).
      },

      signature = { enabled = true, window = { border = "rounded" } },

      -- LazyVim already sets `sources.default` to lsp/path/snippets/buffer (and
      -- extras add their own, e.g. dadbod for SQL). Listing them again here
      -- would append duplicates, so only the new provider is declared.
      sources = {
        providers = {
          -- Slash commands, /file, #buffer and variable completion inside the
          -- CodeCompanion chat buffer.
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
            score_offset = 100,
          },
        },
        -- Add the CodeCompanion source only in its own buffer.
        per_filetype = {
          codecompanion = { "codecompanion", "buffer" },
        },
      },
    },
  },
}
