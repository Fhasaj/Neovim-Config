return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI Toggle",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "DAP Eval",
      },
    },
    opts = {
      layouts = {
        {
          position = "left",
          size = 42,
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "watches", size = 0.2 },
            { id = "stacks", size = 0.25 },
            { id = "breakpoints", size = 0.15 },
          },
        },
        { position = "bottom", size = 12, elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } } },
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close({})
      end
    end,
  },
  -- Inline variable values next to the code, like GoLand's debugger.
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = { commented = true },
  },
}
