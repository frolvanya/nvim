local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand "<cword>")
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand "<cword>")
    elseif vim.tbl_contains({ "rust" }, filetype) then
        vim.cmd "RustLsp hover actions"
    elseif vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end

-- Patch codelens to render as eol instead of virt_lines (Neovim 0.12 hardcodes virt_lines).
-- Finds the internal Provider class via debug.getupvalue and wraps its on_win method.
local codelens_patched = false
local function patch_codelens_eol()
    if codelens_patched then
        return
    end

    local function find_provider()
        for _, fn in pairs(vim.lsp.codelens) do
            if type(fn) ~= "function" then
                goto next
            end
            local i = 1
            while true do
                local name, value = debug.getupvalue(fn, i)
                if not name then
                    break
                end
                if type(value) == "table" and rawget(value, "on_win") then
                    return value
                end
                if type(value) == "function" then
                    local j = 1
                    while true do
                        local n2, v2 = debug.getupvalue(value, j)
                        if not n2 then
                            break
                        end
                        if type(v2) == "table" and rawget(v2, "on_win") then
                            return v2
                        end
                        j = j + 1
                    end
                end
                i = i + 1
            end
            ::next::
        end
    end

    local Provider = find_provider()
    if not Provider then
        return
    end
    codelens_patched = true

    -- Replace on_win: faithful copy of the original, only virt_lines changed to virt_text eol
    function Provider:on_win(toprow, botrow)
        for row = toprow, botrow do
            if self.row_version[row] ~= self.version then
                for client_id, state in pairs(self.client_state) do
                    local bufnr = self.bufnr
                    local namespace = state.namespace

                    vim.api.nvim_buf_clear_namespace(bufnr, namespace, row, row + 1)

                    local lenses = state.row_lenses[row]
                    if lenses then
                        table.sort(lenses, function(a, b)
                            return a.range.start.character < b.range.start.character
                        end)

                        local client = vim.lsp.get_client_by_id(client_id)
                        local virt_text = {}

                        for _, lens in ipairs(lenses) do
                            if not lens.command then
                                if client then
                                    self:resolve(client, lens)
                                end
                            else
                                vim.list_extend(virt_text, {
                                    { lens.command.title, "LspCodeLens" },
                                    { " | ", "LspCodeLensSeparator" },
                                })
                            end
                        end
                        -- Remove trailing separator
                        table.remove(virt_text)

                        if #virt_text > 0 then
                            vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
                                virt_text = virt_text,
                                virt_text_pos = "eol",
                                hl_mode = "combine",
                            })
                        end
                    end
                    self.row_version[row] = self.version
                end
            end
        end

        if botrow == vim.api.nvim_buf_line_count(self.bufnr) - 1 then
            for _, state in pairs(self.client_state) do
                vim.api.nvim_buf_clear_namespace(self.bufnr, state.namespace, botrow + 1, -1)
            end
        end
    end
end

local function setup_codelens(client, bufnr)
    local ok, supported = pcall(function()
        return client:supports_method "textDocument/codeLens"
    end)
    if not ok or not supported then
        return
    end
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
    patch_codelens_eol()
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                config = function()
                    require("mason").setup { ui = { border = "rounded", backdrop = 100 } }
                end,
            },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            {
                "j-hui/fidget.nvim",
                config = function()
                    require("fidget").setup {
                        progress = {
                            display = {
                                render_limit = 20,
                                progress_icon = { pattern = "circle" },
                            },
                        },
                        notification = {
                            poll_rate = 20,
                        },
                    }
                end,
            },
            { "RRethy/vim-illuminate" },
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "luvit-meta/library", words = { "vim%.uv" } },
                    },
                },
            },
            { "Bilal2453/luvit-meta", lazy = true },

            {
                "kevinhwang91/nvim-bqf",
                ft = "qf",
                config = function()
                    ---@diagnostic disable-next-line: missing-fields
                    require("bqf").setup {
                        ---@diagnostic disable-next-line: missing-fields
                        preview = {
                            winblend = 0,
                            show_scroll_bar = false,
                        },
                    }
                end,
            },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("frolik-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
                    end

                    pcall(vim.keymap.del, "n", "gra")
                    pcall(vim.keymap.del, "n", "gri")
                    pcall(vim.keymap.del, "n", "grn")
                    pcall(vim.keymap.del, "n", "grr")
                    pcall(vim.keymap.del, "n", "grt")
                    pcall(vim.keymap.del, "n", "grx")
                    map("gl", function()
                        local float = vim.diagnostic.config().float

                        if float then
                            local config = type(float) == "table" and float or {}
                            config.scope = "line"

                            vim.diagnostic.open_float(config)
                        end
                    end, "Show line diagnostics")
                    map("gd", function()
                        require("snacks").picker.lsp_definitions()
                    end, "Goto Definition")
                    map("gr", function()
                        require("snacks").picker.lsp_references()
                    end, "Goto References")
                    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
                    map("gI", function()
                        require("snacks").picker.lsp_implementations()
                    end, "Goto Implementation")
                    map("K", show_documentation, "Show hover")

                    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code Actions" })
                    map("<leader>ll", vim.lsp.codelens.run, "CodeLens Actions")
                    map("<leader>lj", function()
                        vim.diagnostic.jump { count = 1, float = true }
                    end, "Next Diagnostic")
                    map("<leader>lk", function()
                        vim.diagnostic.jump { count = -1, float = true }
                    end, "Previous Diagnostic")
                    map("<leader>lq", vim.diagnostic.setloclist, "Quickfix")
                    map("<leader>lr", vim.lsp.buf.rename, "Rename")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>lh", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, "Toggle Inlay Hints")
                    end

                    setup_codelens(client, event.buf)
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--all-scopes-completion",
                        "--background-index",
                        "--pch-storage=disk",
                        "--log=info",
                        "--completion-style=detailed",
                        "--enable-config",
                        "--clang-tidy",
                        "--offset-encoding=utf-16",
                    },
                    filetypes = { "c", "cpp" },
                },
                solidity_ls = {
                    init_options = vim.fn.stdpath "cache",
                    settings = {
                        solidity = {
                            defaultCompiler = "embedded",
                            compileUsingRemoteVersion = "",
                            compileUsingLocalVersion = "",
                        },
                    },
                },
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
            })
            require("mason-tool-installer").setup { ensure_installed = ensure_installed }

            require("mason-lspconfig").setup {
                handlers = {
                    function(server_name)
                        if server_name == "tsserver" then
                            server_name = "ts_ls"
                        end
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            }

            -- require("lspconfig").protols.setup {}
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "proto",
                callback = function(ev)
                    vim.lsp.start {
                        name = "proto-lsp",
                        cmd = { "/Users/frolik/Documents/Scripts/rust-scripts/proto-lsp/target/debug/proto-lsp" },

                        root_dir = vim.fs.root(ev.buf, { "Cargo.toml" }),
                    }
                end,
            })
        end,
    },
}
