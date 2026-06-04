-- Explore current folder with Oil
map.n("<C-e>", ":e %:h<CR>")

oil = require("oil")
oil.setup({
    view_options = {
        show_hidden = true
    },
    keymaps = {
        ["Y"] = {
            callback = function()
                local entry = oil.get_cursor_entry()
                local dir = oil.get_current_dir()

                if not entry or not dir then
                    vim.notify("No entry under cursor!", vim.log.levels.WARN)
                    return
                end

                if not dir:match("/$") then 
                    dir = dir .. "/" 
                end

                yanked_name = entry.name
                yanked_dir = dir

                vim.notify("Yanked entry: " .. entry.name, vim.log.levels.INFO)
            end,
            desc = "Yank file entry data for symlink"
        }, 
        ["P"] = {
            callback = function()
                if not yanked_name or not yanked_dir then
                    vim.notify("Nothing yanked! Press 'Y' on a file first.", vim.log.levels.ERROR)
                    return
                end

                local current_dir = oil.get_current_dir()
                if not current_dir then return end

                if not current_dir:match("/$") then 
                    current_dir = current_dir .. "/" 
                end
                
                local src_path = yanked_dir .. yanked_name

                -- Add "_link" suffix only if we're pasting in the same directory
                local target_name = yanked_name
                if yanked_dir == current_dir then
                    local ext_start = yanked_name:find('%.[^%.]*$')
                    if ext_start then
                        target_name = yanked_name:sub(1, ext_start - 1) .. "_link" .. yanked_name:sub(ext_start)
                    else
                        target_name = yanked_name .. "_link"
                    end
                end

                -- Construct text layout Oil expects for a symlink
                local link_text = string.format('%s -> %s', target_name, src_path)
                
                -- Simulate typing it in to pass Oil's internal tracking
                vim.cmd("normal! o" .. link_text)

                -- Move cursor and visually select target name for quick edits
                vim.cmd("normal! 0v" .. (#target_name - 1) .. "l")
            end,
            desc = "Paste yanked entry as a symlink"
        }
    }
})

-- Cleanup oil paths in the status bar
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*oil://*",
    callback = function(args)
        local current_file = args.file
        if current_file:find("oil://") and not vim.startswith(current_file, "oil://") then
            local clean_path = current_file:match("(oil://.*)")
            if clean_path then
                vim.schedule(function()
                    vim.cmd.edit(clean_path)
                end)
            end
        end
    end
})
