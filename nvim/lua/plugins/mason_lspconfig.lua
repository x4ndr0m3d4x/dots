return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'saghen/blink.cmp' },
    lazy = false,
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd", "tailwindcss", "html", "ts_ls", "lua_ls", "pyright", "rust_analyzer", "tinymist", "svelte",
                "csharp_ls", "ltex"
            }
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Default LSP configuration
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                local M = {}

                require("lspconfig")[server_name].setup({
                    -- HACK: vim.lsp.inaly_hint.enable(true) won't render inlay hints for the
                    -- currently visible part of the buffer if the LSP is not ready before the
                    -- on_attach function is called as there's no standardized way of telling if an
                    -- LSP is ready yet. A fix isn't apparently planned. This aims to mitigate it.
                    handlers = {
                        ["experimental/serverStatus"] = function(_, result, ctx, _)
                            if result.quiescent and not M.ran_once then
                                for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
                                    vim.lsp.inlay_hint.enable(false)
                                    vim.lsp.inlay_hint.enable(true)
                                end
                                M.ran_once = true
                            end
                        end
                    },
                    on_attach = function(client, bufnr)
                        if client.supports_method("textDocument/inlayHint") then
                            vim.lsp.inlay_hint.enable(true)
                        end
                    end,
                    capabilities = capabilities
                })
            end
        }
    end,
}
