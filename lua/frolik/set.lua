vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

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

vim.opt.updatetime = 50
vim.opt.timeoutlen = 200

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true

vim.opt.scrolloff = 8
vim.opt.pumheight = 10

vim.opt.hlsearch = false
vim.opt.virtualedit = "block"

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
        "vim",
        "git",
        "help",
        "man",
        "floaterm",
        "lspinfo",
        "lsp-installer",
        "null-ls-info",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
        vim.opt_local.buflisted = false
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
        vim.bo.buflisted = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "GitGraph",
    callback = function()
        vim.bo.buflisted = true
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Create missing directories on file save",
    group = vim.api.nvim_create_augroup("_auto_create_dirs", { clear = true }),
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" or args.file:match "^oil:/" then
            return
        end

        local dir = vim.fn.fnamemodify(args.file, ":h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})
