vim.pack.add({ "https://github.com/serhez/bento.nvim" })
local bento = require('bento')
bento.setup({
    ui = {
        floating = {
            position = "top-right"
        }
    }
})
