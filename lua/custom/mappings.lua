local telescope_quickfix_store = require "custom.telescope.quickfix_store"
---@type MappingsTable
local M = {}

local displayer = nil
local make_display = function(entry)
    if not displayer then
        return ""
    end
    return displayer {
        { entry.sha,   "TelescopeResultsIdentifier" },
        { entry.date },
        { entry.author },
        entry.msg,
    }
end

M.ward = {
    v = {
        ["fd"] = { "<Esc>", "VISUAL - Custom Escape" },
    },
    i = {
        ["fd"] = { "<Esc>:w<CR>", "VISUAL - Custom Escape and Save" },
        ["jj"] = { "<Esc>", "INSERT - Custom Escape" },
    },
}

M.telescope = {
    n = {
        ["<leader>fy"] = { "<cmd> Telescope live_grep no_ignore=true hidden=true <CR>", "Live grep all" },
        ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Find keymaps" },
        ["<leader>fr"] = { "<cmd> Telescope resume <CR>", "Resume last find" },
        ["<leader>fj"] = { "<cmd> Telescope jumplist <CR>", "Find recent file visits" },
        ["<leader>ft"] = { "<cmd> Telescope search_history <CR>", "Browse old searches" },
        ["<leader>fn"] = { "<cmd> Telescope notify <CR>", "Browse notifications" },
        ["<leader>fu"] = { "<cmd> Telescope treesitter <CR>", "Treesitter" },
        ["<leader>rq"] = { telescope_quickfix_store.refresh_quickfix, "Treesitter" },
    },
}
M.git = {
    n = {
        ["<leader>gb"] = { "<cmd> Telescope git_branches <CR>", "Git branches" },
        ["<leader>gf"] = {
            function()
                if not displayer then
                    displayer = require("telescope.pickers.entry_display").create {
                        separator = " ",
                        items = {
                            { width = 8 },
                            { width = 19 },
                            { width = 7 },
                            { remaining = true },
                        },
                    }
                end
                require("telescope.builtin").git_bcommits {
                    git_command = {
                        "git",
                        "log",
                        "--pretty='format:%h %ad %an %s'",
                        "--date=format:%Y-%m-%dT%H:%M:%S",
                        "--abbrev-commit",
                    },
                    entry_maker = function(entry)
                        if not entry or entry == "" then
                            return nil
                        end

                        local sha, date, author, msg = string.match(entry, "'format:([^ ]+) ([^ ]+) ([^ ]+) (.+)'")
                        if not sha or not date or not msg then
                            print("discarding", entry)
                            return nil
                        end

                        return {
                            value = sha,
                            ordinal = sha .. " " .. msg,
                            display = make_display,
                            sha = sha,
                            date = date,
                            author = author,
                            msg = msg,
                        }
                    end,
                }
            end,
            "Git file history",
        },
        ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },
        ["<leader>gm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
        ["<leader>gd"] = { "<cmd> DiffviewOpen <CR>", "Git Changes Diffview" },
        ["<leader>gh"] = { "<cmd> DiffviewFileHistory<CR>", "Git FileHistory Diffview" },
        ["<leader>gs"] = { "<cmd> DiffviewFileHistory %<CR>", "Git FileHistory Diffview" },
        ["<leader>gr"] = { "<cmd> DiffviewRefresh <CR>", "Git FileHistory Diffview" },
        ["<leader>gx"] = { "<cmd> DiffviewClose <CR>", "Git Close Diffview" },
        ["<leader>gg"] = { "<cmd> Neogit <CR>", "Git Neogit" },
        ["<leader>gl"] = {
            function()
                require("telescope.builtin").git_status { use_file_path = true, expand_dir = false }
            end,
            "Local changes",
        },
    },
    v = {
        ["<leader>gf"] = {
            function()
                require("telescope.builtin").git_bcommits_range {
                    git_command = { "git", "log", "--pretty=format:%h %ad %s", "--abbrev-commit", "--date=iso" },
                }
            end,
            "Git file history",
        },
        ["<leader>gs"] = { ":DiffviewFileHistory %<CR>", "Git FileHistory Diffview - selection" },
    },
}
-- more keybinds!
M.overseer = {
    n = {
        ["<leader>ot"] = { "<cmd> OverseerToggle <CR>", "Ovseer toggle" },
        ["<leader>or"] = { "<cmd> OverseerRun <CR>", "Ovseer run" },
        ["<leader>oo"] = { "<cmd> OverseerQuickAction <CR>", "Ovseer quick action" },
    },
}
M.general = {
    n = {
        ["<leader>ut"] = { "<cmd> UndotreeToggle <CR>", "Undotree toggle" },
        ["<leader>uf"] = { "<cmd> UndotreeFocus <CR>", "Undotree focus" },
        ["<leader>tx"] = { "<cmd> tabclose <CR>", "Tab close" },
        ["<leader>nx"] = { "<cmd> lua require('notify').dismiss() <CR>", "Close all notifications" },
        ["<leader>bo"] = { "<cmd> %bd|e# <CR>", "Close all other buffers" },
        ["<leader>lt"] = { "<cmd> InspectTree <CR>", "LSP Tree" },
        -- ["<leader>at"] = { "<cmd> ASToggle <CR>", "Autosave toggle" },
    },
}
M.neotest = {
    n = {
        ["<leader>nt"] = { "<cmd> Neotest summary toggle <CR>", "Neotest toggle" },
        ["<leader>na"] = { "<cmd> Neotest attach <CR>", "Neotest attach logs" },
        ["<leader>nr"] = { "<cmd> Neotest run <CR>", "Neotest run closest" },
        ["<leader>ndr"] = { '<cmd> lua require("neotest").run.run({strategy = "dap"}) <CR>', "Neotest run closest" },
        ["<leader>no"] = { "<cmd> Neotest output <CR>", "Neotest output" },
        ["<leader>nf"] = { "<cmd> Neotest output <CR>", "Neotest output" },
    },
}
M.spectre = {
    n = {
        ["<leader>s"] = { "<cmd> lua require('spectre').open() <CR>", "Open Spectre" },
        ["<leader>sw"] = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
        ["<leader>sp"] = {
            "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>",
            "Search on current file",
        },
    },
    v = {
        ["<leader>s"] = { "<cmd> lua require('spectre').open() <CR>", "Open Spectre" },
        ["<leader>sw"] = {
            "<esc><cmd>lua require('spectre').open_visual({select_word=true})<CR>",
            "Search current word",
        },
    },
}
M.aerial = {
    n = {
        ["<leader>at"] = { "<cmd> AerialToggle <CR>", "Toggle Aerial" },
    },
}
M.debug = {
    n = {
        ["<leader>dt"] = { "<cmd> lua require('dapui').toggle() <CR>", "Toggle Debug UI" },
        ["<leader>dr"] = { "<cmd> lua require('dapui').open({reset = true}) <CR>", "Reset Debug UI" },
        ["<F9>"] = { "<cmd> DapContinue <CR>", "Debug continue / start" },
        ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint" },
        ["<F8>"] = { "<cmd> DapStepOver <CR>", "Debug Step Over" },
        ["<leader>di"] = { "<cmd> DapStepInto <CR>", "Debug Step Into" },
        ["<leader>do"] = { "<cmd> DapStepOut <CR>", "Debug Step Out" },
        ["<leader>dx"] = { "<cmd> DapTerminate <CR>", "Debug Terminate" },
        ["<leader>dl"] = { "<cmd> DapShowLog <CR>", "Debug show log" },
    },
}
M.trouble = {
    n = {
        ["<leader>xx"] = { "<cmd> TroubleClose <CR>", "Trouble close" },
        ["<leader>xf"] = { "<cmd> TroubleToggle document_diagnostics <CR>", "Trouble open file diagnostics" },
        ["<leader>xq"] = { "<cmd> TroubleToggle quickfix <CR>", "Trouble open file diagnostics" },
        ["<leader>xw"] = { "<cmd> TroubleToggle workspace_diagnostics <CR>", "Trouble open workspace diagnostics" },
        ["<leader>xr"] = { "<cmd> TroubleRefresh <CR>", "Refresh trouble" },
    },
}
M.lspconfig = {
    n = {
        ["gd"] = {
            function()
                vim.lsp.buf.definition {
                    on_list = function(options)
                        if #options.items == 1 then
                            return vim.lsp.buf.definition()
                        end
                        return require("telescope.builtin").lsp_definitions()
                    end,
                }
            end,
            "LSP definition",
        },
        ["gr"] = { "<cmd> Telescope lsp_references <CR>", "LSP references" },
        ["<leader>li"] = { "<cmd> LspInfo <CR>", "LSP info" },
        ["<leader>lr"] = { "<cmd> LspRestart <CR>", "LSP restart" },
    },
}
M.gen = {
    n = {
        ["<leader>ar"] = { "<cmd> Gen <CR>", "AI Run" },
    },
    v = {
        ["<leader>ar"] = { "<cmd> Gen <CR>", "AI Run" },
        ["<leader>ad"] = { function () 
            require('custom.configs.gen').analyze_selection()
        end, "Diagnostics test" },
M.avante = {
    n = {
        ["<leader>av"] = { "<cmd> AvanteToggle <CR>", "Avante toggle" },
        ["<leader>ax"] = { "<cmd> AvanteClear <CR>", "Avante clear" },
    },
    v = {
        ["<leader>av"] = { "<cmd> AvanteToggle <CR>", "Avante toggle" },
    },
}

return M
