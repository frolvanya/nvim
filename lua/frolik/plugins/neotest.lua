return {
    {
        "nvim-neotest/neotest",
        event = "BufReadPost",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            vim.keymap.set("n", "<leader>nr", "<cmd>Neotest run<cr>", { desc = "Run Test" })
            vim.keymap.set("n", "<leader>nR", "<cmd>Neotest run file<cr>", { desc = "Run All Tests" })
            vim.keymap.set("n", "<leader>ns", "<cmd>Neotest summary<cr>", { desc = "Summary" })
            vim.keymap.set("n", "<leader>nS", "<cmd>Neotest stop<cr>", { desc = "Stop" })
            vim.keymap.set("n", "<leader>no", "<cmd>Neotest output<cr>", { desc = "Output" })
            vim.keymap.set("n", "<leader>nO", "<cmd>Neotest output-panel<cr>", { desc = "Output In Panel" })
            require("neotest").setup {
                adapters = {
                    require "rustaceanvim.neotest",
                },
            }
        end,
    },
}
