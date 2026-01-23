vim.pack.add({ "https://github.com/folke/snacks.nvim" })

local snacks = require('snacks')
snacks.setup({
    picker = { enabled = true },
    gh = { enabled = true }
})
