local crates = require "crates"

vim.keymap.set("n", "<leader>ct", crates.toggle, { desc = "Toggle" })
vim.keymap.set("n", "<leader>cr", crates.reload, { desc = "Reload" })
vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { desc = "Show Versions" })
vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Show Features" })
vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, { desc = "Show Dependencies" })
vim.keymap.set("n", "<leader>cu", crates.upgrade_crate, { desc = "Upgrade Crate" })
vim.keymap.set("n", "<leader>ca", crates.upgrade_all_crates, { desc = "Upgrade All Crates" })
vim.keymap.set("n", "<leader>ce", crates.expand_plain_crate_to_inline_table, { desc = "Expand Crate" })
vim.keymap.set("n", "<leader>cE", crates.extract_crate_into_table, { desc = "Extract Crate" })
vim.keymap.set("n", "<leader>cH", crates.open_homepage, { desc = "Open Homepage" })
vim.keymap.set("n", "<leader>cR", crates.open_repository, { desc = "Open Repository" })
vim.keymap.set("n", "<leader>cD", crates.open_documentation, { desc = "Open Documentation" })
vim.keymap.set("n", "<leader>cC", crates.open_crates_io, { desc = "Open Crates.io" })