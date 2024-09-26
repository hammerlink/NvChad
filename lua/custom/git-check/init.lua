local utils = require "custom.git-check.utils"
local config = utils.safe_require "custom.git-check.config"
if config then
    local remote_url = utils.run_command "git config --get remote.origin.url"
    for _, git_config in pairs(config) do
        local pattern = git_config.pattern
        local email = git_config.email
        local name = git_config.name
        local gpg_key = git_config.gpg_key
        local gpg_sign = git_config.gpg_sign

        if string.match(remote_url, pattern) then
            local updated = false
            -- Check and set the user.email if necessary
            if email then
                local current_email = utils.run_command "git config --get user.email"
                if string.gsub(current_email, "%s+", "") ~= email then
                    os.execute("git config user.email " .. email)
                    updated = true
                end
            end
            if name then
                -- Check and set the user.name if necessary
                local current_user = utils.trim(utils.run_command "git config --get user.name")
                if not (current_user == name) then
                    os.execute('git config user.name "' .. name .. '"')
                    updated = true
                end
            end
            if gpg_sign then
                local current_gpg_sign = utils.trim(utils.run_command "git config --get commit.gpgSign")
                if not (current_gpg_sign == gpg_sign) then
                    os.execute("git config commit.gpgSign " .. gpg_sign)
                    updated = true
                end
            end
            if gpg_key then
                local current_gpg_key = utils.trim(utils.run_command "git config --get user.signingkey")
                if not (current_gpg_key == gpg_key) then
                    os.execute("git config user.signingkey " .. gpg_sign)
                    updated = true
                end
            end

            -- Enable GPG signing for commits
            if updated == true then
                print("git updated to" .. email)
            end
        end
    end
end
