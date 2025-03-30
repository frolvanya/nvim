local icons = require "frolik.icons"

return {
    "folke/snacks.nvim",
    opts = {
        statuscolumn = {},
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
