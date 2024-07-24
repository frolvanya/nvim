return {
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require 'harpoon'

            harpoon:setup()

            vim.keymap.set('n', '<leader>ha', function()
                harpoon:list():add()
            end, { desc = 'Add' })
            vim.keymap.set('n', '<leader>he', function()
                harpoon.ui:toggle_quick_menu(harpoon:list(), { border = 'rounded', title_pos = 'center' })
            end, { desc = 'Toggle quick menu' })
            vim.keymap.set('n', '<leader>hh', function()
                harpoon:list():select(1)
            end, { desc = 'Navigate to 1' })
            vim.keymap.set('n', '<leader>hj', function()
                harpoon:list():select(2)
            end, { desc = 'Navigate to 2' })
            vim.keymap.set('n', '<leader>hk', function()
                harpoon:list():select(3)
            end, { desc = 'Navigate to 3' })
            vim.keymap.set('n', '<leader>hl', function()
                harpoon:list():select(4)
            end, { desc = 'Navigate to 4' })
            vim.keymap.set('n', '<leader>hp', function()
                harpoon:list():prev()
            end, { desc = 'Previous' })
            vim.keymap.set('n', '<leader>hn', function()
                harpoon:list():next()
            end, { desc = 'Next' })
        end,
    },
}
