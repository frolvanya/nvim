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
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                json = { "jq" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            formatters = {
                jq = {
                    args = { ".", "--indent", "4" },
                },
            },
        },
    },
}
