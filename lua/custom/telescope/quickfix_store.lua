local utils = require "custom.utils"
local M = {}

-- Store the last search parameters
M.last_telescope_search = {}

-- telescope cwd /home/hendrik/Projects/Gridlink/packages/backend/core
-- finder = {
--     close = function: 0x7a722217e580,
-- },
-- prompt = iuseraccount,
--
-- Function to store search parameters when sending to quickfix
M.store_telescope_search = function(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)

    M.last_telescope_search = {
        prompt = picker:_get_prompt(), -- Use the proper method to get prompt text
        cwd = picker.cwd,
        prompt_title = picker.prompt_title,
    }
    require("telescope.actions").send_to_qflist(prompt_bufnr)
    vim.cmd "copen"
end

-- Function to refresh quickfix with last search
M.refresh_quickfix = function()
    local last_search = M.last_telescope_search
    if last_search.prompt then
        -- Clear the quickfix list
        vim.fn.setqflist({}, "r")

        if last_search.prompt_title == "Live Grep" then
            require("telescope.builtin").live_grep {
                default_text = last_search.prompt,
                cwd = last_search.cwd,
            }
        end
        utils.print_table(last_search)
    end
end

return M
