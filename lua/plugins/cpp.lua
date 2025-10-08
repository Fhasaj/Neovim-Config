vim.g.completion_engine = vim.g.completion_engine or "blink"

local uname = vim.loop.os_uname()
local is_win = (vim.fn.has("win32") == 1) or (uname.sysname or ""):match("Windows")
local is_wsl = (vim.fn.has("wsl") == 1)

-- -------------------- clangd cmd builder --------------------
local function clangd_cmd()
  local cmd = {
    "clangd",
    "--header-insertion=never",
    "--clang-tidy",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=LLVM",
  }
  if is_win and not is_wsl then
    table.insert(cmd, "--compile-commands-dir=build")
    table.insert(cmd, "--query-driver=" .. table.concat({
      "C:/Program Files/Microsoft Visual Studio/*/*/VC/Tools/MSVC/*/bin/Hostx64/x64/*",
      "C:/msys64/mingw64/bin/*",
      "C:/Program Files/LLVM/bin/*",
    }, ";"))
  else
    table.insert(cmd, "--query-driver=" .. table.concat({
      "/usr/bin/clang*",
      "/usr/local/bin/clang*",
      "/usr/bin/gcc*",
      "/usr/bin/g++*",
    }, ";"))
  end
  return cmd
end

-- -------------------- LSP capabilities --------------------
local function lsp_capabilities()
  local c = vim.lsp.protocol.make_client_capabilities()
  c.offsetEncoding = { "utf-16" } -- clangd prefers this

  if vim.g.completion_engine == "cmp" then
    local ok, cmp = pcall(require, "cmp_nvim_lsp")
    if ok and cmp and cmp.default_capabilities then
      c = cmp.default_capabilities(c)
    end
  elseif vim.g.completion_engine == "blink" then
    local ok, blink = pcall(require, "blink.cmp")
    if ok and blink and blink.get_lsp_capabilities then
      c = vim.tbl_deep_extend("force", c, blink.get_lsp_capabilities())
    end
  end
  return c
end

-- -------------------- Plugins spec --------------------
return {
  -- ---------- Toolchain via Mason ----------
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "clang-format",
        "codelldb",
        "cmake-language-server",
        "cmakelint",
        "cmakelang",
      })
    end,
  },

  -- ---------- Completion engines ----------
  -- nvim-cmp stack
  {
    "hrsh7th/nvim-cmp",
    cond = function() return vim.g.completion_engine == "cmp" end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({})
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    cond = function() return vim.g.completion_engine == "cmp" end,
  },

  -- blink.cmp stack
  {
    "saghen/blink.cmp",
    cond = function() return vim.g.completion_engine == "blink" end,
    opts = {},
  },

  -- ---------- LSP ----------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", cond = function() return vim.g.completion_engine == "cmp" end },
    },
    opts = {
      servers = {
        clangd = {
          cmd = clangd_cmd(),
          init_options = { clangdFileStatus = true },
          capabilities = lsp_capabilities(),
          on_attach = function(client, bufnr)
            -- Inlay hints
            local ih = vim.lsp.inlay_hint
            if client.server_capabilities.inlayHintProvider and ih then
              pcall(ih.enable, true, { bufnr = bufnr })
              pcall(ih.enable, bufnr, true)
            end
            -- Diagnostics
            vim.diagnostic.config({
              virtual_text = { prefix = "●", severity = { min = vim.diagnostic.severity.WARN } },
              signs = true,
              underline = true,
              update_in_insert = false,
              severity_sort = true,
              float = { border = "rounded", source = "if_many" },
            })
            -- Keymaps
            local map = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map("n", "<C-b>", vim.lsp.buf.definition, "Go to Definition (Ctrl+B)")
            map("n", "<A-F7>", vim.lsp.buf.references, "Find Usages (Alt+F7)")
            map("n", "<S-F6>", vim.lsp.buf.rename, "Rename (Shift+F6)")
            map("n", "<A-CR>", vim.lsp.buf.code_action, "Quick Fix (Alt+Enter)")
            map("n", "K", vim.lsp.buf.hover, "Quick Documentation")
            map("n", "<leader>cd", vim.lsp.buf.definition, "Go to Definition")
            map("n", "<leader>cr", vim.lsp.buf.references, "Find References")
            map("n", "<leader>cn", vim.lsp.buf.rename, "Rename")
            map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
            map("n", "<leader>oh", function() vim.cmd("ClangdSwitchSourceHeader") end, "Switch Header/Source")
          end,
        },
        cmake = {},
      },
    },
  },

  -- ---------- Format on save ----------
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        objc = { "clang_format" },
        objcpp = { "clang_format" },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" then
          return { timeout_ms = 2000, lsp_fallback = true }
        end
      end,
    },
  },

