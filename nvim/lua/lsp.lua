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
    end,
})

vim.lsp.config('*', { root_markers = { '.git' } })

vim.lsp.enable({
    "rust-analyzer",
    "clangd",
    "tailwindcss",
    "html",
    "typescript",
    "lua",
    "svelte",
    "pyright",
    "tinymist",
    "harper-ls",
    "r"
})
