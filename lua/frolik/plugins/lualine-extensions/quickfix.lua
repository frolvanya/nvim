local function is_loclist()
    return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

local function label()
    return is_loclist() and "Location List" or "Quickfix List"
end

local function title()
    if is_loclist() then
        return vim.fn.getloclist(0, { title = 0 }).title
    end

    return vim.fn.getqflist({ title = 0 }).title
end

local M = {}

function M.init()
    vim.g.qf_disable_statusline = true
end

M.sections = {
    lualine_a = { { label, separator = { left = "", right = "" } } },
    lualine_b = { { title, separator = { left = "", right = "" } } },
    lualine_z = { { "location", separator = { left = "", right = "" } } }
}

M.filetypes = { "qf" }

return M
