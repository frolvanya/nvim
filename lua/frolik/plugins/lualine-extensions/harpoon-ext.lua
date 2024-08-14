local M = {}

M.sections = {
    lualine_a = { { function() return "Harpoon" end, separator = { left = "", right = "" } } },
}

M.filetypes = { "harpoon" }

return M
