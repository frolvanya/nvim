local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
        vim.cmd('h ' .. vim.fn.expand '<cword>')
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man ' .. vim.fn.expand '<cword>')
    elseif vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'williamboman/mason.nvim',
                config = function()
                    require('mason').setup { ui = { border = 'rounded' } }
                end,
            },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            { 'j-hui/fidget.nvim', opts = {} },
            { 'RRethy/vim-illuminate' },

            {
                'folke/lazydev.nvim',
                ft = 'lua',
                opts = {
                    library = {
                        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                    },
                },
            },
            { 'Bilal2453/luvit-meta', lazy = true },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('frolik-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
                    end

                    map('gl', function()
                        local float = vim.diagnostic.config().float

                        if float then
                            local config = type(float) == 'table' and float or {}
                            config.scope = 'line'

                            vim.diagnostic.open_float(config)
                        end
                    end, 'Show line diagnostics')
                    map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
                    map('gr', require('telescope.builtin').lsp_references, 'Goto References')
                    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
                    map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
                    map('K', show_documentation, 'Show hover')

                    map('<leader>la', vim.lsp.buf.code_action, 'Code Actions')
                    map('<leader>ll', vim.lsp.codelens.run, 'CodeLens Actions')
                    map('<leader>lj', vim.diagnostic.goto_next, 'Next Diagnostic')
                    map('<leader>lk', vim.diagnostic.goto_prev, 'Next Diagnostic')
                    map('<leader>li', '<cmd>LspInfo<cr>', 'Info')
                    map('<leader>lI', '<cmd>Mason<cr>', 'Mason Info')
                    map('<leader>lr', vim.lsp.buf.rename, 'Rename')
                    map('<leader>lq', vim.diagnostic.setloclist, 'Quickfix')

                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    --     local highlight_augroup = vim.api.nvim_create_augroup('frolik-lsp-highlight', { clear = false })
                    --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd('LspDetach', {
                    --         group = vim.api.nvim_create_augroup('frolik-lsp-detach', { clear = true }),
                    --         callback = function(event2)
                    --             vim.lsp.buf.clear_references()
                    --             vim.api.nvim_clear_autocmds { group = 'frolik-lsp-highlight', buffer = event2.buf }
                    --         end,
                    --     })
                    -- end

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>lh', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, 'Toggle Inlay Hints')
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
                        },
                    },
                },
            }

            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },
}
