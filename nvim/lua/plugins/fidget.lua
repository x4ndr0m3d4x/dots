vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })

local fidget = require("fidget")
fidget.setup({
    notification = {
        override_vim_notify = true
    }
})
