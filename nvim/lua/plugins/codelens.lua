vim.pack.add({ "https://github.com/oribarilan/lensline.nvim" })

local lensline = require('lensline')
lensline.setup({
    profiles = {
        {
            name = 'minimal',
            style = {
                placement = 'inline',
                prefix = '',
                render = "focused"
            }
        }
    }
})
