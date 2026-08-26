-- Qt integration: open .ui / .qrc files in Qt Designer.
--
--   :QtDesigner [file]   open a file in Designer (defaults to the buffer)
--   <leader>qd           same, for the current buffer
--
-- .ui files are XML, so Neovim can edit them, but Designer is nearly always
-- what you actually want — they open there automatically (once per buffer).
--
-- Override the executable with `vim.g.qt_designer_path` or `$QT_DESIGNER`.
-- QML support (qmlls + syntax) lives in lua/plugins/lang.lua.

local function executable(path)
  return type(path) == "string" and path ~= "" and vim.fn.executable(path) == 1
end

local function find_designer()
  if executable(vim.g.qt_designer_path) then
    return vim.g.qt_designer_path
  end
  if executable(vim.env.QT_DESIGNER) then
    return vim.env.QT_DESIGNER
  end

  local on_path = vim.fn.exepath("designer")
  if executable(on_path) then
    return on_path
  end

  -- Distro packages install it outside PATH surprisingly often.
  for _, candidate in ipairs({
    "/usr/lib/qt6/bin/designer",
    "/usr/lib/qt/bin/designer",
    "/usr/bin/designer6",
    "/usr/bin/designer",
    "/usr/lib/qt5/bin/designer",
    "/opt/qt6/bin/designer",
    "/opt/homebrew/opt/qt/bin/designer",
  }) do
    if executable(candidate) then
      return candidate
    end
  end
end

local function open_in_designer(file)
  local path = vim.fn.fnamemodify(file and file ~= "" and file or vim.fn.expand("%:p"), ":p")
  if path == "" or not vim.uv.fs_stat(path) then
    return vim.notify("Qt Designer: no file to open (save the buffer first).", vim.log.levels.WARN)
  end

  local designer = find_designer()
  if not designer then
    return vim.notify(
      "Qt Designer not found. Install it (qt6-tools on Arch/Manjaro) or set vim.g.qt_designer_path.",
      vim.log.levels.WARN
    )
  end

  -- Detached, so closing Neovim does not take Designer with it.
  vim.fn.jobstart({ designer, path }, { detach = true })
end

return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      vim.api.nvim_create_user_command("QtDesigner", function(cmd)
        open_in_designer(cmd.args)
      end, { desc = "Open a file in Qt Designer", nargs = "?", complete = "file" })

      vim.keymap.set("n", "<leader>qd", function()
        open_in_designer()
      end, { desc = "Open in Qt Designer" })

      -- Auto-open .ui files, but only once per buffer: without the guard,
      -- every :edit of the file spawns another Designer window.
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("qt_designer", { clear = true }),
        pattern = "*.ui",
        callback = function(args)
          if vim.b[args.buf].qt_designer_opened then
            return
          end
          vim.b[args.buf].qt_designer_opened = true
          vim.schedule(function()
            local name = vim.api.nvim_buf_get_name(args.buf)
            if name ~= "" then
              open_in_designer(name)
            end
          end)
        end,
        desc = "Open .ui files in Qt Designer",
      })
    end,
  },
}
