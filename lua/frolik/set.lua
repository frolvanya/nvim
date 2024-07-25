vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false

vim.opt.clipboard = "unnamedplus"

vim.opt.wrap = false

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250

vim.opt.timeoutlen = 100

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true

vim.opt.scrolloff = 8
vim.opt.pumheight = 10

vim.opt.hlsearch = false

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.txt", "*.tex", "*.md" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})


vim.api.nvim_create_autocmd("FileType", {
    desc = "Smart close buffers",
    group = vim.api.nvim_create_augroup("_buffer_mappings", { clear = true }),
    pattern = {
        "qf",
        "help",
        "man",
        "floaterm",
        "lspinfo",
        "lsp-installer",
        "null-ls-info",
    },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
        vim.opt_local.buflisted = false
    end,
})
