-- Database + Redis browsing (GoLand's Database tool window).
-- The dadbod/DBUI plugins themselves come from the LazyVim `lang.sql` extra.
-- This file only feeds it connections, read from each service's env file at
-- startup so credentials live in local.env and are never copied into the config.
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
      { "<leader>dA", "<cmd>DBUIAddConnection<cr>", desc = "DB: add connection" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "DB: find buffer" },
    },
    init = function()
      local ok, dotenv = pcall(require, "util.dotenv")
      if not ok then return end

      local dbs, seen = {}, {}
      local function add(name, url)
        if url and url ~= "" and not seen[url] then
          seen[url] = true
          table.insert(dbs, { name = name, url = url })
        end
      end

      for _, svc in ipairs(dotenv.services()) do
        local env = dotenv.load(svc.dir)
        -- Identical URLs across services are de-duplicated by `seen`.
        add(svc.name .. " · postgres", env.DATABASE_URL)
        add(svc.name .. " · redis", dotenv.normalize_redis_url(env.REDIS_URL))
      end

      if #dbs > 0 then
        vim.g.dbs = dbs
      end
    end,
  },
}
