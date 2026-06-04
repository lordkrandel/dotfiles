local map = require('map')

-- Snippets
map.n("<leader>logger", "gg0i" .. "import logging\n_logger = logging.getLogger(__name__)\n<esc>")
