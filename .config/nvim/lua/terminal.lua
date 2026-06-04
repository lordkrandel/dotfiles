require("flatten").setup({
    window = {
        open = "tab", -- Forces all nested opens to be new tabs
    },
})

-- Hotkeys
map.t("<esc>", "<C-\\><C-n>")
map.t("<C-PageUp>", "<C-\\><C-n><C-PageUp>")
map.t("<C-PageDown>", "<C-\\><C-n><C-PageDown>")

-- Auto insert mode on terminal buffers
local term_augroup = vim.api.nvim_create_augroup("AutoInsertTerminal", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    group = term_augroup,
    pattern = "term://*",
    command = "startinsert",
})

-- git will not be able to read the file we're editing if we delete the tempfile
-- as soon as the buffer closes, so we delay it a bit
local terminal_auto_close_group = vim.api.nvim_create_augroup("TerminalAutoCloseHidden", { clear = true })
vim.api.nvim_create_autocmd("BufHidden", {
    group = terminal_auto_close_group,
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        if vim.bo[buf].buftype == "terminal" then
            vim.schedule(function()
                -- Check if the buffer is still valid AND no window is currently displaying it.
                -- BufHidden means no window is displaying it, but this check is for safety.
                local buf_info = vim.fn.getbufinfo(buf)[1]
                if vim.api.nvim_buf_is_valid(buf) and buf_info and #buf_info.windows == 0 then
                    -- Delete the buffer (kills the process)
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            end)
        end
    end,
    desc = "Safely delete hidden terminal buffer.",
})

-- Autocomplete in terminal, requires fzf
map.t('<C-p>', function()
    local term_buf = vim.api.nvim_get_current_buf()
    local term_win = vim.api.nvim_get_current_win()

    -- 1. Grab fragment typed so far
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
    local current_line = vim.api.nvim_get_current_line()
    local fragment = string.match(current_line:sub(1, cursor_col), "[%a%d%_%-%.%/]+$") or ""

    -- 2. Scrape and parse paths cleanly out of screen text
    local lines = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
    local clean_items, seen = {}, {}

    for _, line in ipairs(lines) do
        for path in string.gmatch(line, "[%a%d%_%-%.%/]+") do
            if (path:find("/") or path:find("%.")) and not seen[path] then
                table.insert(clean_items, path)
                seen[path] = true
            end
        end
    end

    if #clean_items == 0 then
        for _, line in ipairs(lines) do
            local trimmed = line:match("^%s*(.-)%s*$")
            if trimmed ~= "" and not seen[trimmed] then
                table.insert(clean_items, trimmed)
                seen[trimmed] = true
            end
        end
    end

    local temp_in, temp_out = vim.fn.tempname(), vim.fn.tempname()
    vim.fn.writefile(clean_items, temp_in)

    -- 3. Open borderless overlay window growing UPWARDS from the current prompt
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    local height = 10
    vim.api.nvim_open_win(buf, true, {
        relative = 'cursor',
        row = - height + 1,
        col = - #fragment,
        width = 60,
        height = height,
        style = 'minimal',
        border = 'none'
    })

    -- 4. Fire FZF using default bottom-up layout so your matches sit right next to the prompt
    local fzf_cmd = string.format("fzf --query=%s --layout=default < %s > %s", vim.fn.shellescape(fragment), temp_in, temp_out)

    vim.fn.termopen(fzf_cmd, {
        on_exit = function()
            if vim.api.nvim_win_is_valid(0) then vim.api.nvim_win_close(0, true) end
            if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end

            if vim.fn.filereadable(temp_out) == 1 then
                local result = vim.fn.readfile(temp_out)
                if #result > 0 and result[1] ~= "" then
                    local selection = result[1]
                    local keys_to_send = selection

                    if selection:lower():sub(1, #fragment) == fragment:lower() then
                        keys_to_send = selection:sub(#fragment + 1)
                    end

                    vim.api.nvim_set_current_win(term_win)
                    vim.cmd("startinsert")

                    vim.defer_fn(function()
                        vim.api.nvim_chan_send(vim.b.terminal_job_id, keys_to_send)
                    end, 10)
                end
            end

            vim.fn.delete(temp_in)
            vim.fn.delete(temp_out)
        end
    })
    vim.cmd("startinsert")
end)
