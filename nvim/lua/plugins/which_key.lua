return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix", -- Display a small window in the lower right corner
        delay = 500       -- 0.5s second delay
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
