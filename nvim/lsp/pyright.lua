-- npm i -g pyright
---@type vim.lsp.Config
return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git", "requirements.txt", "setup.py", "setup.cfg", "venv" },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly'
            }
        }
    }
}
