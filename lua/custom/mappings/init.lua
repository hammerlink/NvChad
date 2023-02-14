-- lua/custom/mappings
local M = {}
local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

M.undotree = {
    n = {
        ["<leader>tu"] = { "<cmd> UndotreeToggle <CR>", "Undotree toggle" },
        ["<leader>lr"] = { "<cmd> Telescope lsp_references <CR>", "LSP find references in telescope" },
        ["<leader>tr"] = { "<cmd> Telescope resume <CR>", "Resume previous telescope search" },
    },
    v = {
        ["J"] = { ":m '>+1<CR>gv=gv", "Move lines down" },
        ["K"] = { ":m '<-2<CR>gv=gv", "Move lines up" },
    },
}

M.hammernet = {
    n = {
        ["<leader>tt"] = { ":split | te<CR>", "Open terminal, split horizontal" },
        ["<leader>tv"] = { ":vsplit | te<CR>", "Open terminal, split horizontal" },
        ["<leader>bb"] = { "<cmd> Telescope git_branches <CR>", "Telescope the current branches" },
        ["<leader>pf"] = { ":NodePrettier <CR>", "Custom Node prettier" },
        ["<A-S-Left>"] = { ":b# <CR>", "Open previous buffer" },
    },
    t = {
        -- ["<C-t>"] = { termcodes "<C-\\><C-N><C-w><C-q>", "close terminal window" },
    }
}

M.debug = {
    n = {
        ["<leader>dbl"] = { "<cmd>lua require'custom.dap'.setup()<cr>", "Load debugger" },
        ["<leader>dR"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
        ["<leader>dE"] = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
        ["<leader>dC"] = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
        ["<leader>dU"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
        ["<leader>db"] = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
        ["<F9>"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        ["<leader>dd"] = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
        ["<leader>de"] = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
        ["<leader>dg"] = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
        ["<leader>dh"] = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
        ["<leader>dS"] = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
        ["<leader>di"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        ["<F8>"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
        ["<leader>dp"] = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
        ["<leader>dq"] = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
        ["<leader>dr"] = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        ["<leader>ds"] = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
        ["<leader>dt"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
        ["<leader>dx"] = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
        ["<leader>du"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    },
}

return M
