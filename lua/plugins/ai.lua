-- Local LLM support, entirely offline: CodeCompanion talking to Ollama.
--
-- Nothing here calls a hosted service, and the Copilot extra is deliberately
-- not enabled (see lazyvim.json). Host and model come from lua/config/options.lua
-- (vim.g.ollama_host / vim.g.ollama_model) so there is one place to change them.
--
-- Keys (all under <leader>a):
--   <leader>aa  toggle the chat panel
--   <leader>ai  inline edit the selection / prompt at the cursor
--   <leader>ac  action palette (explain, fix, tests, commit message, …)
--   <leader>ad  add the current buffer or selection to the open chat
--   <leader>am  pick a different Ollama model for this chat
return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Renders the chat buffer as formatted markdown rather than raw text.
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
        opts = { file_types = { "markdown", "codecompanion" } },
      },
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI chat (toggle)" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI inline edit" },
      { "<leader>ac", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI action palette" },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI add selection to chat" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "AI new chat" },
    },
    opts = {
      adapters = {
        http = {
          -- `extend` layers these on top of the built-in ollama adapter, so
          -- everything else about it (streaming, tools, vision) stays default.
          extend = {
            ollama = {
              env = { url = vim.g.ollama_host },
              schema = {
                model = { default = vim.g.ollama_model },
                -- The `-64k` model tags are built with a 64k context window;
                -- Ollama otherwise truncates to 4k and silently forgets context.
                num_ctx = { default = 65536 },
              },
            },
          },
        },
      },
      -- Every interaction goes to the local model. `interactions` is what older
      -- CodeCompanion versions called `strategies`.
      interactions = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
        cmd = { adapter = "ollama" },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = 0.35,
            border = "rounded",
          },
          show_settings = true,
          show_token_count = true,
        },
        diff = { enabled = true, layout = "vertical" },
      },
      opts = { log_level = "ERROR" },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- `:CodeCompanionModel` — switch the Ollama model without editing config.
      -- Lists what the local daemon actually has, which avoids the classic
      -- "configured model isn't pulled" failure where every request 404s.
      vim.api.nvim_create_user_command("CodeCompanionModel", function()
        local url = (vim.g.ollama_host or "http://127.0.0.1:11434") .. "/api/tags"
        local res = vim.system({ "curl", "-sf", "--max-time", "3", url }):wait()
        if res.code ~= 0 then
          return vim.notify("Ollama is not reachable at " .. url, vim.log.levels.ERROR)
        end
        local ok, body = pcall(vim.json.decode, res.stdout)
        if not ok then
          return vim.notify("Could not parse the Ollama model list", vim.log.levels.ERROR)
        end
        local models = vim.tbl_map(function(m)
          return m.name
        end, body.models or {})
        table.sort(models)
        vim.ui.select(models, { prompt = "Ollama model" }, function(choice)
          if not choice then
            return
          end
          vim.g.ollama_model = choice
          opts.adapters.http.extend.ollama.schema.model.default = choice
          require("codecompanion").setup(opts)
          vim.notify("CodeCompanion model: " .. choice)
        end)
      end, { desc = "Pick the Ollama model CodeCompanion uses" })

      vim.keymap.set("n", "<leader>am", "<cmd>CodeCompanionModel<cr>", { desc = "AI pick model" })
    end,
  },
}
