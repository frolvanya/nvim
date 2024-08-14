local ok, lazy = pcall(require, "lazy")
if not ok then
    return ""
end

local M = {}

M.sections = {
    lualine_a = {
        {
            function()
                return "lazy 󰒲"
            end,
            separator = { left = "", right = "" },
        }
    },
    lualine_b = {
        {
            function()
                return "loaded: " .. lazy.stats().loaded .. "/" .. lazy.stats().count
            end,
            separator = { left = "", right = "" },
        }
    },
    lualine_c = {
        {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            separator = { left = "", right = "" },
        },
    },
}

M.filetypes = { "lazy" }

return M
