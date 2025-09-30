return {
  {
    "sainnhe/everforest",
    lazy = false, -- Set to false to load it immediately
    priority = 1000, -- Give it a high priority to load before other plugins
    config = function()
      -- Optional: Configure Everforest
      -- For example, to enable italic comments or set the background contrast:
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = 'medium' -- or 'hard', 'soft'

      -- Set the colorscheme
      vim.cmd.colorscheme("everforest")
    end,
  },
}

-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000, -- Ensure it loads first
--   lazy = false,    -- Make sure it's not lazy-loaded
--   opts = {
--     flavour = "mocha", -- Change to latte, frappe, macchiato, or mocha
--     integrations = {
--       cmp = true,
--       gitsigns = true,
--       nvimtree = true,
--       treesitter = true,
--       telescope = true,
--       notify = true,
--       mini = true,
--       leap = true,
--       -- Add more integrations if needed
--     },
--   },
--   config = function(_, opts)
--     require("catppuccin").setup(opts)
--     vim.cmd.colorscheme("catppuccin")
--   end,
-- }

-- return {
--   "navarasu/onedark.nvim",
--   priority = 1000,
--   lazy = false,
--   opts = {
--     style = "deep", -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
--   },
--   config = function(_, opts)
--     require("onedark").setup(opts)
--     require("onedark").load()
--   end,
-- }


-- return {
--   "olimorris/onedarkpro.nvim",
--   priority = 1000,
--   lazy = false,
--   opts = {
--     colors = {}, -- optional: override colors here
--     highlights = {}, -- optional: override highlight groups here
--     options = {
--       transparency = false,
--       terminal_colors = true,
--       highlight_inactive_windows = true,
--     },
--   },
--   config = function(_, opts)
--     require("onedarkpro").setup(opts)
--     vim.cmd.colorscheme("onedark") -- or "onelight" or "onelightpro"
--   end,
-- }
