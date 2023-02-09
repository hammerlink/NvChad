-- lua/custom/mappings
local M = {}
local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
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
    ["<leader>bb"] = {"<cmd> Telescope git_branches <CR>", "Telescope the current branches"},
    ["<leader>pf"] = {":NodePrettier <CR>", "Custom Node prettier"},
    ["<A-S-Left>"] = { ":b# <CR>", "Open previous buffer"},
  },
  t = {
    -- ["<C-t>"] = { termcodes "<C-\\><C-N><C-w><C-q>", "close terminal window" },
  }
}

return M
