-- lua/plugins/qt-designer.lua
return {
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
        config = function()
        -- Prevent double-loading
        if vim.g.qt_designer_loaded then return end
            vim.g.qt_designer_loaded = true

            -- Optional overrides:
            --   vim.g.qt_designer_path = "/custom/path/to/designer"
            --   (or set env var QT_DESIGNER to an absolute path)

            local uv = vim.loop
            local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
            local uname = (uv.os_uname().release or ""):lower()
            local is_wsl = (not is_win) and uname:find("microsoft", 1, true) ~= nil
            local is_mac = vim.fn.has("mac") == 1

            local function exists_exec(p)
            return type(p) == "string" and p ~= "" and vim.fn.executable(p) == 1
            end

            local function glob_exec(pattern)
            local out = vim.fn.glob(pattern, 1, 1)
            for _, p in ipairs(vim.split(out, "\n", { plain = true })) do
                if exists_exec(p) then return p end
                    end
                    end

                    local function find_designer()
                    -- explicit override(s)
                    if exists_exec(vim.g.qt_designer_path) then return vim.g.qt_designer_path end
                        if exists_exec(vim.env.QT_DESIGNER)     then return vim.env.QT_DESIGNER end

                            -- on PATH?
                            local on_path = vim.fn.exepath(is_win and "designer.exe" or "designer")
                            if exists_exec(on_path) then return on_path end

                                -- common locations
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
                                        if exists_exec(from_app) then return from_app end
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

                                                        -- IMPORTANT: return nil instead of a bare "designer" string
                                                        return nil
                                                        end

                                                        local function open_in_designer(file)
                                                        local fp = vim.fn.fnamemodify(file or "", ":p")
                                                        if fp == nil or fp == "" then
                                                            fp = vim.fn.expand("%:p")
                                                            end
                                                            if fp == "" or not uv.fs_stat(fp) then
                                                                vim.notify("Qt Designer: no file to open (save the buffer first).", vim.log.levels.WARN)
                                                                return
                                                                end

                                                                local designer = find_designer()
                                                                if not designer then
                                                                    vim.notify(
                                                                        "Qt Designer not found. Install it (e.g. qt6-tools) or set vim.g.qt_designer_path / $QT_DESIGNER.",
                                                                               vim.log.levels.WARN
                                                                    )
                                                                    return
                                                                    end

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

                                                                                vim.keymap.set("n", "<leader>qd", function() open_in_designer() end, { desc = "Open in Qt Designer" })

                                                                                -- Auto-open .ui files exactly once per buffer
                                                                                local group = vim.api.nvim_create_augroup("QtDesignerAutoOpen", { clear = true })
                                                                                vim.api.nvim_create_autocmd("BufReadPost", {
                                                                                    group = group,
                                                                                    pattern = "*.ui",
                                                                                    callback = function(args)
                                                                                    if vim.b[args.buf].qt_designer_opened then return end
                                                                                        vim.b[args.buf].qt_designer_opened = true
                                                                                        vim.schedule(function()
                                                                                        local name = vim.api.nvim_buf_get_name(args.buf)
                                                                                        if name ~= "" then open_in_designer(name) end
                                                                                            end)
                                                                                        end,
                                                                                        desc = "Auto-open .ui files in Qt Designer (single-shot)",
                                                                                })
                                                                                end,
    },
}
