return {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end
    vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI Toggle" })
    end,
}
