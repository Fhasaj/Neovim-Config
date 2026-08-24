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
      {
        name = "Tokyo Night (Night)",
        colorscheme = "tokyonight-night",
        before = [[pcall(function() require("tokyonight").setup({}) end)]],
      },
      {
        name = "Tokyo Night (Day)",
        colorscheme = "tokyonight-day",
        before = [[pcall(function() require("tokyonight").setup({}) end)]],
      },
      -- Catppuccin (Latte light / Mocha dark)
      {
        name = "Catppuccin (Mocha)",
        colorscheme = "catppuccin",
        before = [[local ok, c = pcall(require,"catppuccin"); if ok then c.setup({ flavour="mocha" }) end]],
      },
      {
        name = "Catppuccin (Latte)",
        colorscheme = "catppuccin",
        before = [[local ok, c = pcall(require,"catppuccin"); if ok then c.setup({ flavour="latte" }) end; vim.o.background="light"]],
      },
      -- Kanagawa (Lotus light / Dragon dark)
      {
        name = "Kanagawa (Dragon)",
        colorscheme = "kanagawa-dragon",
        before = [[pcall(function() require("kanagawa").setup({}) end)]],
      },
      {
        name = "Kanagawa (Lotus)",
        colorscheme = "kanagawa-lotus",
        before = [[pcall(function() require("kanagawa").setup({}) end)]],
      },
      -- Nightfox (Dayfox light / Nightfox dark)
      {
        name = "Nightfox (Night)",
        colorscheme = "nightfox",
        before = [[pcall(function() require("nightfox").setup({}) end)]],
      },
      {
        name = "Nightfox (Day)",
        colorscheme = "dayfox",
        before = [[pcall(function() require("nightfox").setup({}) end)]],
      },
      -- GitHub (official light/dark)
      {
        name = "GitHub (Dark Default)",
        colorscheme = "github_dark_default",
        before = [[pcall(function() require("github-theme").setup({}) end)]],
      },
      {
        name = "GitHub (Light Default)",
        colorscheme = "github_light_default",
        before = [[pcall(function() require("github-theme").setup({}) end)]],
      },
      -- Rosé Pine (Dawn light / Main dark)
      {
        name = "Rosé Pine (Main)",
        colorscheme = "rose-pine",
        before = [[pcall(function() require("rose-pine").setup({}) end); vim.o.background="dark"]],
      },
      {
        name = "Rosé Pine (Dawn)",
        colorscheme = "rose-pine-dawn",
        before = [[pcall(function() require("rose-pine").setup({}) end); vim.o.background="light"]],
      },
      -- Gruvbox (one scheme, switch by background)
      {
        name = "Gruvbox (Dark)",
        colorscheme = "gruvbox",
        before = [[vim.o.background="dark"]],
      },
      {
        name = "Gruvbox (Light)",
        colorscheme = "gruvbox",
        before = [[vim.o.background="light"]],
      },
      -- One Dark Pro (has both)
      {
        name = "OneDark Pro (Dark)",
        colorscheme = "onedark",
        before = [[local ok, odp = pcall(require,"onedarkpro"); if ok then odp.setup({}) end]],
      },
      {
        name = "OneDark Pro (Light)",
        colorscheme = "onelight",
        before = [[local ok, odp = pcall(require,"onedarkpro"); if ok then odp.setup({}) end; vim.o.background="light"]],
      },
      -- Material (lighter/light & darker/dark)
      {
        name = "Material (Darker)",
        colorscheme = "material",
        before = [[vim.g.material_style="darker"; pcall(function() require("material").setup({}) end)]],
      },
      {
        name = "Material (Lighter)",
        colorscheme = "material",
        before = [[vim.g.material_style="lighter"; pcall(function() require("material").setup({}) end); vim.o.background="light"]],
      },
      -- Ayu (mirage dark / light)
      {
        name = "Ayu (Mirage)",
        colorscheme = "ayu",
        before = [[vim.g.ayucolor="mirage"; pcall(function() require("ayu").setup({}) end)]],
      },
      {
        name = "Ayu (Light)",
        colorscheme = "ayu",
        before = [[vim.g.ayucolor="light";  pcall(function() require("ayu").setup({}) end); vim.o.background="light"]],
      },

      -- NEW ADDITIONS FROM NEOLAND.DEV --

      -- Nightfly & Moonfly (dark themes by bluz71)
      {
        name = "Nightfly",
        colorscheme = "nightfly",
        before = [[vim.o.background="dark"]],
      },
      {
        name = "Moonfly",
        colorscheme = "moonfly",
        before = [[vim.o.background="dark"]],
      },
      -- Dracula
      {
        name = "Dracula",
        colorscheme = "dracula",
        before = [[pcall(function() require("dracula").setup({}) end)]],
      },
      -- Nord variants
      {
        name = "Nord (shaunsingh)",
        colorscheme = "nord",
        before = [[pcall(function() require("nord").setup({}) end)]],
      },
      {
        name = "Nordic",
        colorscheme = "nordic",
        before = [[pcall(function() require("nordic").setup({}) end)]],
      },
      -- Gruvbox Material (softer than regular Gruvbox)
      {
        name = "Gruvbox Material (Dark)",
        colorscheme = "gruvbox-material",
        before = [[vim.o.background="dark"; vim.g.gruvbox_material_background="medium"]],
      },
      {
        name = "Gruvbox Material (Light)",
        colorscheme = "gruvbox-material",
        before = [[vim.o.background="light"; vim.g.gruvbox_material_background="soft"]],
      },
      -- Sonokai (Monokai Pro-inspired)
      {
        name = "Sonokai",
        colorscheme = "sonokai",
        before = [[vim.g.sonokai_style="default"; vim.g.sonokai_enable_italic=1]],
      },
      -- Edge
      {
        name = "Edge (Dark)",
        colorscheme = "edge",
        before = [[vim.o.background="dark"; vim.g.edge_style="default"]],
      },
      {
        name = "Edge (Light)",
        colorscheme = "edge",
        before = [[vim.o.background="light"; vim.g.edge_style="default"]],
      },
      -- Moonlight
      {
        name = "Moonlight",
        colorscheme = "moonlight",
        before = [[pcall(function() require("moonlight").setup({}) end)]],
      },
      -- One Dark (navarasu version)
      {
        name = "One Dark (navarasu)",
        colorscheme = "onedark",
        before = [[pcall(function() require("onedark").setup({ style = "dark" }) end)]],
      },
      -- VSCode theme
      {
        name = "VSCode (Dark)",
        colorscheme = "vscode",
        before = [[pcall(function() require("vscode").setup({}); require("vscode").load("dark") end)]],
      },
      {
        name = "VSCode (Light)",
        colorscheme = "vscode",
        before = [[pcall(function() require("vscode").setup({}); require("vscode").load("light") end)]],
      },
      -- Melange (warm theme)
      {
        name = "Melange",
        colorscheme = "melange",
        before = [[vim.o.background="dark"]],
      },
      -- Zenbones collection
      {
        name = "Zenbones (Dark)",
        colorscheme = "zenbones",
        before = [[vim.o.background="dark"]],
      },
      {
        name = "Zenbones (Light)",
        colorscheme = "zenwritten",
        before = [[vim.o.background="light"]],
      },
      -- Doom One
      {
        name = "Doom One",
        colorscheme = "doom-one",
        before = [[pcall(function() require("doom-one").setup({}) end)]],
      },
      -- Tokyodark
      {
        name = "Tokyodark",
        colorscheme = "tokyodark",
        before = [[pcall(function() require("tokyodark").setup({}) end)]],
      },
      -- One Monokai
      {
        name = "One Monokai",
        colorscheme = "one_monokai",
        before = [[pcall(function() require("one_monokai").setup({}) end)]],
      },
      -- Monokai (tanvirtin)
      {
        name = "Monokai",
        colorscheme = "monokai",
        before = [[pcall(function() require("monokai").setup({}) end)]],
      },
      -- Monokai Nightasty (dark & light)
      {
        name = "Monokai Nightasty (Dark)",
        colorscheme = "monokai-nightasty",
        before = [[pcall(function() require("monokai-nightasty").setup({}); vim.cmd("colorscheme monokai-nightasty") end)]],
      },
      {
        name = "Monokai Nightasty (Light)",
        colorscheme = "monokai-nightasty",
        before = [[pcall(function() require("monokai-nightasty").setup({ light_style = true }); vim.cmd("colorscheme monokai-nightasty") end)]],
      },
      -- Solarized variants
      {
        name = "Solarized (Dark)",
        colorscheme = "solarized",
        before = [[vim.o.background="dark"]],
      },
      {
        name = "Solarized (Light)",
        colorscheme = "solarized",
        before = [[vim.o.background="light"]],
      },
      -- Modus themes (high contrast, WCAG AAA)
      {
        name = "Modus Vivendi (Dark)",
        colorscheme = "modus",
        before = [[pcall(function() require("modus-themes").setup({ variant = "modus_vivendi" }) end)]],
      },
      {
        name = "Modus Operandi (Light)",
        colorscheme = "modus",
        before = [[pcall(function() require("modus-themes").setup({ variant = "modus_operandi" }) end)]],
      },
      -- Bamboo
      {
        name = "Bamboo (Dark)",
        colorscheme = "bamboo",
        before = [[pcall(function() require("bamboo").setup({ style = "vulgaris" }) end)]],
      },
      {
        name = "Bamboo (Light)",
        colorscheme = "bamboo",
        before = [[pcall(function() require("bamboo").setup({ style = "light" }) end)]],
      },
      -- Cyberdream
      {
        name = "Cyberdream",
        colorscheme = "cyberdream",
        before = [[pcall(function() require("cyberdream").setup({}) end)]],
      },
      -- Nightcity
      {
        name = "Nightcity",
        colorscheme = "nightcity",
        before = [[pcall(function() require("nightcity").setup({}) end)]],
      },
      -- Poimandres
      {
        name = "Poimandres",
        colorscheme = "poimandres",
        before = [[pcall(function() require("poimandres").setup({}) end)]],
      },
      -- Adwaita (GNOME-inspired)
      {
        name = "Adwaita (Dark)",
        colorscheme = "adwaita",
        before = [[vim.o.background="dark"]],
      },
      {
        name = "Adwaita (Light)",
        colorscheme = "adwaita",
        before = [[vim.o.background="light"]],
      },
      -- Night Owl
      {
        name = "Night Owl (Dark)",
        colorscheme = "night-owl",
        before = [[pcall(function() require("night-owl").setup({}) end)]],
      },
      -- Onenord
      {
        name = "Onenord",
        colorscheme = "onenord",
        before = [[pcall(function() require("onenord").setup({}) end)]],
      },
      -- Palenight
      {
        name = "Palenight",
        colorscheme = "palenight",
        before = [[pcall(function() require("palenight").setup({}) end)]],
      },
      -- Arctic (VSCode Dark+ port)
      {
        name = "Arctic",
        colorscheme = "arctic",
        before = [[pcall(function() require("arctic").setup({}) end)]],
      },
      -- Everblush
      {
        name = "Everblush",
        colorscheme = "everblush",
        before = [[pcall(function() require("everblush").setup({}) end)]],
      },
      -- Gruvbox Baby
      {
        name = "Gruvbox Baby",
        colorscheme = "gruvbox-baby",
        before = [[vim.o.background="dark"]],
      },
      -- Mellifluous
      {
        name = "Mellifluous",
        colorscheme = "mellifluous",
        before = [[pcall(function() require("mellifluous").setup({}) end)]],
      },
      -- Fluoromachine
      {
        name = "Fluoromachine",
        colorscheme = "fluoromachine",
        before = [[pcall(function() require("fluoromachine").setup({}) end)]],
      },
      -- Evergarden
      {
        name = "Evergarden (Dark)",
        colorscheme = "evergarden",
        before = [[pcall(function() require("evergarden").setup({ transparent_background = false, contrast_dark = "medium" }) end)]],
      },
      {
        name = "Evergarden (Light)",
        colorscheme = "evergarden",
        before = [[pcall(function() require("evergarden").setup({ transparent_background = false, contrast_dark = "medium", variant = "light" }) end)]],
      },
    }

    -- (Optional) Auto-append any other installed schemes you already have.
    do
      local seen, add = {}, {}
      for _, t in ipairs(themes) do
        local name = type(t) == "string" and t or t.colorscheme
        if name then
          seen[name] = true
          end
          end
          for _, cs in ipairs(vim.fn.getcompletion("", "color")) do
            if not seen[cs] and cs ~= "default" then
              table.insert(add, cs)
              end
              end
              for _, cs in ipairs(add) do
                table.insert(themes, cs)
                end
                end

                require("themery").setup({
                  livePreview = true,
                  themes = themes,
                })
                end,

                -- Install the popular theme plugins so the list works out-of-the-box
                dependencies = {
                  -- Original themes
                  { "sainnhe/everforest", lazy = true },
                  { "folke/tokyonight.nvim", lazy = true },
                  { "catppuccin/nvim", name = "catppuccin", lazy = true },
                  { "rebelot/kanagawa.nvim", lazy = true },
                  { "EdenEast/nightfox.nvim", lazy = true },
                  { "projekt0n/github-nvim-theme", lazy = true },
                  { "rose-pine/neovim", name = "rose-pine", lazy = true },
                  { "ellisonleao/gruvbox.nvim", lazy = true },
                  { "olimorris/onedarkpro.nvim", lazy = true },
                  { "marko-cerovac/material.nvim", lazy = true },
                  { "Shatur/neovim-ayu", lazy = true },

                  -- New additions from neoland.dev
                  { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true },
                  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true },
                  { "Mofiqul/dracula.nvim", lazy = true },
                  { "shaunsingh/nord.nvim", lazy = true },
                  { "AlexvZyl/nordic.nvim", lazy = true },
                  { "sainnhe/gruvbox-material", lazy = true },
                  { "sainnhe/sonokai", lazy = true },
                  { "sainnhe/edge", lazy = true },
                  { "shaunsingh/moonlight.nvim", lazy = true },
                  { "navarasu/onedark.nvim", lazy = true },
                  { "Mofiqul/vscode.nvim", lazy = true },
                  { "savq/melange-nvim", lazy = true },
                  { "mcchrish/zenbones.nvim", lazy = true },
                  { "NTBBloodbath/doom-one.nvim", lazy = true },
                  { "tiagovla/tokyodark.nvim", lazy = true },
                  { "cpea2506/one_monokai.nvim", lazy = true },
                  { "tanvirtin/monokai.nvim", lazy = true },
                  { "polirritmico/monokai-nightasty.nvim", lazy = true },
                  { "ishan9299/nvim-solarized-lua", lazy = true },
                  { "miikanissi/modus-themes.nvim", lazy = true },
                  { "ribru17/bamboo.nvim", lazy = true },
                  { "scottmckendry/cyberdream.nvim", lazy = true },
                  { "cryptomilk/nightcity.nvim", lazy = true },
                  { "olivercederborg/poimandres.nvim", lazy = true },
                  { "Mofiqul/adwaita.nvim", lazy = true },
                  { "oxfist/night-owl.nvim", lazy = true },
                  { "rmehri01/onenord.nvim", lazy = true },
                  { "alexmozaidze/palenight.nvim", lazy = true },
                  { "rockyzhang24/arctic.nvim", lazy = true },
                  { "Everblush/everblush.nvim", lazy = true },
                  { "luisiacc/gruvbox-baby", lazy = true },
                  { "ramojus/mellifluous.nvim", lazy = true },
                  { "maxmx03/fluoromachine.nvim", lazy = true },
                  { "comfysage/evergarden", lazy = true },
                },
  },
}
