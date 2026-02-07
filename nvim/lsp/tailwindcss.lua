-- npm i -g @tailwindcss/language-server
---@type vim.lsp.Config
return {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "html", "markdown", "css", "less", "postcss", "sass", "scss", "javascript", "typescript", "svelte" },
    root_markers = { ".git", "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", "node_modules", "package.json" },
}
