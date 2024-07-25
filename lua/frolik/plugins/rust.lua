return {
    {
        'mrcjkb/rustaceanvim',
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    float_win_config = {
                        border = 'rounded',
                    },
                },
            }
        end,
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup {
                null_ls = {
                    enabled = true,
                },
                popup = {
                    border = 'rounded',
                },
            }
        end,
    },
}
