_G.MyStatusColumn = function()
    local lnum = vim.v.lnum -- The line number to draw
    local bufnr = vim.api.nvim_get_current_buf()
    local placed = vim.fn.sign_getplaced(bufnr, { lnum = lnum, group = '*' })
    local has_breakpoint = false
    local has_stopped = false
    local is_virtual = vim.v.virtnum ~= 0 -- Check if this is a virtual line (wrapped, virtual diagnostic lines)

    -- If this is a wrapped line, return empty space to maintain alignment
    if is_virtual then
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

    local content = ""

    -- Calculate relative line number
    local current_line = vim.fn.line('.')
    local relnum = vim.v.relnum -- Relative line number (0 for current line)

    if has_stopped then
        if lnum == current_line then
            content = content .. "%#DapStoppedCurrent#"
        else
            content = content .. "%#DapStopped#" -- Debugger stopped on current line has priority
        end

        content = content .. "→   " -- Debugger stopped on current line has priority
    elseif has_breakpoint then
        if lnum == current_line then
            content = content .. "%#BreakpointCurrent#"
        else
            content = content .. "%#Breakpoint#"
        end

        content = content .. "●   "
    else
        if lnum == current_line then
            content = "%#Bold#" .. string.format("%-4s", tostring(lnum))
        else
            content = "%#CursorColumn#" .. string.format("%4s", tostring(lnum))
        end
    end

    -- Add relative line number with padding and gap
    content = content .. " " -- One column gap
    if relnum == 0 then
        content = content .. "%#Bold#" .. string.format("%-4s", tostring(lnum))
    else
        content = content .. "%#CursorColumn#" .. string.format("%4s", tostring(relnum))
    end

    return content .. "%#CursorBorder#│"
end
