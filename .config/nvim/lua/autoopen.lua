vim.api.nvim_create_autocmd("BufNewFile", {
    callback = function(args)
        if vim.fn.filereadable(args.file) == 1 then return end

        local rel_path = vim.fn.fnamemodify(args.file, ":.")
        if not rel_path:find("/") then return end

        local cmd = 

        vim.fn.jobstart({ "sh", "-c", string.format(
            "fd --type f . %s | fzf --filter=%s | head -n 1",
            vim.fn.shellescape(vim.fn.getcwd()),
            vim.fn.shellescape(rel_path)
        )}, {
            stdout_buffered = true,
            on_stdout = function(_, data)
                local matched = data and data[1]
                if not matched or matched == "" then return end

                vim.schedule(function()
                    if vim.fn.filereadable(matched) ~= 1 then return end

                    local dummy_buf = args.buf
                    vim.cmd("edit " .. vim.fn.fnameescape(matched))

                    if (
                        vim.api.nvim_buf_is_valid(dummy_buf)
                        and dummy_buf ~= vim.api.nvim_get_current_buf()
                    ) then
                        vim.api.nvim_buf_delete(dummy_buf, { force = true })
                    end
                end)
            end,
        })
    end,
})
