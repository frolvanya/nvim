local M = {}

M.sections = {
    lualine_a = { { function() return "Telescope" end, separator = { left = "", right = "" } } },
}

M.filetypes = { "TelescopePrompt" }

return M
