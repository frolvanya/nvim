local icons = require "frolik.icons"

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<leader>sb",
            function()
                require("snacks").picker.git_branches()
            end,
            desc = "Git Branches",
        },
        {
            "<leader>sB",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>sc",
            function()
                require("snacks").picker.colorschemes()
            end,
            desc = "Colorschemes",
        },
        {
            "<leader>sh",
            function()
                require("snacks").picker.help()
            end,
            desc = "Help",
        },
        {
            "<leader>sH",
            function()
                require("snacks").picker.highlights()
            end,
            desc = "Highlight Groups",
        },
        {
            "<leader>sk",
            function()
                require("snacks").picker.keymaps()
            end,
            desc = "Keymaps",
        },
        {
            "<leader>sf",
            function()
                require("snacks").picker.files()
            end,
            desc = "Files",
        },
        {
            "<leader>sg",
            function()
                require("snacks").picker.git_files()
            end,
            desc = "Git Files",
        },
        {
            "<leader>st",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Text",
        },
        {
            "<leader>sd",
            function()
                require("snacks").picker.diagnostics()
            end,
            desc = "Diagnostics",
        },
        {
            "<leader>le",
            function()
                require("snacks").picker.qflist()
            end,
            desc = "Quickfix",
        },
        {
            "<leader>ls",
            function()
                require("snacks").picker.lsp_symbols()
            end,
            desc = "Document Symbols",
        },
        {
            "<leader>lS",
            function()
                require("snacks").picker.lsp_workspace_symbols()
            end,
            desc = "Workspace Symbols",
        },
        {
            "<leader>s/",
            function()
                require("snacks").picker.lines()
            end,
            desc = "Buffer Lines",
        },
        {
            "<leader>su",
            function()
                require("snacks").picker.undo()
            end,
            desc = "Undo History",
        },
        {
            "<leader>gi",
            function()
                require("snacks").picker.gh_issue()
            end,
            desc = "GitHub Issues (open)",
        },
        {
            "<leader>gI",
            function()
                require("snacks").picker.gh_issue { state = "all" }
            end,
            desc = "GitHub Issues (all)",
        },
        {
            "<leader>gp",
            function()
                require("snacks").picker.gh_pr()
            end,
            desc = "GitHub PRs (open)",
        },
        {
            "<leader>gP",
            function()
                require("snacks").picker.gh_pr { state = "all" }
            end,
            desc = "GitHub PRs (all)",
        },
    },
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        picker = {
            enabled = true,
            layout = {
                layout = {
                    backdrop = false,
                },
            },
            sources = {
                files = {
                    hidden = true,
                },
            },
        },
        gh = { enabled = true },
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
