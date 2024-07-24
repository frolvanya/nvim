vim.keymap.set('n', '<leader>tt', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Toggle' })
vim.keymap.set('n', '<leader>ts', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols' })

return {
    {
        'folke/trouble.nvim',
        opts = {},
        cmd = 'Trouble',
    },
}
