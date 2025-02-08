return {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = { "clangd", "tailwindcss", "html", "ts_ls", "lua_ls", "pyright", "rust_analyzer", "tinymist", "svelte" }
        })

        -- Default LSP configuration
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup {}
            end
        }
    end,
}
