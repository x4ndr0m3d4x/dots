vim.pack.add({ "https://github.com/nvzone/volt", "https://github.com/gisketch/triforce.nvim" })

local triforce = require('triforce')
triforce.setup({
    keymap = {
        show_profile = '<leader>tp'
    }
})
