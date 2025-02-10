return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
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
        require("mini.files").setup()       -- File explorer
        require("mini.indentscope").setup({ -- Visualize current scope
            draw = {                        -- Do not animate and display the line immediately
                delay = 0,
                animation = require("mini.indentscope").gen_animation.none()
            },
            symbol = "│"
        })
        require("mini.comment").setup({ -- Autocomment line and selection
            mappings = {
                comment_line = "<leader>/",
                comment_visual = "<leader>/"
            }
        })
        require("mini.pairs").setup()    -- Autopairs
        require("mini.ai").setup()       -- Selection around/inside
        require("mini.move").setup()     -- Move line and selection
        require("mini.surround").setup() -- Surround textobjects
        require("mini.notify").setup()   -- Notifications
        require("mini.jump2d").setup()   -- Jump to any visible position using 2 chars
    end
}
