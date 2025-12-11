local icons = require "frolik.icons"

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"

            dapui.setup {
                controls = { enabled = true },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.5 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                        },
                        size = 100,
                        position = "right",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 0.25,
                        position = "bottom",
                    },
                },
            }

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            local bp_icon = icons.diagnostics.Debug
            vim.fn.sign_define("DapBreakpoint", { text = bp_icon, texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
            vim.fn.sign_define("DapBreakpointCondition", { text = bp_icon, texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DapBreakpointRejected", { text = bp_icon, texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
            vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })

            local function continue()
                if vim.bo.filetype == "rust" and vim.fn.exists ":RustLsp" == 2 then
                    local ok = pcall(function()
                        vim.cmd.RustLsp "debug"
                    end)
                    if ok then
                        return
                    end
                end

                dap.continue()
            end

            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
            end, { desc = "Conditional Breakpoint" })
            vim.keymap.set("n", "<leader>dc", continue, { desc = "Continue" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<leader>dr", dap.run_last, { desc = "Restart Last" })
            vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        config = function()
            require("mason-nvim-dap").setup {
                ensure_installed = { "codelldb" },
                automatic_installation = false,
            }
        end,
    },
}
