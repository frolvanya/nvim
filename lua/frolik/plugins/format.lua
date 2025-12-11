return {
    "tpope/vim-sleuth",

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format { async = true, lsp_fallback = true }
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = function()
            local util = require "conform.util"

            return {
                notify_on_error = false,
                format_on_save = function(bufnr)
                    local disable_filetypes = { c = true, cpp = true }
                    return {
                        timeout_ms = 500,
                        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                    }
                end,
                formatters = {
                    prettier_solidity = {
                        command = util.from_node_modules "prettier",
                        args = { "--plugin=prettier-plugin-solidity", "--stdin-filepath", "$FILENAME" },
                        stdin = true,
                        cwd = util.root_file { "package.json" },
                    },
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black" },
                    json = { "jq" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    solidity = { "prettier_solidity" },
                },
            }
        end,
    },
}
