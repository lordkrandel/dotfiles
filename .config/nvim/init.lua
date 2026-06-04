map = require('map')
require('plugs')
require('constants')
require('paths')
require('hotkey')
require('edit')
require('snippet')
require('terminal')
require('oil_config')
require('ruff_config')
require('odoo_config')

-- Server
if vim.v.servername ~= "" then
    print("Server started at: " .. vim.v.servername)
else
    vim.fn.serverstart(config .."/.nvim.pipe")
end
