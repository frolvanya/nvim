return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",

                build = "make",

                cond = function()
                    return vim.fn.executable "make" == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            {
                "nvim-tree/nvim-web-devicons",
                enabled = vim.g.have_nerd_font,
            },
        },
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            }

            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            local builtin = require "telescope.builtin"
            vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "Git Branches" })
            vim.keymap.set("n", "<leader>sB", builtin.buffers, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "Colorscheme" })
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
            vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Highlight Groups" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
            vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Git Files" })
            vim.keymap.set("n", "<leader>st", builtin.live_grep, { desc = "Text" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })

            vim.keymap.set("n", "<leader>le", builtin.quickfix, { desc = "Telescope Quickfix" })
            vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Document Symbols" })
            vim.keymap.set("n", "<leader>lS", builtin.lsp_workspace_symbols, { desc = "Workspace Symbols" })

            vim.keymap.set("n", "<leader>s/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                    previewer = false,
                })
            end, { desc = "FZF in current buffer" })
        end,
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        keys = {
            {
                "<leader>su",
                "<cmd>Telescope undo<cr>",
                desc = "undo history",
            },
        },
        opts = {
            extensions = {
                undo = {},
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension "undo"
        end,
    },
}
