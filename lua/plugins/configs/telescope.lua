local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local telescope_quickfix_store = require "custom.telescope.quickfix_store"

local copy_commit_hash = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    local commit_hash = entry.value
    vim.fn.setreg("+", commit_hash) -- Copy to system clipboard
    print("Copied commit hash: " .. commit_hash)
    actions.close(prompt_bufnr)
end

local options = {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close,
                ["<C-x>"] = require("telescope.actions").close,
                ["<C-b>"] = require("telescope.actions").delete_buffer,
                ["<C-j>"] = {
                    require("telescope.actions").move_selection_next,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<C-k>"] = {
                    require("telescope.actions").move_selection_previous,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<C-s>"] = {
                    require("telescope.actions").file_split,
                    type = "action",
                },
            },
            i = {
                ["<C-x>"] = require("telescope.actions").close,
                ["<C-b>"] = require("telescope.actions").delete_buffer,
                ["<C-j>"] = {
                    require("telescope.actions").move_selection_next,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<C-k>"] = {
                    require("telescope.actions").move_selection_previous,
                    type = "action",
                    opts = { nowait = true, silent = true },
                },
                ["<C-s>"] = {
                    require("telescope.actions").file_split,
                    type = "action",
                },
                ["<C-q>"] = telescope_quickfix_store.store_telescope_search,
            },
        },
    },

    extensions_list = { "themes", "terms" },
    pickers = {
        git_commits = {
            mappings = {
                i = { ["<C-y>"] = copy_commit_hash },
                n = { ["<C-y>"] = copy_commit_hash },
            },
        },
        git_bcommits = {
            mappings = {
                i = { ["<C-y>"] = copy_commit_hash },
                n = { ["<C-y>"] = copy_commit_hash },
            },
        },
    },
}

return options
