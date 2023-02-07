-- lua/custom/mappings
local M = {}

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

M.undotree = {
  n = {
    ["<leader>tu"] = {"<cmd> UndotreeToggle <CR>", "Undotree toggle"},
    ["<leader>lr"] = {"<cmd> Telescope lsp_references <CR>", "LSP find references in telescope"},
    ["<leader>tr"] = {"<cmd> Telescope resume <CR>", "Resume previous telescope search"},
  },
  v = {
    ["J"] = {":m '>+1<CR>gv=gv", "Move lines down"},
    ["K"] = {":m '<-2<CR>gv=gv", "Move lines up"},
  },
}

M.hammernet = {
  n = {
    ["<leader>tt"] = {":split | te<CR>", "Open terminal, split horizontal"},
    ["<leader>tv"] = {":vsplit | te<CR>", "Open terminal, split horizontal"},
  }
}

return M
