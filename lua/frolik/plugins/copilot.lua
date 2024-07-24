local prompts = {
    -- Code related prompts
    Explain = 'Please explain how the following code works.',
    Review = 'Please review the following code and provide suggestions for improvement.',
    Tests = 'Please explain how the selected code works, then generate unit tests for it.',
    Refactor = 'Please refactor the following code to improve its clarity and readability.',
    FixCode = 'Please fix the following code to make it work as intended.',
    FixError = 'Please explain the error in the following text and provide a solution.',
    BetterNamings = 'Please provide better names for the following variables and functions.',
    Documentation = 'Please provide documentation for the following code.',
    SwaggerApiDocs = 'Please provide documentation for the following API using Swagger.',
    SwaggerJsDocs = 'Please write JSDoc for the following API using Swagger.',
    -- Text related prompts
    Summarize = 'Please summarize the following text.',
    Spelling = 'Please correct any grammar and spelling errors in the following text.',
    Wording = 'Please improve the grammar and wording of the following text.',
    Concise = 'Please rewrite the following text to make it more concise.',
}

vim.keymap.set(
    'n',
    '<leader>aa',
    "<cmd>lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').help_actions())<cr>",
    { desc = 'Help actions' }
)

vim.keymap.set(
    'n',
    '<leader>ap',
    "<cmd>lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions())<cr>",
    { desc = 'Prompt actions' }
)

vim.keymap.set('n', '<leader>am', '<cmd>CopilotChatCommit<cr>', { desc = 'Generate commit message for all changes' })
vim.keymap.set('n', '<leader>aM', '<cmd>CopilotChatCommitStaged<cr>', { desc = 'Generate commit message for staged changes' })
vim.keymap.set('n', '<leader>aq', function()
    local input = vim.fn.input 'Quick Chat: '
    if input ~= '' then
        vim.cmd('CopilotChatBuffer ' .. input)
    end
end, { desc = 'Quick chat' })
vim.keymap.set('n', '<leader>af', '<cmd>CopilotChatFixDiagnostic<cr>', { desc = 'Fix Diagnostic' })
vim.keymap.set('n', '<leader>al', '<cmd>CopilotChatReset<cr>', { desc = 'Clear buffer and chat history' })
vim.keymap.set('n', '<leader>at', '<cmd>CopilotChatToggle<cr>', { desc = 'Toggle' })

vim.keymap.set(
    'v',
    '<leader>ap',
    "<cmd>lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions())<cr>",
    { desc = 'Prompt actions' }
)
vim.keymap.set('v', '<leader>av', '<cmd>CopilotChatVisual<cr>', { desc = 'Open chat using selected code' })
vim.keymap.set('v', '<leader>ae', '<cmd>CopilotChatExplain<cr>', { desc = 'Explain code' })
vim.keymap.set('v', '<leader>aT', '<cmd>CopilotChatTests<cr>', { desc = 'Generate tests' })
vim.keymap.set('v', '<leader>ar', '<cmd>CopilotChatReview<cr>', { desc = 'Review code' })
vim.keymap.set('v', '<leader>aR', '<cmd>CopilotChatRefactor<cr>', { desc = 'Refactor code' })
vim.keymap.set('v', '<leader>ao', '<cmd>CopilotChatOptimize<cr>', { desc = 'Optimize code' })
vim.keymap.set('v', '<leader>an', '<cmd>CopilotChatBetterNamings<cr>', { desc = 'Better Naming' })
vim.keymap.set('v', '<leader>ad', '<cmd>CopilotChatDocs<cr>', { desc = 'Generate Docs' })

return {
    {
        'zbirenbaum/copilot.lua',
        config = function()
            require('copilot').setup {
                suggestion = { enabled = false },
                panel = { enabled = false },
            }
        end,
    },
    {
        'zbirenbaum/copilot-cmp',
        after = { 'copilot.lua' },
        config = function()
            require('copilot_cmp').setup()
        end,
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = 'canary',
        dependencies = {
            { 'zbirenbaum/copilot.lua' },
            { 'nvim-lua/plenary.nvim' },
        },
        opts = {
            question_header = '## User ',
            answer_header = '## Copilot ',
            error_header = '## Error ',
            separator = ' ', -- Separator to use in chat
            prompts = prompts,
            auto_follow_cursor = false, -- Don't follow the cursor after getting response
            show_help = false, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
            window = {
                border = 'rounded',
                layout = 'float',
                width = 0.91,
                height = 0.8,
                title = '',
            },
        },
        config = function(_, opts)
            local chat = require 'CopilotChat'
            local select = require 'CopilotChat.select'

            chat.setup(opts)

            vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
                chat.ask(args.args, { selection = select.visual })
            end, { nargs = '*', range = true })

            -- Restore CopilotChatBuffer
            vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
                chat.ask(args.args, { selection = select.buffer })
            end, { nargs = '*', range = true })

            -- Custom buffer for CopilotChat
            vim.api.nvim_create_autocmd('BufEnter', {
                pattern = 'copilot-*',
                callback = function()
                    vim.opt_local.relativenumber = true
                    vim.opt_local.number = true

                    local ft = vim.bo.filetype
                    if ft == 'copilot-chat' then
                        vim.bo.filetype = 'chat'
                    end
                end,
            })
        end,
        event = 'VeryLazy',
    },
}
