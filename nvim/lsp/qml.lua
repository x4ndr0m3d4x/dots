-- Should come with qt installs
---@type vim.lsp.Config
return {
    cmd = { "qmlls6", "-E" },
    filetypes = { "qml" },
    root_markers = { ".git" },
    single_file_support = true
}
