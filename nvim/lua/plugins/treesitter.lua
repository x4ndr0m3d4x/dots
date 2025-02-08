return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufRead" },
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "bash", "c", "c_sharp", "cmake", "cpp", "css",
                "gdscript", "gdshader", "git_config", "git_rebase", "gitattributes",
                "gitcommit", "gitignore", "html", "json", "lua", "markdown",
                "markdown_inline", "python", "rust", "scss", "sql", "svelte",
                "toml", "typescript", "typst", "vimdoc"
            },
            sync_install = false,
            auto_install = true,
            ignore_install = {},
            highlight = { enable = true },
            modules = {}
        })
    end
}
