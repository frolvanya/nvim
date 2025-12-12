return {
    {
        "goolord/alpha-nvim",
        config = function()
            local status_ok, alpha = pcall(require, "alpha")
            if not status_ok then
                return
            end

            local icons = require "frolik.icons"
            local dashboard = require "alpha.themes.dashboard"

            dashboard.section.header.val = {
                [[                                                    ]],
                [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
                [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
                [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
                [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
                [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
                [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
                [[                                                    ]],
            }

            dashboard.section.buttons.val = {
                dashboard.button("f", icons.ui.FindFile .. " Find file", "<cmd>lua require('snacks').picker.files()<cr>"),
                dashboard.button("n", icons.ui.NewFile .. " New file", "<cmd>enew<cr>"),
                dashboard.button("r", icons.ui.History .. " Recent files", "<cmd>lua require('snacks').picker.recent()<cr>"),
                dashboard.button("t", icons.ui.FindText .. " Find text", "<cmd>lua require('snacks').picker.grep()<cr>"),
                dashboard.button("c", icons.ui.Gear .. " Configuration", "<cmd>edit ~/.config/nvim/init.lua<cr>"),
                dashboard.button("q", icons.ui.Close .. " Quit", "<cmd>q<cr>"),
            }

            dashboard.section.footer.val = {
                "frolik",
            }

            dashboard.config.layout = {
                { type = "padding", val = 10 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            }

            alpha.setup(dashboard.opts)
        end,
    },
}
