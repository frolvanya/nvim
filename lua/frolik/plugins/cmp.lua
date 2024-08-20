local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function jumpable(dir)
    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if not luasnip_ok then
        return false
    end

    local win_get_cursor = vim.api.nvim_win_get_cursor
    local get_current_buf = vim.api.nvim_get_current_buf

    ---sets the current buffer's luasnip to the one nearest the cursor
    ---@return boolean true if a node is found, false otherwise
    local function seek_luasnip_cursor_node()
        -- TODO(kylo252): upstream this
        -- for outdated versions of luasnip
        if not luasnip.session.current_nodes then
            return false
        end

        local node = luasnip.session.current_nodes[get_current_buf()]
        if not node then
            return false
        end

        local snippet = node.parent.snippet
        local exit_node = snippet.insert_nodes[0]

        local pos = win_get_cursor(0)
        pos[1] = pos[1] - 1

        -- exit early if we're past the exit node
        if exit_node then
            local exit_pos_end = exit_node.mark:pos_end()
            if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
                snippet:remove_from_jumplist()
                luasnip.session.current_nodes[get_current_buf()] = nil

                return false
            end
        end

        node = snippet.inner_first:jump_into(1, true)
        while node ~= nil and node.next ~= nil and node ~= snippet do
            local n_next = node.next
            local next_pos = n_next and n_next.mark:pos_begin()
            local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1]) or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

            -- Past unmarked exit node, exit early
            if n_next == nil or n_next == snippet.next then
                snippet:remove_from_jumplist()
                luasnip.session.current_nodes[get_current_buf()] = nil

                return false
            end

            if candidate then
                luasnip.session.current_nodes[get_current_buf()] = node
                return true
            end

            local ok
            ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
            if not ok then
                snippet:remove_from_jumplist()
                luasnip.session.current_nodes[get_current_buf()] = nil

                return false
            end
        end

        -- No candidate, but have an exit node
        if exit_node then
            -- to jump to the exit node, seek to snippet
            luasnip.session.current_nodes[get_current_buf()] = snippet
            return true
        end

        -- No exit node, exit from snippet
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil
        return false
    end

    if dir == -1 then
        return luasnip.in_snippet() and luasnip.jumpable(-1)
    else
        return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
    end
end

return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "onsails/lspkind.nvim",
        },
        config = function()
            local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
            if not status_cmp_ok then
                return
            end

            local ConfirmBehavior = cmp_types.ConfirmBehavior
            local SelectBehavior = cmp_types.SelectBehavior

            local cmp = require "cmp"
            local cmp_window = require "cmp.config.window"
            local cmp_mapping = require "cmp.config.mapping"

            local luasnip = require "luasnip"
            luasnip.config.setup {}

            local lspkind = require "lspkind"

            local icons = require "frolik.icons"

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp_window.bordered { scrollbar = false },
                    documentation = cmp_window.bordered(),
                },
                confirm_opts = {
                    behavior = ConfirmBehavior.Replace,
                    select = false,
                },
                completion = {
                    keyword_length = 1,
                },
                experimental = {
                    ghost_text = true,
                },
                preselect = "None",
                mapping = cmp_mapping.preset.insert {
                    ["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
                    ["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
                    ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item { behavior = SelectBehavior.Select }, { "i" }),
                    ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item { behavior = SelectBehavior.Select }, { "i" }),
                    ["<C-d>"] = cmp_mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp_mapping.scroll_docs(4),
                    ["<C-y>"] = cmp_mapping {
                        i = cmp_mapping.confirm { behavior = ConfirmBehavior.Replace, select = false },
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.confirm { behavior = ConfirmBehavior.Replace, select = false }
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<Tab>"] = cmp_mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif jumpable(1) then
                            luasnip.jump(1)
                        elseif has_words_before() then
                            -- cmp.complete()
                            fallback()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp_mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-Space>"] = cmp_mapping.complete(),
                    ["<C-e>"] = cmp_mapping.abort(),
                    ["<CR>"] = cmp_mapping(function(fallback)
                        if cmp.visible() then
                            local confirm_opts = vim.deepcopy {
                                behavior = ConfirmBehavior.Replace,
                                select = false,
                            }
                            local is_insert_mode = function()
                                return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
                            end
                            if is_insert_mode() then
                                confirm_opts.behavior = ConfirmBehavior.Insert
                            end
                            local entry = cmp.get_selected_entry()
                            local is_copilot = entry and entry.source.name == "copilot"
                            if is_copilot then
                                confirm_opts.behavior = ConfirmBehavior.Replace
                                confirm_opts.select = true
                            end
                            if cmp.confirm(confirm_opts) then
                                return
                            end
                        end
                        fallback()
                    end),
                },
                sources = {
                    {
                        name = "copilot",
                        -- keyword_length = 0,
                        max_item_count = 3,
                        trigger_characters = {
                            ".",
                            ":",
                            "(",
                            "'",
                            '"',
                            "[",
                            ",",
                            "#",
                            "*",
                            "@",
                            "|",
                            "=",
                            "-",
                            "{",
                            "/",
                            "\\",
                            "+",
                            "?",
                            " ",
                            -- "\t",
                            -- "\n",
                        },
                    },
                    {
                        name = "nvim_lsp",
                        entry_filter = function(entry, ctx)
                            local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
                            if kind == "Snippet" and ctx.prev_context.filetype == "java" then
                                return false
                            end
                            return true
                        end,
                    },

                    {
                        name = "lazydev",
                        group_index = 0,
                    },

                    { name = "path" },
                    { name = "luasnip" },
                    { name = "cmp_tabnine" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "calc" },
                    { name = "emoji" },
                    { name = "treesitter" },
                    { name = "crates" },
                    { name = "tmux" },
                },
                ---@diagnostic disable-next-line: missing-fields
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find "^_+"
                            local _, entry2_under = entry2.completion_item.label:find "^_+"
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                formatting = {
                    fields = { "kind", "abbr" },
                    expandable_indicator = false,
                    format = lspkind.cmp_format {
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = icons.ui.Ellipsis,
                        symbol_map = { Copilot = icons.git.Octoface, Snippet = icons.kind.Snippet, Version = icons.kind.Version },
                        ---@diagnostic disable-next-line: unused-local
                        before = function(entry, vim_item)
                            vim_item.menu = nil
                            return vim_item
                        end,
                    },
                },
            }

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },

    { "folke/todo-comments.nvim", event = "VimEnter", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" },
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.install").prefer_git = true
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
