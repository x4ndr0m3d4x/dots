return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufRead" },
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            highlight = { enable = true },
            auto_install = true
        })
    end
}
