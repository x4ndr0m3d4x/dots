require("options")
require("colors")
require("keymaps")
require("lsp")
require("plugins")

-- Remove terminal padding
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    callback = function()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        if not normal.bg then return end
        io.write(string.format("\027]11;#%06x\027\\", normal.bg))
    end,
})

vim.api.nvim_create_autocmd("UILeave", {
    callback = function() io.write("\027]111\027\\") end,
})

-- Start Tree-sitter automatically
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "bash", "c", "c_sharp", "cmake", "cpp", "css",
        "gdscript", "gdshader", "git_config", "git_rebase", "gitattributes",
        "gitcommit", "gitignore", "html", "json", "lua", "markdown",
        "markdown_inline", "python", "rust", "scss", "sql", "svelte",
        "toml", "typescript", "typst", "vimdoc", "qmljs" },
    callback = function()
        local ok, _ = pcall(vim.treesitter.start)
        if not ok then
            -- Fallback to regex syntax if TS parser/query is missing
            vim.cmd("syntax on")
        end
    end,
})

-- Undo tree
vim.cmd([[packadd nvim.undotree]])
