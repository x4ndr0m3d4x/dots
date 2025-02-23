-- npm install -g svelte-language-server
---@type vim.lsp.Config
return {
    cmd = { "svelteserver", "--stdio" },
    filetypes = { "svelte" },
    root_markers = { ".git", "package.json" }
}
