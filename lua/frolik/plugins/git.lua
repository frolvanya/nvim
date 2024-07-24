local icons = require 'frolik.icons'

vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'GitSignsAddLn', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', { link = 'DiffChange' })

vim.keymap.set('n', '<leader>ga', '<cmd>G add .<cr>', { desc = 'Add' })
vim.keymap.set('n', '<leader>gc', '<cmd>G commit --quiet<cr>', { desc = 'Commit' })
vim.keymap.set('n', '<leader>gp', '<cmd>G push<cr>', { desc = 'Push' })
vim.keymap.set('n', '<leader>gP', '<cmd>G pull<cr>', { desc = 'Pull' })
vim.keymap.set('n', '<leader>gs', '<cmd>G status<cr>', { desc = 'Status' })
vim.keymap.set('n', '<leader>gd', '<cmd>G diff<cr>', { desc = 'Diff' })
vim.keymap.set('n', '<leader>gh', '<cmd>diffget //2<cr>', { desc = 'Get changes from left' })
vim.keymap.set('n', '<leader>gl', '<cmd>diffget //3<cr>', { desc = 'Get changes from right' })
vim.keymap.set('n', '<leader>gD', '<cmd>Gvdiffsplit!<cr>', { desc = 'Diff Merge Conflict' })
vim.keymap.set('n', '<leader>gL', '<cmd>G log -p<cr>', { desc = 'Log' })
vim.keymap.set('n', '<leader>gb', '<cmd>lua require "gitsigns".blame_line()<cr>', { desc = 'Blame' })

return {
    { 'tpope/vim-fugitive' },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = {
                    text = icons.ui.BoldLineLeft,
                },
                change = {
                    text = icons.ui.BoldLineLeft,
                },
                delete = {
                    text = icons.ui.Triangle,
                },
                topdelete = {
                    text = icons.ui.Triangle,
                },
                changedelete = {
                    text = icons.ui.BoldLineLeft,
                },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol',
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            status_formatter = nil,
            update_debounce = 200,
            max_file_length = 40000,
            preview_config = {
                border = 'rounded',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1,
            },
        },
    },
}
