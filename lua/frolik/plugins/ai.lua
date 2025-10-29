vim.keymap.set("n", "<leader>at", "<cmd>CodexToggle<cr>", { desc = "Toggle" })

return {
    {
        "zbirenbaum/copilot.lua",
        config = function()
            require("copilot").setup {
                suggestion = { enabled = false },
                panel = { enabled = false },
            }
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    {
        "johnseth97/codex.nvim",
        opts = {
            border = "rounded",
        },
    },
}
