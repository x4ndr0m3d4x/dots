return {
    "folke/todo-comments.nvim",
    event = { "BufEnter" },
    opts = {
        signs = false,
    },
    keys = {
        { "<leader>t", function () Snacks.picker.todo_comments({
            keywords = { "TODO", "FIX", "FIXME" },
            show_empty = true,
            focus = "list"
        }) end, desc = "Browse Todo's" },
    },
}
