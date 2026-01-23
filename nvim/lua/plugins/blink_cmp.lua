vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range('*') },
    "https://github.com/rafamadriz/friendly-snippets" })

local blink = require("blink.cmp")
blink.setup({
    fuzzy = {
        implementation = "prefer_rust"
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },
    signature = { enabled = true },
    completion = {
        keyword = {
            range = "full"
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = false
            }
        },
        documentation = {
            auto_show = true
        },
        menu = {
            draw = {
                gap = 1,
                columns = { { "kind_icon" }, { "label" }, { "kind" } }
            }
        }
    }
})
