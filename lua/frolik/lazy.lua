local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    require 'frolik.plugins.colorscheme',

    require 'frolik.plugins.oil',
    require 'frolik.plugins.which-key',

    require 'frolik.plugins.lsp',
    require 'frolik.plugins.cmp',
    require 'frolik.plugins.copilot',

    require 'frolik.plugins.lint',
    require 'frolik.plugins.format',

    require 'frolik.plugins.trouble',
    require 'frolik.plugins.gitsigns',

    require 'frolik.plugins.lualine',
    require 'frolik.plugins.toggleterm',
    require 'frolik.plugins.indent_line',

    require 'frolik.plugins.leap',
    require 'frolik.plugins.numb',
    require 'frolik.plugins.harpoon',

    require 'frolik.plugins.autopairs',
    require 'frolik.plugins.telescope',
}, {
    ui = {
        backdrop = 100,
        border = 'rounded',
    },
})
