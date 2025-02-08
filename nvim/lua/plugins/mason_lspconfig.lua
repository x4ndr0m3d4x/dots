return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'saghen/blink.cmp' },
    lazy = false,
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = { "clangd", "tailwindcss", "html", "ts_ls", "lua_ls", "pyright", "rust_analyzer", "tinymist", "svelte" }
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Default LSP configuration
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities
                })
            end
        }
    end,
}
