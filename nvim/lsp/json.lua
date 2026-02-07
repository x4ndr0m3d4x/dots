-- npm i -g vscode-langservers-extracted
---@type vim.lsp.Config
return {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
    init_options = {
        provideFormatter = true
    }
}
