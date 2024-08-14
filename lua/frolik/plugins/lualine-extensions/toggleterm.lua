local M = {}

M.sections = {
    lualine_a = { { function() return "ToggleTerm" end, separator = { left = "", right = "" } } },
}

M.filetypes = { "toggleterm" }

return M
