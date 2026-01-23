vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.git").setup()  -- Required for mini.statusline
require("mini.diff").setup({ -- Required for mini.statusline
    view = {
        style = 'sign',
        signs = { add = '', change = '', delete = '' }, -- Do not display the signcolumn
    },
    delay = {
        text_change = math.huge -- Do not update so increase performance
    }
})
require("mini.statusline").setup()
require("mini.icons").setup()
require("mini.files").setup()   -- File explorer
require("mini.comment").setup({ -- Autocomment line and selection
    mappings = {
        comment_line = "<leader>/",
        comment_visual = "<leader>/"
    }
})
require("mini.ai").setup()       -- Selection around/inside
require("mini.surround").setup() -- Surround textobjects
