vim.pack.add({ "https://github.com/jackplus-xyz/player-one.nvim" })

local player_one = require('player-one')
player_one.setup({
    theme = "chiptune",
    master_volume = 0.2
})
