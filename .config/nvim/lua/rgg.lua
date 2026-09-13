local search_path = "/home/odoo/work" 

local preview_win = nil

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(args)
        local qf_buf = args.buf

        local function sync_preview()
            local entry = vim.fn.getqflist()[vim.fn.line('.')]
            if not entry or entry.valid == 0 then return end

            local qf_win = vim.api.nvim_get_current_win()

            if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
                vim.cmd("botright vsplit")
                preview_win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(qf_win)
            end

            local buf = entry.bufnr
            if buf == 0 or not vim.api.nvim_buf_is_valid(buf) then
                buf = vim.fn.bufadd(entry.filename)
            end

            vim.fn.bufload(buf)
            vim.api.nvim_win_set_buf(preview_win, buf)

            local line_count = vim.api.nvim_buf_line_count(buf)
            if entry.lnum > 0 and entry.lnum <= line_count then
                vim.api.nvim_win_set_cursor(preview_win, { entry.lnum, math.max(0, entry.col - 1) })
                vim.api.nvim_win_call(preview_win, function() vim.cmd("normal! zz") end)
            end
        end

        local function move(step)
            local qf_list = vim.fn.getqflist()
            local target = vim.fn.line('.')

            while true do
                target = target + step
                if target < 1 or target > #qf_list then
                    return
                end
                if qf_list[target].valid == 1 then
                    vim.api.nvim_win_set_cursor(0, { target, 0 })
                    return sync_preview()
                end
            end
        end

        vim.schedule(sync_preview)

        local opts = { buffer = qf_buf, silent = true }
        vim.keymap.set("n", "<Down>", function() move(1) end, opts)
        vim.keymap.set("n", "<Up>",   function() move(-1) end, opts)

        vim.keymap.set("n", "<CR>", function()
            local entry = vim.fn.getqflist()[vim.fn.line('.')]
            if entry and entry.valid == 1 and preview_win and vim.api.nvim_win_is_valid(preview_win) then
                vim.cmd("cclose")
                vim.api.nvim_set_current_win(preview_win)
                preview_win = nil
            end
        end, opts)
    end,
})

vim.api.nvim_create_user_command("SearchContext", function(opts)
    local query = opts.args
    if not query or query == "" then
        return
    end

    local rg_args = {
        "rg",
        "--vimgrep",
        "-C", "5",
        query,
        search_path
    }

    local output = vim.fn.system(rg_args)

    if output and output ~= "" then
        vim.fn.setqflist({}, 'r', { lines = vim.split(output, '\n', { trimempty = true }) })
        vim.cmd("copen")
        vim.w.quickfix_title = "Ripgrep: " .. query
    end
end, { nargs = "+" })

vim.keymap.set("v", "<F3>", function()
    local saved_reg = vim.fn.getreg("v")
    local saved_type = vim.fn.getregtype("v")

    vim.cmd('noau normal! "vy"')
    local selection = vim.fn.getreg("v")

    vim.fn.setreg("v", saved_reg, saved_type)

    selection = selection:gsub("^%s*(.-)%s*$", "%1")

    if selection == "" then
        return
    end

    local cmd_string = string.format(":SearchContext \\b%s\\b", selection)
    vim.api.nvim_feedkeys(cmd_string, "n", false)
end)
