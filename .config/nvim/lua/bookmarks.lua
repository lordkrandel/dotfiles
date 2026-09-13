-- Fast files
local bookmarks_file = vim.fn.expand("~/.config/nvim/bookmarks.txt")

vim.keymap.set({ "n", "t" }, "<A-b>", function()
    if vim.fn.filereadable(bookmarks_file) == 0 then
        return
    end

    -- The window where FZF is going to run.
    local original_win = vim.api.nvim_get_current_win()

    -- Find existing terminal buffers.
    local terminals = {}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buftype == "terminal"
        then
            table.insert(terminals, buf)
        end
    end

    vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
        source = vim.fn.readfile(bookmarks_file),

        -- FZF uses the current window.
        -- NOT a popup.
        window = "enew",

        options = {
            "--layout=reverse-list",
            "--padding=2,0,0,0",
        },

        sink = function(choice)
            if not choice or choice == "" then
                return
            end

            -- Remove ANSI escape sequences.
            choice = choice:gsub("\27%[[0-9;]*[[:alpha:]]", "")

            -- Bookmark format:
            --
            -- odoo           ~/work/odoo
            -- nvim           ~/.config/nvim/init.lua
            -- terminal       term://*
            --
            local path = choice:match("^%S+%s+(.+)$") or choice
            path = vim.trim(path)

            -- Terminal bookmark
            if path:match("^term://") then
                vim.schedule(function()
                    if vim.api.nvim_win_is_valid(original_win) then
                        vim.api.nvim_set_current_win(original_win)
                    end

                    local buf = terminals[1]

                    if buf and vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_set_current_buf(buf)
                    else
                        vim.cmd("terminal")
                    end

                    vim.cmd("startinsert")
                end)

                return
            end

            -- Expand ~.
            path = vim.fn.expand(path)

            -- Make absolute and resolve symlinks / "..".
            path = vim.fn.fnamemodify(path, ":p")
            path = vim.fn.resolve(path)

            vim.schedule(function()
                -- Make sure we're operating in the FZF window.
                if vim.api.nvim_win_is_valid(original_win) then
                    vim.api.nvim_set_current_win(original_win)
                end

                ------------------------------------------------------------
                -- Directory
                ------------------------------------------------------------
                if vim.fn.isdirectory(path) == 1 then
                    -- Change the working directory.
                    vim.cmd("lcd " .. vim.fn.fnameescape(path))

                    -- Make THIS window become the selected directory.
                    vim.cmd("edit .")

                    return
                end

                ------------------------------------------------------------
                -- File
                ------------------------------------------------------------
                vim.cmd("edit " .. vim.fn.fnameescape(path))
            end)
        end,
    }))

    -- Escape terminal mode inside FZF.
    vim.keymap.set("t", "<Esc>", "<C-c>", {
        buffer = true,
        remap = false,
    })
end, {
    desc = "FZF Bookmarks",
})
