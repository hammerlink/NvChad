-- lua/custom/mappings
local M = {}

M.undotree = {
  n = {
    ["<leader>tu"] = {"<cmd> UndotreeToggle <CR>", "Undotree toggle"}
  }
}

return M
