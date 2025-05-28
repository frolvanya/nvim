local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<leader>pc", "<cmd>Lazy clean<cr>", { desc = "Clean" })
vim.keymap.set("n", "<leader>pd", "<cmd>Lazy debug<cr>", { desc = "Debug" })
vim.keymap.set("n", "<leader>pi", "<cmd>Lazy install<cr>", { desc = "Install" })
vim.keymap.set("n", "<leader>pl", "<cmd>Lazy log<cr>", { desc = "Log" })
vim.keymap.set("n", "<leader>pp", "<cmd>Lazy profile<cr>", { desc = "Profile" })
vim.keymap.set("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync" })
vim.keymap.set("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Update" })

require("lazy").setup({
    require "frolik.plugins.colorscheme",

    require "frolik.plugins.alpha",

    require "frolik.plugins.oil",
    require "frolik.plugins.which-key",

    require "frolik.plugins.lsp",
    require "frolik.plugins.cmp",
    require "frolik.plugins.rust",
    require "frolik.plugins.copilot",
    require "frolik.plugins.neotest",

    require "frolik.plugins.lint",
    require "frolik.plugins.format",

    require "frolik.plugins.trouble",
    require "frolik.plugins.git",

    require "frolik.plugins.lualine",
    require "frolik.plugins.toggleterm",
    require "frolik.plugins.snacks",

    require "frolik.plugins.flash",
    require "frolik.plugins.numb",
    require "frolik.plugins.harpoon",
    require "frolik.plugins.preview",
    require "frolik.plugins.surround",

    require "frolik.plugins.autopairs",
    require "frolik.plugins.telescope",
}, {
    ui = {
        backdrop = 100,
        border = "rounded",
    },
})
