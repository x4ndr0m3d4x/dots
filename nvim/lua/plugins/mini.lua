return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        require("mini.git").setup() -- Required for mini.statusline
        require("mini.diff").setup({ -- Required for mini.statusline
            view = {
                style = 'sign',
                signs = { add = '', change = '', delete = '' }, -- Do not display the signcolumn
            },
            delay = {
                text_change = math.huge -- Do not update so increase performance
            }
        })
        require("mini.statusline").setup()
        require("mini.icons").setup()
        require("mini.files").setup()
    end
}
