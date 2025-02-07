local keymap = vim.keymap.set

--- Remap COQ's <C-h> for cycling through placeholders to <Tab>
vim.g.coq_settings = {
	keymap = {
		jump_to_mark = ""
	}
}

--- Window navigation ---
keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

--- BUFFERS ---
keymap("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
keymap("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })
keymap("n", "<leader>x", ":bdelete<CR>", { noremap = true, silent = true })

--- LSP ---
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- event.buf = buffer number
    local buf = event.buf

    -- Common LSP actions
    -- Go to definition
    keymap("n", "gd", function()
      vim.lsp.buf.definition()
    end, { buffer = buf, desc = "Go to Definition" })

    -- Show LSP hover doc
    keymap("n", "K", function()
      vim.lsp.buf.hover()
    end, { buffer = buf, desc = "Hover Documentation" })

    -- Go to references
    keymap("n", "gr", function()
      vim.lsp.buf.references()
    end, { buffer = buf, desc = "Go to References" })

    -- Show code actions
    keymap({ "n", "v" }, "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, { buffer = buf, desc = "Code Action" })

    -- Rename symbol
    keymap("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, { buffer = buf, desc = "Rename Symbol" })

    -- Diagnostics
    keymap("n", "gl", function()
      vim.diagnostic.open_float()
    end, { buffer = buf, desc = "Line Diagnostics" })

    -- etc. (You can add more as needed)
  end
})

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
    once = true,          -- so it only runs once
    callback = function()
      -- Restore the old diagnostic config
      vim.diagnostic.config(old_config)
      -- Delete the group to clean up
      vim.api.nvim_del_augroup_by_id(group)
    end,
  })
end

vim.keymap.set("n", "L", show_line_virtual_diagnostics, { noremap = true, silent = true })
