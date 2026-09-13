----------------------------------
--
--            nvim
--
----------------------------------

-- Packages
for _, mod in ipairs({
    "map",
    "plugs",
    "autoopen",
    "paths",
    "bookmarks",
    "hotkey",
    "edit",
    "open_link",
    "terminal",
    "oil_config",
    "ruff_config",
    "odoo_config",
    "rgg"
}) do
    package.loaded[mod] = nil
    package.loaded["user." .. mod] = nil

    local ok, res = pcall(require, mod)
    if ok then
        -- Set a global variable for each module
        _G[mod] = res
    else
        vim.notify("Error loading " .. mod .. ": " .. tostring(res), vim.log.levels.ERROR)
    end

end

-- SSH Auth socket
vim.env.SSH_AUTH_SOCK = vim.fn.expand("/run/user/1000/ssh-agent.socket")

-- Universal Server Pipe for terminal subshells & sudo
local pipe_path = "/tmp/nvim-odoo.pipe"

-- Clean up stale pipe and start server explicitly
pcall(os.remove, pipe_path)
pcall(vim.fn.serverstart, pipe_path)
pcall(vim.fn.system, { "chmod", "666", pipe_path })

print("config refreshed")
