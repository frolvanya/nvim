local icons = require 'frolik.icons'

return {
    {
        'lukas-reineke/indent-blankline.nvim',
        commit = '9637670',
        opts = {
            buftype_exclude = { 'terminal', 'nofile' },
            filetype_exclude = {
                'help',
                'startify',
                'dashboard',
                'lazy',
                'neogitstatus',
                'Trouble',
                'text',
            },
            char = icons.ui.LineLeft,
            context_char = icons.ui.LineLeft,
            show_trailing_blankline_indent = false,
            show_first_indent_level = true,
            use_treesitter = true,
            show_current_context = true,
        },
    },
}
