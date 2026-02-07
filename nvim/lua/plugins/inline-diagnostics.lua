vim.pack.add({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })

local diagnostics = require('tiny-inline-diagnostic')
diagnostics.setup({
    options = {
        show_source = {
            enabled = true
        },
        virt_texts = {
            priority = 10000
        }
    }
})
