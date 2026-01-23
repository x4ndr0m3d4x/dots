-- sudo pacman -Sy lua-language-server
-- brew install lua-language-server
---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            hint = { enable = true },
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                    "${3rd}/busted/library",
                },
            },
            completion = { callSnippet = "Replace" },
        },
    },
}
