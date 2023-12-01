local overseer = require "overseer"
overseer.setup {
    dap = true,
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
    name = "RUNNER",
    builder = function()
        local file = vim.fn.expand "%:p"
        local filetype = file:match "^.+%.(.+)$"
        local cwd = vim.loop.cwd()
        local cwd_file = file:gsub(cwd .. "/", "")
        local cmd = { "echo" }
        local args = { cwd_file }

        if filetype == "js" then
            cmd = { "node" }
        elseif filetype == "ts" then
            cmd = { "node" }
            args = { "-r", "ts-node/register", cwd_file }
        elseif filetype == "rs" then
            cmd = { "rust-script" }
            -- Find the last occurrence of the searchTerm in the path
            local start_src_pos, end_src_pos = string.find(file:reverse(), ("src/"):reverse())
            if start_src_pos then
                cwd = string.sub(file, 0, #file - end_src_pos)
                cwd_file = string.sub(file, #file - end_src_pos + 1, #file)
                args = { cwd_file }
                -- path without src, /home/test/src/file/main.rs -> file/main.rs
                local src_path = string.sub(file, #file - start_src_pos + 1, #file)
                print(src_path)
                if src_path:match "^/bin/" then
                    local bin_name = (src_path:gsub("^/bin/", "")):match "([^/]+)"
                    if bin_name then
                        cmd = { "cargo" }
                        args = { "run", "--release", "--bin", bin_name }
                    end
                end
            end
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
overseer.register_template {
    name = "DEBUGGER",
    builder = function()
        local file = vim.fn.expand "%:p"
        local filetype = file:match "^.+%.(.+)$"
        local cwd = vim.loop.cwd()
        local cwd_file = file:gsub(cwd .. "/", "")
        local cmd = { "echo" }
        local args = { cwd_file }

        if filetype == "js" then
            require("dap").run {
                type = "pwa-node",
                request = "launch",
                name = "DEBUGGER",
                program = cwd_file,
                cwd = cwd,
            }
            return { cmd = { "echo" }, args = { cwd } }
        elseif filetype == "ts" then
            cmd = { "node" }
            args = { "--inspect", "-r", "ts-node/register", cwd_file }
            require("dap").run {
                type = "pwa-node",
                request = "launch",
                name = "DEBUGGER",
                program = cwd_file,
                cwd = cwd,
                runtimeArgs = { "-r", "ts-node/register" },
            }
            return { cmd = { "echo" }, args = { cwd } }
        elseif filetype == "rs" then
            -- TODO
            cmd = { "rust-script" }
            -- Find the last occurrence of the searchTerm in the path
            local start_src_pos, end_src_pos = string.find(file:reverse(), ("src/"):reverse())
            if start_src_pos then
                cwd = string.sub(file, 0, #file - end_src_pos)
                cwd_file = string.sub(file, #file - end_src_pos + 1, #file)
                args = { cwd_file }
                -- path without src, /home/test/src/file/main.rs -> file/main.rs
                local src_path = string.sub(file, #file - start_src_pos + 1, #file)
                print(src_path)
                if src_path:match "^/bin/" then
                    local bin_name = (src_path:gsub("^/bin/", "")):match "([^/]+)"
                    if bin_name then
                        cmd = { "cargo" }
                        args = { "run", "--release", "--bin", bin_name }
                    end
                end
            end
        end
        vim.api.nvim_out_write(
            "cwd: " .. cwd .. " exec: " .. table.concat(cmd, " ") .. " " .. table.concat(args, " ") .. "\n"
        )
        return {
            cmd = cmd,
            args = args,
            cwd = cwd,
        }
    end,
    priority = 2,
}
