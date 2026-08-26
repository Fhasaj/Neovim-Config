-- Flutter / Dart.
--
-- LazyVim's `lang.dart` extra only starts `dartls`. flutter-tools adds the
-- parts that make Flutter work bearable: device and emulator selection, hot
-- reload/restart, the widget outline, and log/dev-tools panes.
--
--   <leader>fr   hot reload         <leader>fd   pick a device
--   <leader>fR   hot restart        <leader>fe   pick an emulator
--   <leader>fs   run / start        <leader>fo   widget outline
--   <leader>fq   quit the app       <leader>fl   dev log
return {
  {
    "nvim-flutter/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    ft = { "dart" },
    keys = {
      { "<leader>f", "", desc = "+flutter" },
      { "<leader>fr", "<cmd>FlutterReload<cr>", desc = "Hot reload" },
      { "<leader>fR", "<cmd>FlutterRestart<cr>", desc = "Hot restart" },
      { "<leader>fs", "<cmd>FlutterRun<cr>", desc = "Run" },
      { "<leader>fq", "<cmd>FlutterQuit<cr>", desc = "Quit app" },
      { "<leader>fd", "<cmd>FlutterDevices<cr>", desc = "Devices" },
      { "<leader>fe", "<cmd>FlutterEmulators<cr>", desc = "Emulators" },
      { "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Widget outline" },
      { "<leader>fl", "<cmd>FlutterLogToggle<cr>", desc = "Dev log" },
      { "<leader>fD", "<cmd>FlutterDevTools<cr>", desc = "DevTools" },
      { "<leader>fp", "<cmd>FlutterPubGet<cr>", desc = "pub get" },
    },
    opts = {
      -- The SDK lives outside PATH-managed locations; resolve it from the
      -- `flutter` binary rather than hard-coding a version directory.
      flutter_path = vim.fn.exepath("flutter") ~= "" and vim.fn.exepath("flutter") or nil,
      ui = { border = "rounded" },
      decorations = { statusline = { app_version = true, device = true } },
      widget_guides = { enabled = true },
      -- Reload the whole app when a file is written, like `flutter run` does.
      dev_log = { enabled = true, open_cmd = "botright 15split" },
      lsp = {
        color = { enabled = true, background = false, virtual_text = true },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "prompt",
          updateImportsOnRename = true,
        },
      },
    },
  },

  -- flutter-tools starts and owns dartls itself. Leaving LazyVim's copy enabled
  -- attaches a second analysis server to every Dart buffer, which shows up as
  -- duplicated completions and diagnostics.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { dartls = { enabled = false } },
      setup = {
        dartls = function()
          return true -- handled by flutter-tools
        end,
      },
    },
  },
}
