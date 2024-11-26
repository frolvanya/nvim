return {
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            local wk = require "which-key"

            wk.setup {
                preset = "modern",
                win = { border = "rounded", title = false },
                icons = { group = "  ", separator = " ", mappings = false },
            }

            wk.add {
                { "g", group = "Goto" },
                { "<leader>a", group = "Copilot Chat", mode = "nv" },
                { "<leader>b", group = "Buffers" },
                { "<leader>d", group = "Debug" },
                { "<leader>g", group = "Git" },
                { "<leader>h", group = "Harpoon" },
                { "<leader>l", group = "LSP", mode = "nv" },
                { "<leader>p", group = "Plugins" },
                { "<leader>s", group = "Search" },
                { "<leader>t", group = "Trouble" },
                { "<leader>n", group = "Neotest" },
                { "<leader>c", group = "Crates" },
                { "<leader>r", group = "Rust" },
                { "<leader>m", group = "Markdown" },
            }
        end,
    },
}
