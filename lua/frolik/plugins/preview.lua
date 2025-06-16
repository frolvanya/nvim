return {
    {
        "OXY2DEV/helpview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
