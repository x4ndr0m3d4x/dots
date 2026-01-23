vim.pack.add({ "https://github.com/rachartier/tiny-glimmer.nvim" })

local glimmer = require('tiny-glimmer')
glimmer.setup({
    overwrite = {
        yank = {
            default_animation = {
                name = "fade",
                settings = {
                    from_color = "CurSearch",
                    to_color = "CursorLine"
                }
            }
        },
        search = {
            enabled = true,
            default_animation = "fade",
        },
        undo = {
            enabled = true
        },
        redo = {
            enabled = true
        }
    },
    animations = {
        fade = {
            from_color = "CurSearch",
            to_color = "Normal"
        },
        reverse_fade = {
            from_color = "CurSearch",
            to_color = "Normal"
        },
        bounce = {
            from_color = "CurSearch",
            to_color = "Normal"
        },
        left_to_right = {
            from_color = "CurSearch",
            to_color = "Normal"
        }
    }
})
