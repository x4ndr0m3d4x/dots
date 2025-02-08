-- Only show virtual lines on keybind and hide it right after
local function show_line_virtual_diagnostics()
  -- Save the current diagnostic settings so we can revert
  local old_config = vim.deepcopy(vim.diagnostic.config())

  -- Turn on virtual_lines just for the current line
  vim.diagnostic.config({
    virtual_lines = { current_line = true },
  })

  -- Create an autocmd group to clear these settings on cursor move
  local group = vim.api.nvim_create_augroup("HideLineVirtualDiagnostics", { clear = true })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    once = true,
    callback = function()
      -- Restore the old diagnostic config
      vim.diagnostic.config(old_config)
      -- Delete the group to clean up
      vim.api.nvim_del_augroup_by_id(group)
    end,
  })
end

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "De-highlight search results", noremap = true, silent = true })
map("n", "<C-h>", "<C-w>h", { desc = "Cursor to window left", noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "Cursor to window down", noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "Cursor to window up", noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "Cursor to window right", noremap = true, silent = true })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", noremap = true, silent = true })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", noremap = true, silent = true })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", noremap = true, silent = true })
map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Show signature help", noremap = true, silent = true })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol", noremap = true, silent = true })
map("n", "L", show_line_virtual_diagnostics, { noremap = true, silent = true })
map("n", "<C-n>", MiniFiles.open, { desc = "Open file explorer", noremap = true, silent = true })
map("n", "<leader>o", function() Snacks.picker.buffers({ focus = "list" }) end, { desc = "Browse open buffers", noremap = true, silent = true })
