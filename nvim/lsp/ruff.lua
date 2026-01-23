-- sudo pacman -Sy ruff
-- brew install ruff
---@type vim.lsp.Config
return {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { ".git", "requirements.txt", "setup.py", "setup.cfg", "venv" },
}
