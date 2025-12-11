return {
    {
        "mrcjkb/rustaceanvim",
        lazy = false,
        config = function()
            local function get_codelldb_adapter()
                local ok, mason_registry = pcall(require, "mason-registry")
                if not ok then
                    return
                end

                local ok_pkg, codelldb = pcall(mason_registry.get_package, "codelldb")
                if not ok_pkg or not codelldb or not (codelldb.is_installed and codelldb:is_installed()) then
                    return
                end

                local install_path
                ---@diagnostic disable-next-line: undefined-field
                if codelldb.get_install_path then
                    ---@diagnostic disable-next-line: undefined-field
                    install_path = codelldb:get_install_path()
                else
                    local fallback = vim.fn.stdpath "data" .. "/mason/packages/codelldb"
                    if vim.fn.isdirectory(fallback) == 1 then
                        install_path = fallback
                    end
                end

                if not install_path then
                    return
                end

                local extension_path = install_path .. "/extension/"
                local codelldb_path = extension_path .. "adapter/codelldb"
                local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

                return require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
            end

            local rustaceanvim = {
                tools = {
                    float_win_config = {
                        border = "rounded",
                    },
                },
                server = {
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                features = "all",
                            },
                        },
                    },
                },
            }

            local codelldb_adapter = get_codelldb_adapter()
            if codelldb_adapter then
                rustaceanvim.dap = { adapter = codelldb_adapter }
            end

            vim.g.rustaceanvim = rustaceanvim
        end,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup {
                null_ls = {
                    enabled = true,
                },
                completion = {
                    cmp = {
                        enabled = true,
                    },
                },
                popup = {
                    border = "rounded",
                },
            }
        end,
    },
}
