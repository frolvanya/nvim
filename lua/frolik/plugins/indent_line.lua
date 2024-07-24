local icons = require 'frolik.icons'

return {
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            enabled = true,
            debounce = 200,
            viewport_buffer = {
                min = 30,
                max = 500,
            },
            indent = {
                char = '▏',
                tab_char = nil,
                highlight = 'IblIndent',
                smart_indent_cap = true,
                priority = 1,
            },
            whitespace = {
                highlight = 'IblWhitespace',
                remove_blankline_trail = true,
            },
            exclude = {
                buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
                filetypes = {
                    'NvimTree',
                    'Trouble',
                    'dashboard',
                    'help',
                    'lazy',
                    'neogitstatus',
                    'startify',
                    'text',
                },
            },
            scope = {
                enabled = true,
                char = '▏',
                show_start = true,
                show_end = true,
                show_exact_scope = false,
                injected_languages = true,
                highlight = 'IblScope',
                priority = 1024,
                include = {
                    node_type = {},
                },
                exclude = {
                    language = {},
                    node_type = {
                        ['*'] = {
                            'source_file',
                            'program',
                        },
                        lua = {
                            'chunk',
                        },
                        python = {
                            'module',
                        },
                    },
                },
            },
        },
    },
}
