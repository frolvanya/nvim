local M = {}

M.sections = {
    lualine_a = { {
        function()
            return "Alpha"
        end,
        separator = { left = "", right = "" },
    } },
}

M.filetypes = { "alpha" }

return M
