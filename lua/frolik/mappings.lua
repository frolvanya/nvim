vim.keymap.set("n", "<S-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<S-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<S-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<S-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open Oil.nvim" })

vim.keymap.set("n", "<bs>", "<cmd>bprev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bw", "<cmd>bdelete<cr>", { desc = "Close buffer" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up" })

vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
vim.keymap.set("n", "<leader>lI", "<cmd>Mason<cr>", { desc = "Mason Info" })
