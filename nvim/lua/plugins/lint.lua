vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })

local lint = require('lint')

lint.linters_by_ft = {
    markdown = { 'vale' },
    typst = { 'vale' }
}

lint.linters.vale = require("lint.util").wrap(lint.linters.vale, function(diagnostic)
    diagnostic.severity = vim.diagnostic.severity.HINT
    return diagnostic
end)

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        require("lint").try_lint()
    end,
})
