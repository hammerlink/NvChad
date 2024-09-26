local M = {}
-- Function to read and parse the JSON config file
M.read_sensitive_config = function(file_path)
    local config = {}
    local file = io.open(file_path, "r")
    if file then
        local content = file:read "*a"
        file:close()
        -- Parse the JSON content
        local ok, parsed = pcall(vim.json.decode, content)
        if ok and parsed then
            config = parsed
        else
            print "Error parsing JSON config file."
        end
    else
        print("Warning: Sensitive config file not found at " .. file_path)
    end
    return config
end
M.run_command = function(command)
    local handle = io.popen(command)
    local result = handle:read "*a"
    handle:close()
    return result
end
M.trim = function(s)
    return s:match "^%s*(.-)%s*$"
end
M.safe_require = function(module_name)
    -- Get Neovim runtime paths
    local rtp = vim.api.nvim_list_runtime_paths()

    -- Convert the module name to a relative path (e.g., "my_module" -> "my_module.lua")
    local module_path = module_name:gsub("%.", "/") .. ".lua"

    -- Search for the module in the runtime paths
    for _, path in ipairs(rtp) do
        local full_path = path .. "/lua/" .. module_path
        local file = io.open(full_path, "r")
        if file then
            file:close()
            -- If the file is found, require the module
            return require(module_name)
        end
    end

    -- If not found, return nil
    return nil
end
return M
