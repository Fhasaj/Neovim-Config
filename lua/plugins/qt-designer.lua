-- Qt Designer opener (Windows/macOS/Linux + WSL friendly)

-- Prevent double-loading
if vim.g.qt_designer_loaded then return end
    vim.g.qt_designer_loaded = true

    -- Optional overrides:
    --   vim.g.qt_designer_path = "/custom/path/to/designer"
    --   (or set env var QT_DESIGNER to an absolute path)

    local uv = vim.loop
    local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    local uname = uv.os_uname().release or ""
    local is_wsl = (not is_win) and uname:lower():find("microsoft") ~= nil
    local is_mac = vim.fn.has("mac") == 1

    local function exists_exec(p)
    return type(p) == "string" and p ~= "" and vim.fn.executable(p) == 1
    end

    local function glob_exec(pattern)
    for _, p in ipairs(vim.split(vim.fn.glob(pattern, 1, 1), "\n", { plain = true })) do
        if exists_exec(p) then return p end
            end
            end

            local function find_designer()
            if vim.g.qt_designer_path and exists_exec(vim.g.qt_designer_path) then
                return vim.g.qt_designer_path
                end
                local env = vim.env.QT_DESIGNER
                if env and exists_exec(env) then return env end

                    local on_path = vim.fn.exepath(is_win and "designer.exe" or "designer")
                    if exists_exec(on_path) then return on_path end

                        local candidates = {}

                        if is_win or is_wsl then
                            vim.list_extend(candidates, {
                                "C:\\Qt\\6.7.3\\msvc2022_64\\bin\\designer.exe",
                                "C:\\Qt\\6.7.3\\mingw_64\\bin\\designer.exe",
                                "C:\\Qt\\6.6.3\\msvc2022_64\\bin\\designer.exe",
                                "C:\\Qt\\6.6.3\\mingw_64\\bin\\designer.exe",
                            })
                            elseif is_mac then
                                vim.list_extend(candidates, {
                                    "/opt/homebrew/opt/qt/bin/designer",  -- Apple Silicon
                                    "/usr/local/opt/qt/bin/designer",     -- Intel
                                })
                                local from_app = glob_exec("/Applications/Qt/*/macos/bin/Designer.app/Contents/MacOS/Designer")
                                if from_app then return from_app end
                                    else
                                        vim.list_extend(candidates, {
                                            "/usr/lib/qt6/bin/designer",
                                            "/usr/bin/designer",
                                            "/usr/lib/qt5/bin/designer",
                                            "/opt/qt6/bin/designer",
                                            "/opt/qt/bin/designer",
                                        })
                                        end

                                        for _, p in ipairs(candidates) do
                                            if exists_exec(p) then return p end
                                                end

                                                return is_win and "designer.exe" or "designer"
                                                end

                                                local function open_in_designer(file)
                                                local fp = vim.fn.fnamemodify(file or "", ":p")
                                                if not fp or fp == "" then
                                                    fp = vim.fn.expand("%:p")
                                                    end
                                                    if fp == "" or not vim.loop.fs_stat(fp) then
                                                        vim.notify("No file to open (save buffer first).", vim.log.levels.WARN)
                                                        return
                                                        end

                                                        local designer = find_designer()

                                                        if is_wsl then
                                                            local wpath = vim.fn.trim(vim.fn.system({ "wslpath", "-w", fp }))
                                                            vim.fn.jobstart({
                                                                "powershell.exe", "-NoProfile", "-Command",
                                                                "Start-Process", ("\"%s\""):format(designer), ("\"%s\""):format(wpath)
                                                            }, { detach = true })
                                                            return
                                                            end

                                                            if is_win then
                                                                vim.fn.jobstart({ "cmd.exe", "/c", "start", "", designer, fp }, { detach = true })
                                                                else
                                                                    vim.fn.jobstart({ designer, fp }, { detach = true })
                                                                    end
                                                                    end

                                                                    vim.api.nvim_create_user_command("QtDesigner", function(opts)
                                                                    open_in_designer(opts.args ~= "" and opts.args or nil)
                                                                    end, { desc = "Open current (or given) file in Qt Designer", nargs = "?", complete = "file" })

                                                                    vim.keymap.set("n", "<leader>qd", function() open_in_designer() end,
                                                                                   { desc = "Open in Qt Designer" })

                                                                    -- Auto-open .ui files exactly once per buffer
                                                                    local group = vim.api.nvim_create_augroup("QtDesignerAutoOpen", { clear = true })
                                                                    vim.api.nvim_create_autocmd("BufReadPost", {
                                                                        group = group,
                                                                        pattern = "*.ui",
                                                                        callback = function(args)
                                                                        -- per-buffer guard so we only open once for this buffer
                                                                        if vim.b[args.buf].qt_designer_opened then return end
                                                                            vim.b[args.buf].qt_designer_opened = true
                                                                            -- schedule to avoid reentrancy
                                                                            vim.schedule(function()
                                                                            local name = vim.api.nvim_buf_get_name(args.buf)
                                                                            if name ~= "" then open_in_designer(name) end
                                                                                end)
                                                                            end,
                                                                            desc = "Auto-open .ui files in Qt Designer (single-shot)",
                                                                    })
