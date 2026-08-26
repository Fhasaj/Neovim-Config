-- Theme picker.
--
-- `<leader>ut` opens Themery: a searchable list with live preview as you move
-- through it, and the choice persists across restarts (Themery stores it under
-- stdpath("data")/themery, so no config file gets rewritten).
--
-- To add a theme: add its repo to `packs` below together with the colorscheme
-- names it provides. Light variants go in `light` so `background` is set for
-- the schemes that need it.

-- repo -> colorscheme names it provides
local packs = {
  { "folke/tokyonight.nvim", { "tokyonight-night", "tokyonight-storm", "tokyonight-moon", "tokyonight-day" } },
  {
    "catppuccin/nvim",
    { "catppuccin-mocha", "catppuccin-macchiato", "catppuccin-frappe", "catppuccin-latte" },
    name = "catppuccin",
  },
  { "rebelot/kanagawa.nvim", { "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" } },
  { "rose-pine/neovim", { "rose-pine-main", "rose-pine-moon", "rose-pine-dawn" }, name = "rose-pine" },
  { "EdenEast/nightfox.nvim", { "nightfox", "duskfox", "nordfox", "carbonfox", "terafox", "dayfox", "dawnfox" } },
  { "sainnhe/everforest", { "everforest" } },
  { "sainnhe/gruvbox-material", { "gruvbox-material" } },
  { "sainnhe/sonokai", { "sonokai" } },
  { "sainnhe/edge", { "edge" } },
  { "ellisonleao/gruvbox.nvim", { "gruvbox" } },
  { "projekt0n/github-nvim-theme", { "github_dark_default", "github_dark_dimmed", "github_light_default" } },
  { "olimorris/onedarkpro.nvim", { "onedark", "onelight", "onedark_vivid" } },
  { "marko-cerovac/material.nvim", { "material" } },
  { "Shatur/neovim-ayu", { "ayu-dark", "ayu-mirage", "ayu-light" } },
  { "Mofiqul/dracula.nvim", { "dracula" } },
  { "Mofiqul/vscode.nvim", { "vscode" } },
  { "shaunsingh/nord.nvim", { "nord" } },
  { "AlexvZyl/nordic.nvim", { "nordic" } },
  { "rmehri01/onenord.nvim", { "onenord" } },
  { "bluz71/vim-nightfly-colors", { "nightfly" }, name = "nightfly" },
  { "bluz71/vim-moonfly-colors", { "moonfly" }, name = "moonfly" },
  { "shaunsingh/moonlight.nvim", { "moonlight" } },
  { "savq/melange-nvim", { "melange" } },
  { "mcchrish/zenbones.nvim", { "zenbones", "zenwritten" }, dependencies = { "rktjmp/lush.nvim" } },
  { "NTBBloodbath/doom-one.nvim", { "doom-one" } },
  { "tiagovla/tokyodark.nvim", { "tokyodark" } },
  { "cpea2506/one_monokai.nvim", { "one_monokai" } },
  { "tanvirtin/monokai.nvim", { "monokai" } },
  { "polirritmico/monokai-nightasty.nvim", { "monokai-nightasty" } },
  { "miikanissi/modus-themes.nvim", { "modus_vivendi", "modus_operandi" } },
  { "ribru17/bamboo.nvim", { "bamboo" } },
  { "scottmckendry/cyberdream.nvim", { "cyberdream" } },
  { "olivercederborg/poimandres.nvim", { "poimandres" } },
  { "Mofiqul/adwaita.nvim", { "adwaita" } },
  { "oxfist/night-owl.nvim", { "night-owl" } },
  { "alexmozaidze/palenight.nvim", { "palenight" } },
  { "rockyzhang24/arctic.nvim", { "arctic" }, dependencies = { "rktjmp/lush.nvim" } },
  { "Everblush/nvim", { "everblush" }, name = "everblush" },
  { "luisiacc/gruvbox-baby", { "gruvbox-baby" } },
  { "ramojus/mellifluous.nvim", { "mellifluous" } },
  { "maxmx03/fluoromachine.nvim", { "fluoromachine" } },
  { "comfysage/evergarden", { "evergarden" } },
}

-- Schemes that need `background = light`. Everything else gets `dark`.
-- Some of these (everforest, gruvbox, material, …) are one colorscheme whose
-- appearance is chosen entirely by `background`, so they appear twice in the
-- list below with a different background each.
local light = {
  ["tokyonight-day"] = true,
  ["catppuccin-latte"] = true,
  ["kanagawa-lotus"] = true,
  ["rose-pine-dawn"] = true,
  ["dayfox"] = true,
  ["dawnfox"] = true,
  ["github_light_default"] = true,
  ["onelight"] = true,
  ["ayu-light"] = true,
  ["zenwritten"] = true,
  ["modus_operandi"] = true,
}

-- Colorschemes that key off `background` rather than a separate name, so both
-- variants are worth listing explicitly.
local dual = {
  "everforest",
  "gruvbox",
  "gruvbox-material",
  "sonokai",
  "edge",
  "material",
  "melange",
  "zenbones",
  "mellifluous",
  "evergarden",
  "modus_vivendi",
}

local function build_themes()
  local is_dual = {}
  for _, name in ipairs(dual) do
    is_dual[name] = true
  end

  local themes = {}
  local function add(scheme, bg, label)
    table.insert(themes, {
      name = label,
      colorscheme = scheme,
      before = ("vim.o.background = %q"):format(bg),
    })
  end

  for _, pack in ipairs(packs) do
    for _, scheme in ipairs(pack[2]) do
      local pretty = scheme:gsub("[-_]", " "):gsub("^%l", string.upper)
      if is_dual[scheme] then
        add(scheme, "dark", pretty .. " (dark)")
        add(scheme, "light", pretty .. " (light)")
      else
        add(scheme, light[scheme] and "light" or "dark", pretty)
      end
    end
  end

  -- Anything else already on the runtimepath (LazyVim ships habamax, default…).
  local known = {}
  for _, t in ipairs(themes) do
    known[t.colorscheme] = true
  end
  for _, scheme in ipairs(vim.fn.getcompletion("", "color")) do
    if not known[scheme] and scheme ~= "default" then
      table.insert(themes, scheme)
    end
  end

  return themes
end

-- Every theme plugin as a lazy dependency. lazy.nvim loads one the moment its
-- colorscheme is requested, so listing 40 of them costs nothing at startup.
local theme_plugins = {}
for _, pack in ipairs(packs) do
  local spec = { pack[1], lazy = true, priority = 1000 }
  spec.name = pack.name
  spec.dependencies = pack.dependencies
  table.insert(theme_plugins, spec)
end

return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 1000,
    dependencies = theme_plugins,
    keys = {
      { "<leader>ut", "<cmd>Themery<cr>", desc = "Pick colorscheme" },
    },
    config = function()
      require("themery").setup({
        themes = build_themes(),
        livePreview = true,
      })
    end,
  },

  -- Themery restores the saved theme itself, so stop LazyVim forcing
  -- tokyonight on every start.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = function() end },
  },
}
