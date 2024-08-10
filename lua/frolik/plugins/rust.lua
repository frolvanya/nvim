return {
    {
        "mrcjkb/rustaceanvim",
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    float_win_config = {
                        border = "rounded",
                    },
                },
                server = {
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                features = "all",
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup {
                null_ls = {
                    enabled = true,
                },
                popup = {
                    border = "rounded",
                },
            }
        end,
    },
}
