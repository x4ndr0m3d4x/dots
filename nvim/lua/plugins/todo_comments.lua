vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })

local todo_comments = require('todo-comments')
todo_comments.setup({
    signs = false
})
