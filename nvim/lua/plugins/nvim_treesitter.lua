vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local treesitter = require('nvim-treesitter')
treesitter.install({ "bash", "c_sharp", "cmake", "cpp", "css", "gdscript", "gdshader", "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
    "html", "json", "python", "rust", "scss", "sql", "svelte", 
    "toml", "javascript", "typescript", "typst" }
):wait(300000)
