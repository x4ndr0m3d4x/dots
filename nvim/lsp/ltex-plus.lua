-- Download manually and add to $PATH
---@type vim.lsp.Config
return {
    cmd = { "ltex-ls-plus" },
    filetypes = { "gitcommit", "html", "markdown", "plaintext", "tex", "text", "typst" },
    root_markers = { ".git" }
}
