local M = {}

M.sections = {
    lualine_a = { {
        function()
            return "Mason"
        end,
        separator = { left = "", right = "" },
    } },
}

M.filetypes = { "mason" }

return M
