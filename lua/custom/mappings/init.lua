-- lua/custom/mappings
local M = {}

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

M.undotree = {
  n = {
    ["<leader>tu"] = {"<cmd> UndotreeToggle <CR>", "Undotree toggle"},
    ["<leader>tr"] = {"<cmd> Telescope resume <CR>", "Resume previous telescope search"}
  },
  v = {
    ["J"] = {":m '>+1<CR>gv=gv"},
    ["K"] = {":m '<-2<CR>gv=gv"},
  },
}

return M
