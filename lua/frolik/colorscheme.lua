local colors = require "frolik.colors"

vim.cmd("autocmd ColorScheme * highlight NormalFloat guifg=" .. colors.nord5 .. " guibg=NONE")
vim.cmd("autocmd ColorScheme * highlight FloatBorder guifg=" .. colors.nord5 .. " guibg=NONE")
vim.cmd("autocmd ColorScheme * highlight LspInfoBorder guifg=" .. colors.nord5 .. " guibg=NONE")
vim.cmd("autocmd ColorScheme * highlight IncSearch guifg=" .. colors.nord1 .. " guibg=" .. colors.nord8)
vim.cmd("autocmd ColorScheme * highlight Search guifg=" .. colors.nord8 .. " guibg=NONE")
vim.cmd("autocmd ColorScheme * highlight FlashLabel guifg=" .. colors.nord1 .. " guibg=" .. colors.nord8)
vim.cmd("autocmd ColorScheme * highlight SnacksPickerMatch guifg=" .. colors.nord8 .. " guibg=NONE gui=bold")
vim.cmd("autocmd ColorScheme * highlight SnacksPickerDir guifg=" .. colors.nord5 .. " guibg=NONE")
vim.cmd "autocmd ColorScheme * highlight link SnacksPickerCol SnacksPickerRow"

vim.cmd "autocmd ColorScheme * highlight link LspInlayHint Comment"
vim.cmd "autocmd ColorScheme * highlight StatusLine ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE"
vim.cmd "autocmd ColorScheme * highlight TabLineFill ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE"

vim.cmd("autocmd ColorScheme * highlight IndentScope guifg=" .. colors.nord8 .. " guibg=NONE")

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("frolik-highlight-yank", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "YankFlash", { fg = colors.nord1, bg = colors.nord8 })
        vim.highlight.on_yank { higroup = "YankFlash", timeout = 100 }
    end,
})
