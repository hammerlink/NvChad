local gen = require "gen"
local custom_utils = require "custom.utils"
local M = {}

M.analyze_selection = function()
    -- Get the current buffer and the range of the selected text
    local bufnr = vim.api.nvim_get_current_buf()
    -- how to check if there is a selection?
    -- react differently if there is no selection
    local start_pos = vim.fn.getpos "'<"
    local end_pos = vim.fn.getpos "'>"

    -- Convert Vim positions to LSP positions
    local start_line = start_pos[2] - 1
    local start_col = start_pos[3] - 1
    local end_line = end_pos[2] - 1
    local end_col = end_pos[3] - 1

    local total_errors = "\nErrors:"
    local error_counter = 0
    for i = start_line, end_line do
        local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, i, { severity = 1 })
        if line_diagnostics then
            for _, diagnostic in ipairs(line_diagnostics) do
                error_counter = error_counter + 1
                total_errors = string.format("%s\n - %s", total_errors, diagnostic.message)
                print(diagnostic.message)
                print(total_errors)
            end
        end
    end

    if error_counter == 0 then
        return print "no errors found"
    end

    local prompt = string.format("Can you help me explain the following on the code:\n%s\n$text", total_errors)
    print(prompt)
    local p = vim.tbl_deep_extend("force", { mode = "v" }, { prompt = prompt })
    return gen.exec(p)
end

return M
