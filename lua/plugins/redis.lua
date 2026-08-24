-- Redis. vim-dadbod has a native redis adapter (it shells out to `redis-cli`),
-- so REDIS_URL connections registered in database.lua show up in DBUI directly.
-- This adds an interactive redis-cli session for the current service.
return {
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    keys = {
      {
        "<leader>dR",
        function()
          if vim.fn.executable("redis-cli") == 0 then
            vim.notify("redis-cli not installed (sudo pacman -S redis)", vim.log.levels.ERROR)
            return
          end
          local dotenv = require("util.dotenv")
          local env = dotenv.load(dotenv.service_root())
          local url = dotenv.normalize_redis_url(env.REDIS_URL)
          if not url then
            vim.notify("no REDIS_URL in this service's env file", vim.log.levels.ERROR)
            return
          end
          require("toggleterm.terminal").Terminal
            :new({ cmd = "redis-cli -u " .. vim.fn.shellescape(url), direction = "float", close_on_exit = false })
            :toggle()
        end,
        desc = "Redis CLI (current service)",
      },
    },
  },
}
