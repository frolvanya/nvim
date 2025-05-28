local icons = require "frolik.icons"

return {
    "folke/snacks.nvim",
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        indent = {
            indent = {
                char = icons.ui.LineLeft,
            },
            scope = {
                char = icons.ui.LineLeft,
                hl = "IndentScope",
            },
            animate = {
                enabled = false,
            },
        },
    },
}
