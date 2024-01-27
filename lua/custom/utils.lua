local M = {}

local RootJsTypes = {
    DENO = "DENO",
    PNPM_MONOREPO = "PNPM_MONOREPO",
    JS = "JS",
}
M.RootJsTypes = RootJsTypes

M.root_js_type = nil
local root_dir = vim.fn.getcwd() -- Get the current working directory
M.root_dir = root_dir
M.root_cwd_file_exists = function(root_file)
    local file_path = root_dir .. "/" .. root_file -- Construct the file path
    return vim.fn.filereadable(file_path) ~= 0
end

if M.root_cwd_file_exists "deno.json" then
    M.root_js_type = RootJsTypes.DENO
elseif M.root_cwd_file_exists "package.json" then
    if M.root_cwd_file_exists "pnpm-workspace.yml" then
        M.root_js_type = RootJsTypes.PNPM_MONOREPO
    else
        M.root_js_type = RootJsTypes.JS
    end
end

M.find_closest_package_json_dir = function(start_path, default_value)
    -- Get the current buffer's full path
    local path = start_path
    if not path then
        path = vim.fn.expand "%:p"
    end

    -- Extract the directory from the path
    local dir = vim.fn.fnamemodify(path, ":h")

    -- Keep searching until reaching the root directory
    while dir ~= "/" do
        local package_json_path = dir .. "/package.json"
        -- Check if package.json exists in this directory
        if vim.fn.filereadable(package_json_path) ~= 0 then
            return dir
        end
        -- Move up one directory
        dir = vim.fn.fnamemodify(dir, ":h")
    end

    return default_value -- package.json not found
end
-- pnpm part
local function getDirectories(path)
    local dirs = {}
    print("getting directories " .. path)
    local scanner, err = vim.loop.fs_scandir(path)
    if not scanner then
        print("Error scanning directory: " .. err)
        return dirs
    end

    while true do
        local entry, type = vim.loop.fs_scandir_next(scanner)
        if not entry then
            break
        end

        if type == "directory" and entry ~= "." and entry ~= ".." then
            local fullPath = path .. entry
            table.insert(dirs, fullPath)
        end
    end

    return dirs
end
local function expandWildcards(packages, monorepoRoot)
    local expanded = {}
    for _, pkg in ipairs(packages) do
        if pkg:sub(-1) == "*" then
            local basePath = monorepoRoot .. "/" .. pkg:sub(1, -2)
            local subDirs = getDirectories(basePath)
            for _, dir in ipairs(subDirs) do
                table.insert(expanded, dir)
            end
        else
            table.insert(expanded, monorepoRoot .. "/" .. pkg)
        end
    end
    return expanded
end
M.parsePnpmWorkspaceFile = function(workspaceFilePath)
    local packages = {}
    local file = io.open(workspaceFilePath, "r")

    if not file then
        print("Failed to open " .. workspaceFilePath)
        return packages
    end

    for line in file:lines() do
        -- Matches lines like "  - 'packages/models'"
        local pkg = line:match "%s*%-%s*'(.+)'"
        print("adding raw " .. line)
        if pkg then
            table.insert(packages, pkg)
        end
    end

    file:close()
    return packages
end
M.getPnpmWorkSpacePackages = function()
    local rawPackages = M.parsePnpmWorkspaceFile(root_dir .. "/pnpm-workspace.yaml")
    local packages = expandWildcards(rawPackages, root_dir)
    return packages
end

return M
