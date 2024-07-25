return {
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {
            keymaps = {
                normal = "ys",
                delete = "ds",
                visual = "S",
                visual_line = "gS",
                change = "cs",
                change_line = "cS",
            },
        },
        config = function()
            require("nvim-surround").setup()
        end,
    },
}
