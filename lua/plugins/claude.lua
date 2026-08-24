-- Claude Code Neovim integration
-- https://github.com/coder/claudecode.nvim
-- Authenticate once with: claude login

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      auto_attach_current_file = true,
      terminal = {
        side = "right",
        window_width = 0.38,
      },
    },
    keys = {
      { "<leader>clt", "<cmd>ClaudeCode<cr>",           mode = { "n", "v" }, desc = "Claude: Toggle" },
      { "<leader>cls", "<cmd>ClaudeCodeSend<cr>",        mode = "v",          desc = "Claude: Send selection" },
      { "<leader>cla", "<cmd>ClaudeCodeTreeAdd<cr>",     mode = { "n", "v" }, desc = "Claude: Add to context" },
      { "<leader>cld", "<cmd>ClaudeCodeDiff<cr>",        mode = "n",          desc = "Claude: Diff view" },
    },
  },
}
