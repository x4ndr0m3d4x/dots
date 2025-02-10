local M = {}

function M.get()
    local lnum = vim.v.lnum
    local bufnr = vim.api.nvim_get_current_buf()
    local placed = vim.fn.sign_getplaced(bufnr, { lnum = lnum, group = '*' })
    local has_breakpoint = false
    local has_stopped = false

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
        return tostring(lnum) -- Default to the line number
    end
end

_G.MyStatusColumn = M.get

return M
