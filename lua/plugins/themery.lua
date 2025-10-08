-- lua/plugins/themery.lua
return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 1000,
    keys = {
      { "<leader>ut", "<cmd>Themery<cr>", desc = "Theme: Switch (Themery)" },
    },
    config = function()
      local themes = {
        -- Everforest (light/dark via :set background)
        {
          name = "Everforest (Dark)",
          colorscheme = "everforest",
          before = [[
            vim.o.background = "dark"
            vim.g.everforest_enable_italic = true
            vim.g.everforest_background = "medium"
          ]],
        },
        {
          name = "Everforest (Light)",
          colorscheme = "everforest",
          before = [[
            vim.o.background = "light"
            vim.g.everforest_enable_italic = true
            vim.g.everforest_background = "soft"
          ]],
        },

        -- Tokyo Night (official light/day + dark)
        { name = "Tokyo Night (Night)", colorscheme = "tokyonight-night",
          before = [[pcall(function() require("tokyonight").setup({}) end)]] },
        { name = "Tokyo Night (Day)",   colorscheme = "tokyonight-day",
          before = [[pcall(function() require("tokyonight").setup({}) end)]] },

        -- Catppuccin (Latte light / Mocha dark)
        { name = "Catppuccin (Mocha)", colorscheme = "catppuccin",
          before = [[local ok, c = pcall(require,"catppuccin"); if ok then c.setup({ flavour="mocha" }) end]] },
        { name = "Catppuccin (Latte)", colorscheme = "catppuccin",
          before = [[local ok, c = pcall(require,"catppuccin"); if ok then c.setup({ flavour="latte" }) end; vim.o.background="light"]] },

        -- Kanagawa (Lotus light / Dragon dark)
        { name = "Kanagawa (Dragon)", colorscheme = "kanagawa-dragon",
          before = [[pcall(function() require("kanagawa").setup({}) end)]] },
        { name = "Kanagawa (Lotus)",  colorscheme = "kanagawa-lotus",
          before = [[pcall(function() require("kanagawa").setup({}) end)]] },

        -- Nightfox (Dayfox light / Nightfox dark)
        { name = "Nightfox (Night)", colorscheme = "nightfox",
          before = [[pcall(function() require("nightfox").setup({}) end)]] },
        { name = "Nightfox (Day)",   colorscheme = "dayfox",
          before = [[pcall(function() require("nightfox").setup({}) end)]] },

        -- GitHub (official light/dark)
        { name = "GitHub (Dark Default)",  colorscheme = "github_dark_default",
          before = [[pcall(function() require("github-theme").setup({}) end)]] },
        { name = "GitHub (Light Default)", colorscheme = "github_light_default",
          before = [[pcall(function() require("github-theme").setup({}) end)]] },

        -- Rosé Pine (Dawn light / Main dark)
        { name = "Rosé Pine (Main)", colorscheme = "rose-pine",
          before = [[pcall(function() require("rose-pine").setup({}) end); vim.o.background="dark"]] },
        { name = "Rosé Pine (Dawn)", colorscheme = "rose-pine-dawn",
          before = [[pcall(function() require("rose-pine").setup({}) end); vim.o.background="light"]] },

        -- Oxocarbon (same scheme, switch by background)
        { name = "Oxocarbon (Dark)",  colorscheme = "oxocarbon",
          before = [[vim.o.background="dark"]] },
        { name = "Oxocarbon (Light)", colorscheme = "oxocarbon",
          before = [[vim.o.background="light"]] },

        -- Gruvbox (one scheme, switch by background)
        { name = "Gruvbox (Dark)",  colorscheme = "gruvbox",
          before = [[vim.o.background="dark"]] },
        { name = "Gruvbox (Light)", colorscheme = "gruvbox",
          before = [[vim.o.background="light"]] },

        -- One Dark Pro (has both)
        { name = "OneDark Pro (Dark)",  colorscheme = "onedark",
          before = [[local ok, odp = pcall(require,"onedarkpro"); if ok then odp.setup({}) end]] },
        { name = "OneDark Pro (Light)", colorscheme = "onelight",
          before = [[local ok, odp = pcall(require,"onedarkpro"); if ok then odp.setup({}) end; vim.o.background="light"]] },

        -- Material (lighter/light & darker/dark)
        { name = "Material (Darker)", colorscheme = "material",
          before = [[vim.g.material_style="darker"; pcall(function() require("material").setup({}) end)]] },
        { name = "Material (Lighter)", colorscheme = "material",
          before = [[vim.g.material_style="lighter"; pcall(function() require("material").setup({}) end); vim.o.background="light"]] },

        -- Ayu (mirage dark / light)
        { name = "Ayu (Mirage)", colorscheme = "ayu",
          before = [[vim.g.ayucolor="mirage"; pcall(function() require("ayu").setup({}) end)]] },
        { name = "Ayu (Light)",  colorscheme = "ayu",
          before = [[vim.g.ayucolor="light";  pcall(function() require("ayu").setup({}) end); vim.o.background="light"]] },
      }

      -- (Optional) Auto-append any other installed schemes you already have.
      do
        local seen, add = {}, {}
        for _, t in ipairs(themes) do
          local name = type(t) == "string" and t or t.colorscheme
          if name then seen[name] = true end
        end
        for _, cs in ipairs(vim.fn.getcompletion("", "color")) do
          if not seen[cs] and cs ~= "default" then table.insert(add, cs) end
        end
        for _, cs in ipairs(add) do table.insert(themes, cs) end
      end

      require("themery").setup({
        livePreview = true,
        themes = themes,
      })
    end,

    -- Install the popular theme plugins so the list works out-of-the-box
    dependencies = {
      { "sainnhe/everforest",                lazy = true },
      { "folke/tokyonight.nvim",            lazy = true },
      { "catppuccin/nvim",  name = "catppuccin", lazy = true },
      { "rebelot/kanagawa.nvim",            lazy = true },
      { "EdenEast/nightfox.nvim",           lazy = true },
      { "projekt0n/github-nvim-theme",      lazy = true },
      { "rose-pine/neovim", name = "rose-pine",   lazy = true },
      { "nyoom-engineering/oxocarbon.nvim", lazy = true },
      { "ellisonleao/gruvbox.nvim",         lazy = true },
      { "olimorris/onedarkpro.nvim",        lazy = true },
      { "marko-cerovac/material.nvim",      lazy = true },
      { "Shatur/neovim-ayu",                lazy = true },
      -- Add more later; They’ll auto-appear thanks to the installed-scan block
    },
  },

  -- Let Themery own the colorscheme (don’t force one elsewhere)
  -- { "LazyVim/LazyVim", opts = { colorscheme = nil } },
}
