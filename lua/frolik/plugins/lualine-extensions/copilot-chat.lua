local M = {}

M.sections = {
    lualine_a = { { function() return "Copilot Chat" end, separator = { left = "", right = "" } } },
}

M.filetypes = { "chat" }

return M
