-- paru -S ty
-- brew install ty
---@type vim.lsp.Config
return {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { ".git", "requirements.txt", "setup.py", "setup.cfg", "venv" },
    settings = {
        python = {
            analysis = {
                diagnostics = true,
                inlayHints = true,
                smartCompletion = true,
                checkOnType = false
            }
        }
    }
}
