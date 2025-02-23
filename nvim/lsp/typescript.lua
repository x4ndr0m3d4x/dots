-- npm install -g typescript typescript-language-server
---@type vim.lsp.Config
return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript" },
    root_markers = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
    init_options = {
        hostInfo = "neovim"
    }
}
