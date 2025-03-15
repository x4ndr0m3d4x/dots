-- Download manually and add to $PATH
---@type vim.lsp.Config
return {
    cmd = { "harper-ls", "--stdio" },
    filetypes = { "c", "cpp", "cs", "gitcommit", "go", "html", "java", "javascript", "lua", "markdown", "nix", "plaintext", "python", "ruby", "rust", "swift", "tex", "text", "toml", "typescript", "typescriptreact", "haskell", "cmake", "typst", "php", "dart" },
    root_markers = { ".git" },
    single_file_support = true
}
