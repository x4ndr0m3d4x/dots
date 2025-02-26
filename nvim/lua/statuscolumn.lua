local M = {}

function M.get()
    local lnum = vim.v.lnum
    local bufnr = vim.api.nvim_get_current_buf()
    local placed = vim.fn.sign_getplaced(bufnr, { lnum = lnum, group = '*' })
    local has_breakpoint = false
    local has_stopped = false
    local is_wrapped = vim.v.virtnum ~= 0  -- Check if this is a wrapped line

    -- If this is a wrapped line, return empty space to maintain alignment
    if is_wrapped then
        return " "
    end

    for _, group in ipairs(placed) do
        for _, sign in ipairs(group.signs) do
            if sign.name == "DapStopped" then
                has_stopped = true
                break
            elseif sign.name:match("DapBreakpoint") then
                has_breakpoint = true
            end
        end
        if has_stopped then break end
    end

    if has_stopped then
        return "→" -- Debugger stopped on current line has priority
    elseif has_breakpoint then
        return "B"
    else
        local total_lines = vim.fn.line('$')
        local number_width = vim.o.numberwidth - 1 -- Account for Vim's numberwidth behavior
        local current_line = vim.fn.line('.')

        if lnum == current_line then
            -- Current line: left-aligned with highlight
            local line_number = tostring(lnum)
            local padding = string.rep(" ", number_width - #line_number)
            return "%#CursorLineNr#" .. line_number .. padding .. "%*"
        else
            -- Other lines: right-aligned to fill the available space completely
            local line_number = tostring(lnum)
            local padding = string.rep(" ", number_width - #line_number)
            return padding .. line_number
        end
    end
end

_G.MyStatusColumn = M.get

return M
