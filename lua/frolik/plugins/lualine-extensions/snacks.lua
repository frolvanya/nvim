local M = {}

M.sections = {
    lualine_a = {
        { function() return "Snacks" end, separator = { left = "", right = "" } },
    },
}

M.filetypes = {
    "snacks_picker_input",
    "snacks_picker_list",
    "snacks_picker_preview",
}

return M
