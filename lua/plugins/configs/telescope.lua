local function get_buffers(options)
    local buffers = {}
    local len = 0
    local options_listed = options.listed
    local vim_fn = vim.fn
    local buflisted = vim_fn.buflisted

    for buffer = 1, vim_fn.bufnr "$" do
        if not options_listed or buflisted(buffer) ~= 1 then
            len = len + 1
            buffers[len] = buffer
        end
    end

    return buffers
end

local close_other_buffers = function(prompt_bufnr)
    print "deleting other buffers"
    local action_state = require "telescope.actions.state"
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    print "deleting other buffers"
    current_picker:delete_selection(function(selection)
        local force = vim.api.nvim_buf_get_option(selection.bufnr, "buftype") == "terminal"
        local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = force })
        return ok
    end)
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
            },
        },
    },

    extensions_list = { "themes", "terms" },
}

return options
