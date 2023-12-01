local overseer = require "overseer"
overseer.setup {
    task_list = {
        direction = "right",
    },
    task_launcher = {
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
            i = {
                ["<C-s>"] = "Submit",
                -- ["<C-c>"] = nil,
            },
            n = {
                ["<CR>"] = "Submit",
                ["<C-s>"] = "Submit",
                ["q"] = "Cancel",
                ["?"] = "ShowHelp",
            },
        },
    },
    task_editor = {
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
            i = {
                ["<CR>"] = "NextOrSubmit",
                ["<C-s>"] = "Submit",
                ["<Tab>"] = "Next",
                ["<S-Tab>"] = "Prev",
                -- ["<C-c>"] = nil,
            },
            n = {
                ["<CR>"] = "NextOrSubmit",
                ["<C-s>"] = "Submit",
                ["<Tab>"] = "Next",
                ["<S-Tab>"] = "Prev",
                ["q"] = "Cancel",
                ["?"] = "ShowHelp",
            },
        },
    },
}

overseer.register_template {
    name = "NODE RUNNER",
    builder = function()
        local file = vim.fn.expand "%:p"
        local filetype = file:match "^.+%.(.+)$"
        local cwd = vim.loop.cwd()
        -- local cwd_file = file:gsub(cwd .. "/", "")
        local cmd = { "echo" }
        local args = { file }
        if filetype == "js" then
            cmd = { "node" }
        elseif filetype == "ts" then
            cmd = { "node" }
            args = { "-r", "ts-node/register", file }
        end
        vim.api.nvim_out_write(
            "cwd: " .. cwd .. " exec: " .. table.concat(cmd, " ") .. " " .. table.concat(args, " ") .. "\n"
        )
        return {
            cmd = cmd,
            args = args,
            cwd = cwd,
            components = {
                { "on_output_quickfix", set_diagnostics = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    priority = 1,
}

