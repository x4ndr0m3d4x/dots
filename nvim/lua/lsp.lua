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

-- Helper function to sort Tailwind CSS classes using code action
local function sort_tailwind_classes(bufnr)
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count - 1, line_count, false)[1]
    local last_line_len = last_line and #last_line or 0
    
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
        range = {
            start = { line = 0, character = 0 },
            ['end'] = { line = line_count - 1, character = last_line_len }
        },
        context = {
            diagnostics = {},
            only = { "source.sortTailwindClasses" }
        }
    }
    
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    if not result or vim.tbl_isempty(result) then
        return
    end
    
    for client_id, response in pairs(result) do
        if response.result then
            for _, action in pairs(response.result) do
                -- Apply workspace edit if present
                if action.edit then
                    local client = vim.lsp.get_client_by_id(client_id)
                    if client then
                        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                    end
                end
                -- Execute command if present
                if action.command then
                    vim.lsp.buf.execute_command(action.command)
                end
            end
        end
    end
end

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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_tailwindcss_sort', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil or client.name ~= 'tailwindcss' then
            return
        end
        
        -- Hook into BufWritePre to sort Tailwind classes before save
        -- Create a buffer-local augroup to ensure no duplicates
        local augroup = vim.api.nvim_create_augroup('lsp_tailwindcss_sort_buf_' .. args.buf, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = args.buf,
            callback = function()
                sort_tailwind_classes(args.buf)
            end,
            desc = 'Sort Tailwind CSS classes on save'
        })
    end,
    desc = 'LSP: Setup Tailwind CSS class sorting on save',
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
