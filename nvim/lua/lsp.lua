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

-- Helper function to sort Tailwind CSS classes using custom LSP method
-- Timeout for LSP request (1s chosen to balance responsiveness with LSP response time)
local TAILWIND_SORT_TIMEOUT_MS = 1000

local function sort_tailwind_classes(bufnr, client_id)
    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
        return
    end
    
    -- Get all lines in the buffer
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    
    -- Pattern to match class attributes (class="..." or className="...")
    -- Matches: class="...", class='...', className="...", className='...'
    local class_pattern = '(class[Nn]ame?)%s*=%s*(["\'])([^"\']*)["\']'
    
    -- Store all class attribute locations and their sorted versions
    local edits = {}
    
    for line_num, line in ipairs(lines) do
        local line_idx = line_num - 1  -- 0-indexed for LSP
        local search_pos = 1
        
        while true do
            local attr_start, attr_end, attr_name, quote, class_string = string.find(line, class_pattern, search_pos)
            if not attr_start then
                break
            end
            
            -- Calculate the exact position of the class string content (between quotes)
            local class_start = attr_end - #class_string  -- Character position where class content starts
            
            -- Create range for the class string content only
            local range = {
                start = { line = line_idx, character = class_start - 1 },
                ['end'] = { line = line_idx, character = attr_end - 1 }
            }
            
            -- Request sorting for this specific class string
            local params = {
                textDocument = vim.lsp.util.make_text_document_params(bufnr),
                classLists = { class_string },
            }
            
            local result = client.request_sync('@/tailwindCSS/sortSelection', params, TAILWIND_SORT_TIMEOUT_MS, bufnr)
            
            if result and result.result and result.result.classLists and result.result.classLists[1] then
                local sorted_classes = result.result.classLists[1]
                
                -- Only add edit if classes were actually sorted differently
                if sorted_classes ~= class_string then
                    table.insert(edits, {
                        range = range,
                        newText = sorted_classes
                    })
                end
            end
            
            -- Move search position forward
            search_pos = attr_end + 1
        end
    end
    
    -- Apply all edits in reverse order (bottom to top) to avoid position shifts
    table.sort(edits, function(a, b)
        if a.range.start.line == b.range.start.line then
            return a.range.start.character > b.range.start.character
        end
        return a.range.start.line > b.range.start.line
    end)
    
    for _, edit in ipairs(edits) do
        vim.lsp.util.apply_text_edits({ edit }, bufnr, client.offset_encoding)
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
                sort_tailwind_classes(args.buf, args.data.client_id)
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
