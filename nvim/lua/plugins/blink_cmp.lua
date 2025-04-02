return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "Kaiser-Yang/blink-cmp-dictionary",
            dependencies = { "nvim-lua/plenary.nvim" }
        }

    },
    version = "*",
    opts = {
        keymap = { preset = 'default' },
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
    }
}
