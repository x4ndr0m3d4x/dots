--- DISABLE DEFAULT PROVIDERS ---
vim.g.loaded_node_provider = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

--- LEADER ---
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--- TAB ---
vim.opt.tabstop = 4      -- A tab counts as 4 spaces
vim.opt.shiftwidth = 4   -- How many spaces for each level of autoindent
vim.opt.expandtab = true -- When pressing <Tab> in insert mode, insert the appropriate amount of spaces instead

--- STATUS LINE ---
-- vim.opt.cmdheight = 0 -- Effectively hide the cmd line (replaces statusline while in command mode)
vim.opt.laststatus = 3 -- Always show a status line, but only in the last window

--- CURSOR ---
vim.opt.scrolloff = 5     -- How many lines (at least) to keep above or below the cursor
vim.opt.sidescrolloff = 5 -- How many columns (at least) to keep to the left or to the right of the cursor
vim.opt.cursorline = true -- Highlight the line the cursor is currently at

--- MISC ---
vim.opt.smartcase = true          -- Respect case when searching using uppercase characters, ignore otherwise
vim.opt.termguicolors = true      -- Enabled 24-bit RGB color
vim.opt.wrap = false              -- Whether to wrap lines longer than the width of the window
vim.opt.selection = "old"         -- Do not allow including the last character while selecting
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste

--- LINE NUMBER ---
vim.opt.number = true         -- Show the line numbers in front of each line
vim.opt.relativenumber = true -- Show the line numbers relative to the current cursor position

--- DIAGNOSTICS ---
vim.diagnostic.config({
    update_in_insert = false, -- Do not update diagnostics when in insert mode
    virtual_text = false,     -- Do not show virtual text (diagnostics at the end of the line)
    virtual_lines = false,    -- Do not show virtual lines (under a given line)
    underline = true,         -- Underline a given token for diagnostics
    signs = {                 -- Show line diagnostics by coloring the line number
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        }
    }
})
