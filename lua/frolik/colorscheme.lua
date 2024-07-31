local colors = require "frolik.colors"

vim.cmd("autocmd ColorScheme * highlight NormalFloat guifg=" .. colors.nord5 .. " guibg=NONE")
vim.cmd("autocmd ColorScheme * highlight FloatBorder guifg=" .. colors.nord5 .. " guibg=NONE")
vim.cmd("autocmd ColorScheme * highlight LspInfoBorder guifg=" .. colors.nord5 .. " guibg=NONE")

vim.cmd "autocmd ColorScheme * highlight link LspInlayHint Comment"
vim.cmd "autocmd ColorScheme * highlight StatusLine ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE"
vim.cmd "autocmd ColorScheme * highlight TabLineFill ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE"

vim.cmd("autocmd ColorScheme * highlight LeapLabelPrimary guifg=" .. colors.nord1 .. " guibg=" .. colors.nord8)

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("frolik-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank { higroup = "Search", timeout = 100 }
    end,
})
