return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
        user_default_options = {
            css = true,
            tailwind = "both",
            mode = "virtualtext",
            virtualtext_inline = "before",
            tailwind_opts = {
                update_names = true, -- Enabled highlight custom colors from tailwind.config.ts
            },
        }
    }
}
