-- npm i -g vscode-langservers-extracted
---@type vim.lsp.Config
return {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { ".git", "package.json", "node_modules" },
    init_options = {
        provideFormatter = true
    },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true }
    }
}
