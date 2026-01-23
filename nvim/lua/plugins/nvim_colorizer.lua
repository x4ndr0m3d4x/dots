vim.pack.add({ "https://github.com/catgoose/nvim-colorizer.lua" })

local colorizer = require('colorizer')
colorizer.setup({
    filetypes = { "html", "markdown", "css", "less", "postcss", "sass", "scss", "javascript", "typescript", "svelte" },
    user_default_options = {
        css = true,
        names = false,
        mode = "background",
    }
})
