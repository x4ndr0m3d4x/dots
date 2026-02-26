local map = vim.keymap.set

--- QoL ---
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "De-highlight search results", noremap = true, silent = true })
map({ "n", "i" }, "<D-space>", "<Nop>", { noremap = true, silent = true })
map("n", "U", function() vim.cmd([[Undotree]]) end, { desc = "Open the Undotree", noremap = true, silent = true })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end,
    { desc = "Buffer Local Keymaps (which-key)" })

--- WINDOW NAVIGATION ---
map("n", "<C-h>", "<C-w>h", { desc = "Cursor to window left", noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "Cursor to window down", noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "Cursor to window up", noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "Cursor to window right", noremap = true, silent = true })

--- PICKERS ---
map("n", "<C-n>", function() MiniFiles.open() end, { desc = "Open file explorer", noremap = true, silent = true })
map("n", "<leader>o", function() Snacks.picker.buffers({ focus = "list" }) end,
    { desc = "Browse open buffers", noremap = true, silent = true })
map("n", "<leader>gr", function() Snacks.picker.grep({ focus = "list" }) end,
    { desc = "Grep", noremap = true, silent = true })
map("n", "<leader>f", function() Snacks.picker.files({ focus = "list" }) end,
    { desc = "Files Picker", noremap = true, silent = true })
map("n", "<leader>gi", function() Snacks.picker.gh_issue({ focus = "list" }) end, { desc = "GitHub Issues (open)" })
map("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all", focus = "list" }) end,
    { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", function() Snacks.picker.gh_pr({ focus = "list" }) end, { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all", focus = "list" }) end,
    { desc = "GitHub Pull Requests (all)" })
map("n", "<leader>td",
    function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }, show_empty = true, focus = "list" }) end,
    { desc = "Browse Todo's" })

--- LSP ---
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", noremap = true, silent = true })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", noremap = true, silent = true })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", noremap = true, silent = true })
map("n", "gR", vim.lsp.buf.references, { desc = "Go to references", noremap = true, silent = true })
map("n", "ga", vim.lsp.buf.code_action, { desc = "Code action", noremap = true, silent = true })
map("n", "gr", vim.lsp.buf.rename, { desc = "Rename Symbol", noremap = true, silent = true })
map("n", "<leader>ih", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
    { desc = "Toggle inlay hints", noremap = true, silent = true })
map("n", "<leader>ai", function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
    { desc = "Toggle GitHub Copilot Window" })

--- DEBUG ---
-- map("n", "<leader>ds", require("dap").continue, { desc = "Start debugging", noremap = true, silent = true })
-- map("n", "<leader>do", require("dap").step_over, { desc = "Debug - step over", noremap = true, silent = true })
-- map("n", "<leader>di", require("dap").step_into, { desc = "Debug - step into", noremap = true, silent = true })
-- map("n", "<leader>dt", require("dap").step_out, { desc = "Debug - step out", noremap = true, silent = true })
-- map("n", "<leader>db", require("dap").step_back, { desc = "Debug - step back", noremap = true, silent = true })
-- map("n", "<leader>dc", require("dap").run_to_cursor, { desc = "Debug - run to cursor", noremap = true, silent = true })