-- ---------- Debugging ----------
-- {
--   "mfussenegger/nvim-dap",
--   dependencies = {
--     "jay-babu/mason-nvim-dap.nvim",
--     { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } }, -- <-- required
--   },
--   config = function()
--     require("mason-nvim-dap").setup({
--       ensure_installed = { "codelldb" },  -- set to {} if you don't want auto-install on Windows
--       automatic_setup = true,
--     })
--
--     local dap, dapui = require("dap"), require("dapui")
--     dapui.setup()
--
--     dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
--     dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
--     dap.listeners.before.event_exited["dapui"] = function() dapui.close() end
--
--     -- your keymaps & fallback configs unchanged...
--     vim.keymap.set("n", "<F9>", dap.continue, { desc = "Debug: Start/Continue" })
--     vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Debug: Step Over" })
--     vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Debug: Step Into" })
--     vim.keymap.set("n", "<S-F8>", dap.step_out, { desc = "Debug: Step Out" })
--     vim.keymap.set("n", "<F5>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
--     vim.keymap.set("n", "<A-F9>", function()
--              vim.keymap.set("n", "<A-/>", require("Comment.api").toggle.linewise.current, { silent = true })
--         vim.keymap.set("v", "<A-/>", function()
--         require("Comment.api").toggle.linewise(vim.fn.visualmode())
--         end, { silent = true }) require("dap").set_breakpoint(vim.fn.input("Condition: "))
--     end, { desc = "Debug: Conditional Breakpoint" })
--
--     -- fallback adapter config remains the same...
--     local is_win = (vim.fn.has("win32") == 1) or ((vim.loop.os_uname().sysname or ""):match("Windows"))
--     local sep = (is_win and "\\" or "/")
--     require("dap").configurations.cpp = require("dap").configurations.cpp or {
--       {
--         name = "Launch file",
--         type = "codelldb",
--         request = "launch",
--         program = function()
--           return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. sep .. "build" .. sep, "file")
--         end,
--         cwd = "${workspaceFolder}",
--         stopOnEntry = false,
--         args = {},
--         runInTerminal = true,
--       },
--     }
--     require("dap").configurations.c = require("dap").configurations.cpp
--     require("dap").configurations.rust = require("dap").configurations.cpp
--   end,
-- },


-- ---------- CMake ----------
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    -- Use config to guarantee we can patch after setup
    config = function(_, _opts)
      local opts = {
        cmake_command = "cmake",
        cmake_build_directory = "build",

        -- Disable presets so -G Ninja applies (turn on if you use your own presets)
        cmake_use_preset = false,

        cmake_generate_options = (is_win and not is_wsl)
          and { "-G", "Ninja", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }
          or { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },

        cmake_soft_link_compile_commands = (is_win and not is_wsl) and false or true,

        cmake_regenerate_on_save = true,
        cmake_notification = { status = true },

        -- DAP default for :CMakeDebug
        cmake_dap_configuration = {
          name = "CMake Debug",
          type = is_win and "cppdbg" or "codelldb",
          request = "launch",
          stopOnEntry = false,
          runInTerminal = true,
          cwd = "${workspaceFolder}",
          args = {},
        },

        -- IMPORTANT: avoid persisted working_dir issues
        base_settings = { working_dir = nil },
      }

      local cmake = require("cmake-tools")
      cmake.setup(opts)

      -- Guard against plugin calling substitute_path with nil vars
      -- (prevents: bad argument #1 to 'pairs' (table expected, got nil))
      local ok, mod = pcall(require, "cmake-tools")
      if ok and type(mod.substitute_path) == "function" then
        local old = mod.substitute_path
        mod.substitute_path = function(path, vars)
          if type(vars) ~= "table" then return path end
          return old(path, vars)
        end
      end
    end,
    keys = {
      { "<leader>cm", "<cmd>CMakeGenerate<CR>", desc = "CMake: Configure" },
      -- Always prompt target, then build / run / debug
      {
        "<leader>cb",
        function() vim.cmd("CMakeSelectBuildTarget | CMakeBuild") end,
        desc = "CMake: Select Target & Build",
      },
      {
        "<leader>cr",
        function() vim.cmd("CMakeSelectLaunchTarget | CMakeRun") end,
        desc = "CMake: Select Target & Run",
      },
      {
        "<leader>cd",
        function() vim.cmd("CMakeSelectLaunchTarget | CMakeDebug") end,
        desc = "CMake: Select Target & Debug",
      },
      { "<leader>ct", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake: Select Build Target" },
      { "<leader>cc", "<cmd>CMakeClean<CR>", desc = "CMake: Clean" },
    },
  },

}
