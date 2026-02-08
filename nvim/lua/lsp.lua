local function get_classlist_entries(bufnr)
    local entries = {}
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for i, line in ipairs(lines) do
        local init = 1

        -- 1) class="..."
        while true do
            local s, e, _, content = line:find('class%s*=%s*([\'"])(.-)%1', init)
            if not s then break end

            local content_start = e - #content
            local content_end = e - 1

            table.insert(entries, {
                value = content,
                range = {
                    start = { line = i - 1, character = content_start - 1 },
                    ["end"] = { line = i - 1, character = content_end },
                },
            })

            init = e + 1
        end

        -- 2) class={ "..." } or class={ '...' }
        init = 1
        while true do
            local s, e, _, content = line:find('class%s*=%s*{%s*([\'"])(.-)%1%s*}', init)
            if not s then break end

            -- Find the quoted content inside the braces
            local content_start = e - #content - 1 -- Off by 1 because of the closing quote
            local content_end = e - 2

            table.insert(entries, {
                value = content,
                range = {
                    start = { line = i - 1, character = content_start },
                    ["end"] = { line = i - 1, character = content_end + 1 },
                },
            })

            init = e + 1
        end
    end

    return entries
end

local function sort_tailwind_classlists(client, bufnr)
    local entries = get_classlist_entries(bufnr)
    if #entries == 0 then return end

    local classLists = {}
    for _, entry in ipairs(entries) do
        table.insert(classLists, entry.value)
    end

    local done = false
    local result = nil

    client:request("@/tailwindCSS/sortSelection", {
        uri = vim.uri_from_bufnr(bufnr),
        classLists = classLists,
    }, function(err, res)
        if err then
            vim.notify("Tailwind error: " .. vim.inspect(err), vim.log.levels.ERROR)
            done = true
            return
        end
        result = res
        done = true
    end, bufnr)

    vim.wait(1000, function() return done end)

    if not result or not result.classLists then return end

    local edits = {}
    for i, entry in ipairs(entries) do
        local newText = result.classLists[i]
        if newText and newText ~= entry.value then
            table.insert(edits, {
                range = entry.range,
                newText = newText,
            })
        end
    end

    if #edits > 0 then
        -- Apply from bottom to top to avoid shifting ranges
        vim.lsp.util.apply_text_edits(edits, bufnr, client.offset_encoding)
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        -- Inside the existing `LspAttach` callback, after client lookup
        if client.name == "tailwindcss" then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = ev.buf,
                callback = function()
                    sort_tailwind_classlists(client, ev.buf)
                end,
            })
        end

        if client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = ev.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
                end,
            })
        end

        -- Enable the LSP
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
        -- Refresh code lens
        vim.lsp.codelens.refresh()
    end,
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
