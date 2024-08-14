local M = {}

local function fugitive_branch()
    local icons = require "frolik.icons"
    return icons.git.Branch .. " " .. vim.fn.FugitiveHead()
end

M.sections = {
    lualine_a = { { fugitive_branch, separator = { left = "", right = "" } } },
    lualine_z = { { "location", separator = { left = "", right = "" } } },
}

M.filetypes = { "git", "gitcommit", "fugitive" }

return M
