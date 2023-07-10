---@type MappingsTable
local M = {}

M.telescope = {
    n = {
        ["<leader>fy"] = { "<cmd> Telescope live_grep no_ignore=true hidden=true <CR>", "Live grep all" },
        ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Find keymaps" },
        ["<leader>fr"] = { "<cmd> Telescope resume <CR>", "Resume last find" },
    },
}
M.git = {
    n = {
        ["<leader>gb"] = { "<cmd> Telescope git_branches <CR>", "Git branches" },
        ["<leader>gf"] = { "<cmd> Telescope git_bcommits <CR>", "Git file history" },
        ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },
        ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    },
}
-- more keybinds!
M.overseer = {
    n = {
        ["<leader>ot"] = { "<cmd> OverseerToggle <CR>", "Ovseer toggle" },
        ["<leader>or"] = { "<cmd> OverseerRun <CR>", "Ovseer run" },
    },
}
M.general = {
    n = {
        ["<leader>ut"] = { "<cmd> UndotreeToggle <CR>", "Undotree toggle" },
        ["<leader>uf"] = { "<cmd> UndotreeFocus <CR>", "Undotree focus" },
        -- ["<leader>at"] = { "<cmd> ASToggle <CR>", "Autosave toggle" },
    },
}
M.neotest = {
    n = {
        ["<leader>nr"] = { "<cmd> Neotest run <CR>", "Neotest run closest" },
        ["<leader>no"] = { "<cmd> Neotest output <CR>", "Neotest output" },
    },
}

return M
