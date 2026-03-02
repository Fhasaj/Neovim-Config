return {
  -- ============================================
  -- OpenCode: Agentic "Build/Plan" inside Neovim
  -- Uses your ~/.config/opencode/opencode.json
  -- ============================================
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
    vim.o.autoread = true

    -- Optional: if your shell PATH isn't available inside Neovim,
    -- you can set it here (uncomment and edit if needed).
    -- vim.env.PATH = vim.env.PATH .. ":/home/youruser/.local/bin"

    vim.g.opencode_opts = {
      -- leave empty to use defaults + your opencode.json
    }

    local oc = require("opencode")

    -- OpenCode UI toggle
    vim.keymap.set({ "n", "v" }, "<leader>oo", function()
    oc.toggle()
    end, { desc = "OpenCode: Toggle" })

    -- OpenCode action picker (Build-mode actions, etc.)
    vim.keymap.set({ "n", "v" }, "<leader>oa", function()
    oc.select()
    end, { desc = "OpenCode: Actions" })

    -- Ask about current buffer / context
    vim.keymap.set({ "n", "v" }, "<leader>op", function()
    oc.ask("@this: ", { submit = true })
    end, { desc = "OpenCode: Prompt (@this)" })

    -- Ask about visual selection
    vim.keymap.set("v", "<leader>os", function()
    oc.ask("@selection: ", { submit = true })
    end, { desc = "OpenCode: Prompt (@selection)" })

    -- Quick open (handy mnemonics)
    vim.keymap.set("n", "<leader>ob", function()
    oc.toggle()
    end, { desc = "OpenCode: Open (Build)" })

    vim.keymap.set("n", "<leader>ol", function()
    oc.toggle()
    end, { desc = "OpenCode: Open (Plan)" })
    end,
  },

  -- ============================================
  -- Avante: Copilot-Style Autocomplete (local)
  -- Uses: qwen2.5-coder:7b (fast)
  -- ============================================
--   {
--     "yetone/avante.nvim",
--     event = "VeryLazy",
--     lazy = false,
--     version = false,
--     build = "make",
--     dependencies = {
--       "nvim-treesitter/nvim-treesitter",
--       "stevearc/dressing.nvim",
--       "nvim-lua/plenary.nvim",
--       "MunifTanjim/nui.nvim",
--       "nvim-tree/nvim-web-devicons",
--     },
--     opts = {
--       provider = "ollama",
--       auto_suggestions_provider = "ollama",
--       vendors = {
--         ollama = {
--           __inherited_from = "openai",
--           api_key_name = "",
--           endpoint = "http://127.0.0.1:11434/v1",
--           model = "qwen2.5-coder:7b",
--           timeout = 30000,
--           temperature = 0,
--
--           -- 4096 is huge for autocomplete; smaller = faster
--           max_tokens = 128,
--         },
--       },
--       behaviour = {
--         auto_suggestions = true,
--         auto_set_highlight_group = true,
--         auto_set_keymaps = true,
--         auto_apply_diff_after_generation = false,
--         support_paste_from_clipboard = false,
--       },
--       mappings = {
--         diff = {
--           ours = "co",
--           theirs = "ct",
--           all_theirs = "ca",
--           both = "cb",
--           cursor = "cc",
--           next = "]x",
--           prev = "[x",
--         },
--         suggestion = {
--           accept = "<Tab>",
--           next = "<M-]>",
--           prev = "<M-[>",
--           dismiss = "<C-]>",
--         },
--         jump = {
--           next = "]]",
--           prev = "[[",
--         },
--         submit = {
--           normal = "<CR>",
--           insert = "<C-s>",
--         },
--       },
--       hints = { enabled = true },
--       windows = {
--         position = "right",
--         wrap = true,
--         width = 30,
--         sidebar_header = {
--           align = "center",
--           rounded = true,
--         },
--       },
--       highlights = {
--         diff = {
--           current = "DiffText",
--           incoming = "DiffAdd",
--         },
--       },
--       diff = {
--         autojump = true,
--         list_opener = "copen",
--       },
--     },
--   },

  -- ============================================
  -- Disable Copilot (we're using local models)
  -- ============================================
  { "github/copilot.vim", enabled = false },
  { "zbirenbaum/copilot.lua", enabled = false },
}
