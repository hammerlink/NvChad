local custom_utils = require "custom.utils"
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
            if custom_utils.root_js_type == custom_utils.RootJsTypes.DENO then
                cmd = { "deno" }
            else
                cmd = { "node" }
            end
        elseif filetype == "ts" then
            if custom_utils.root_js_type == custom_utils.RootJsTypes.DENO then
                cmd = { "deno" }
            else
                cmd = { "node" }
                args = { "-r", "ts-node/register", cwd_file }
            end
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
        local isDeno = custom_utils.root_js_type == custom_utils.RootJsTypes.DENO

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
            -- TODO GET CLOSEST PACKAGE.json
            cmd = isDeno and { "deno" } or { "node" }
            local runtimeArgs = not isDeno and { "-r", "ts-node/register" }
                or { "run", "--inspect-wait", "--allow-all" }
            args = { "--inspect", "-r", "ts-node/register", cwd_file }
            print("running " .. table.concat(cmd, " ") .. " - " .. table.concat(runtimeArgs, " "))
            local dapRunSettings = {
                type = "pwa-node",
                request = "launch",
                name = "DEBUGGER",
                program = cwd_file,
                cwd = cwd,
                runtimeArgs = runtimeArgs,
            }
            if isDeno then
                dapRunSettings.runtimeExecutable = "deno"
            end
            require("dap").run(dapRunSettings)
            return { cmd = { "echo" }, args = { cwd } }
        elseif filetype == "rs" then
            local start_src_pos, end_src_pos = string.find(file:reverse(), ("src/"):reverse())
            if start_src_pos then
                cwd = string.sub(file, 0, #file - end_src_pos)
                cwd_file = string.sub(file, #file - end_src_pos + 1, #file)
                args = { cwd_file }
                -- path without src, /home/test/src/file/main.rs -> file/main.rs
                local src_path = string.sub(file, #file - start_src_pos + 1, #file)
                print("src path " .. src_path)
                print("cwd " .. cwd)
                print("cwd_file " .. cwd_file)
                -- if src_path:match "^/bin/" then
                --     -- local bin_name = (src_path:gsub("^/bin/", "")):match "([^/]+)"
                --     -- if bin_name then
                --     --     cmd = { "cargo" }
                --     --     args = { "run", "--release", "--bin", bin_name }
                --     -- end
                -- end
                require("dap").run {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = file,
                    cwd = cwd,
                    -- cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    initCommands = function()
                        -- Find out where to look for the pretty printer Python module
                        local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")

                        local script_import = 'command script import "'
                            .. rustc_sysroot
                            .. '/lib/rustlib/etc/lldb_lookup.py"'
                        local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                        local commands = {}
                        local r_file = io.open(commands_file, "r")
                        if r_file then
                            for line in r_file:lines() do
                                table.insert(commands, line)
                            end
                            r_file:close()
                        end
                        table.insert(commands, 1, script_import)

                        return commands
                    end,
                }
                return { cmd = { "echo" }, args = { cwd } }
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
