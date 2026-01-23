vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local which_key = require('which-key')
which_key.setup({
    preset = "helix",
    delay = 500
})
