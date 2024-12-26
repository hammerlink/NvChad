local cwd = vim.fn.getcwd()

-- print("startup init " .. cwd)

vim.api.nvim_set_keymap("i", "<C-c>", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-k>", "<C-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<NOP>", { noremap = true, silent = true })

require "custom.git-check.init"

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "help", "man" },
--     callback = function()
--         vim.treesitter.disable "highlight"
--     end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "help", "man" },
--   callback = function()
--     vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] = nil
--   end,
-- })
