vim.pack.add({ 'https://github.com/saghen/blink.indent' })

local indent = require('blink.indent')
indent.setup({
    scope = {
        highlights = { "BlinkIndentScope" }
    }
})
