-- npm i -g vscode-langservers-extracted
---@type vim.lsp.Config
return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_markers = { ".git", "package.json", "node_modules" },
    init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { 'html', 'css', 'javascript' },
    }
}
