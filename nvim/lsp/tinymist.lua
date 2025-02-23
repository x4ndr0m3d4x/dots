-- sudo pacman -Sy tinymist
---@type vim.lsp.Config
return {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { "thesis.typ", ".git" }
}
