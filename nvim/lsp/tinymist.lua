-- sudo pacman -Sy tinymist
-- brew install tinymist
---@type vim.lsp.Config
return {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { "thesis.typ", ".git" }
}
