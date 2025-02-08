return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
        })
    end,
    init = function()
        vim.cmd.colorscheme "catppuccin"

        -- Change all diagnostic highlights to use curly lines
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
            undercurl = true,
            sp = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg
        });
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
            undercurl = true,
            sp = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg
        });
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
            undercurl = true,
            sp = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg
        });
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
            undercurl = true,
            sp = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg
        });
    end,
}
