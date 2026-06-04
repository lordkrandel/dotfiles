vim.lsp.config('ruff', {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    init_options = {
        settings = {
            args = {
                "--select", "ALL", "--preview",
                "--ignore", ""
                .. ",ANN"
                .. ",A"
                .. ",ARG"
                .. ",B"
                .. ",C408"
                .. ",C420"
                .. ",C901"
                .. ",COM812"
                .. ",CPY001"
                .. ",D"
                .. ",DOC"
                .. ",DTZ"
                .. ",E266"
                .. ",E501"
                .. ",E713"
                .. ",E741"
                .. ",EM101"
                .. ",EM102"
                .. ",ERA001"
                .. ",FA100"
                .. ",FA102"
                .. ",FBT"
                .. ",FIX"
                .. ",FURB101"
                .. ",FURB118"
                .. ",FURB152"
                .. ",I001"
                .. ",INP001"
                .. ",N"
                .. ",PD"
                .. ",PERF"
                .. ",PGH003"
                .. ",PIE790"
                .. ",PIE808"
                .. ",PLC2701"
                .. ",PLR"
                .. ",PLW2901"
                .. ",PT"
                .. ",PTH"
                .. ",Q"
                .. ",RET"
                .. ",RET502"
                .. ",RET503"
                .. ",RSE102"
                .. ",RUF001"
                .. ",RUF005"
                .. ",RUF012"
                .. ",RUF021"
                .. ",RUF100"
                .. ",S"
                .. ",SIM102"
                .. ",SIM108"
                .. ",SIM117"
                .. ",SLF001"
                .. ",TD"
                .. ",TID252"
                .. ",TRY002"
                .. ",TRY003"
                .. ",TRY200"
                .. ",TRY300"
                .. ",TRY400"
                .. ",UP006"
                .. ",UP007"
                .. ",UP031"
                .. ",UP038"
            }
        }
    }
})
vim.lsp.enable('ruff')

local function configure_diagnostics()
    -- diagnostics config
    local diagnostic_fmt = function(diagnostic)
        return string.format('%s - %s', diagnostic.code, diagnostic.message)
    end
    vim.diagnostic.config({
        virtual_text = {format = diagnostic_fmt},
        float = false,
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
            local quickfix_win_id = vim.fn.win_getid()
            vim.keymap.set("n", "<Up>", function()
            if vim.fn.getqflist({ idx = 0 }).idx == 1 then return end
                vim.cmd("cprev")
                vim.fn.win_gotoid(quickfix_win_id)
            end, { buffer = true, silent = true })

            vim.keymap.set("n", "<Down>", function()
            if vim.fn.getqflist({ idx = 0 }).idx == #vim.fn.getqflist() then return end
                vim.cmd("cnext")
                vim.fn.win_gotoid(quickfix_win_id)
            end, { buffer = true, silent = true })

            vim.keymap.set("n", "<CR>", function()
                vim.cmd("normal! <CR>")
                local curwin = vim.fn.win_getid(vim.fn.winnr('#'))
                vim.cmd("cclose")
                vim.fn.win_gotoid(curwin)
            end, { buffer = true, silent = true })
        end,
    })
    vim.keymap.set("n", "<A-d>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local diagnostics = vim.diagnostic.get(bufnr)
        if #diagnostics > 0 then
            vim.fn.setqflist({}, ' ', {
                title = 'Diagnostics',
                items = vim.diagnostic.toqflist(diagnostics),
            })
            vim.cmd("copen")
        else
            print("No diagnostics to show.")
        end
    end, { desc = "Diagnostics to Quickfix" })
end

configure_diagnostics()
