vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
                end
            })
        end

        -- Enable the LSP
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
        -- Refresh code lens
        vim.lsp.codelens.refresh()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = 'LSP: Disable hover capability from Ruff',
})

vim.lsp.config('*', { root_markers = { '.git' } })

vim.lsp.enable({
    "rust-analyzer",
    "clangd",
    "tailwindcss",
    "html",
    "css",
    "json",
    "typescript",
    "lua",
    "svelte",
    "ty",
    "tinymist",
    "harper-ls",
    "ruff"
})
