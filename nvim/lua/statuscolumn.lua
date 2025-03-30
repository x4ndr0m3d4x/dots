-- Your existing statuscolumn code:
local function get_statuscolumn_str()
-- If vim.v.virtnum is > 0, this is a virtual line/text, display nothing
  if vim.v.virtnum ~= 0 then
    return ""
  end

  -- Get the line number for the line being drawn by the statuscolumn
  local lnum = vim.v.lnum
  -- Check if this is the line the cursor is currently on
  local is_current_line = lnum == vim.fn.line('.')
  -- Get the buffer number for sign and diagnostic lookups
  local buf = vim.fn.bufnr('%')

  -- Check for nvim-dap signs (Stopped and Breakpoint)
  -- Revised logic for clarity and ensuring precedence
  local dap_symbol = nil
  local stopped_sign_found = false
  local breakpoint_sign_found = false
  local placed_signs = vim.fn.sign_getplaced(buf, { lnum = lnum })

  if placed_signs and placed_signs[1] and placed_signs[1].signs then
    local signs = placed_signs[1].signs
    for _, sign in ipairs(signs) do
      if sign.name == 'DapStopped' then
        stopped_sign_found = true
        break -- Found the highest priority sign (DapStopped), no need to check further
      elseif sign.name == 'DapBreakpoint' then
        breakpoint_sign_found = true
        -- Continue checking in case DapStopped is also present
      end
    end
  end

  -- Assign symbol based on found signs, prioritizing DapStopped
  if stopped_sign_found then
    dap_symbol = " →  " -- Padded symbol
  elseif breakpoint_sign_found then
    dap_symbol = " B  " -- Padded symbol
  end

  local is_dap_line = dap_symbol ~= nil
  local display_str -- The text to display (number or symbol)
  local final_hl_group_name -- The name of the final highlight group to use

  -- === Determine display string and highlight group ===

  if is_dap_line then
    -- 1. DAP Sign Priority
    display_str = dap_symbol
    -- Use a specific highlight for DAP signs if desired, otherwise default
    final_hl_group_name = "LineNr" -- Or e.g., "DapSign" if you define it
  else
    -- 2. Non-DAP Line Logic (Diagnostics, Current Line, Default)

    -- Determine display string based on alignment
    if is_current_line then
      display_str = string.format("%-4s", tostring(lnum)) -- Right-aligned (4 chars wide)
    else
      display_str = string.format("%4s", tostring(lnum)) -- Left-aligned (4 chars wide)
    end

    -- Check diagnostics
    local diagnostics = vim.diagnostic.get(buf, { lnum = lnum - 1 }) -- Diagnostics are 0-indexed
    local highest_severity = vim.diagnostic.severity.HINT + 1
    local diagnostic_hl_group = nil

    if #diagnostics > 0 then
      for _, d in ipairs(diagnostics) do
        highest_severity = math.min(highest_severity, d.severity)
      end
      -- Map severity to highlight group name
      if highest_severity == vim.diagnostic.severity.ERROR then
        diagnostic_hl_group = "DiagnosticError"
      elseif highest_severity == vim.diagnostic.severity.WARN then
        diagnostic_hl_group = "DiagnosticWarn"
      elseif highest_severity == vim.diagnostic.severity.INFO then
        diagnostic_hl_group = "DiagnosticInfo"
      elseif highest_severity == vim.diagnostic.severity.HINT then
        diagnostic_hl_group = "DiagnosticHint"
      end
    end

    -- Determine final highlight group name
    if diagnostic_hl_group then
      -- Use diagnostic highlight if available (takes priority)
      final_hl_group_name = diagnostic_hl_group
    elseif is_current_line then
      -- Use CursorLineNr only if no diagnostic on the current line
      final_hl_group_name = "CursorLineNr"
    else
      -- Default to LineNr for non-current lines with no diagnostics
      final_hl_group_name = "LineNr"
    end
  end

  -- Combine the highlight group and the display string.
  local main_content = "%#" .. final_hl_group_name .. "#" .. display_str

  -- Reset highlighting, then add the delimiter (so it uses default highlight).
  return main_content .. "%*" .. "│"
end

_G.get_custom_statuscolumn = get_statuscolumn_str
vim.opt.statuscolumn = '%!v:lua._G.get_custom_statuscolumn()'
