local map = {}
for _, mode in ipairs({ "n", "v", "i", "t" }) do
    map[mode] = function(keys, command)
        vim.keymap.set(mode, keys, command, { silent = true })
    end
end

return map
