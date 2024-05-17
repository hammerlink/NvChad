local custom_utils = require "custom.utils"

local isDeno = custom_utils.root_js_type == custom_utils.RootJsTypes.DENO
if not isDeno then
    local prettier = require "prettier"
    prettier.setup {
        bin = "prettier", -- or `'prettierd'` (v0.23.3+)
        filetypes = {
            "css",
            "graphql",
            "html",
            "javascript",
            "javascriptreact",
            "json",
            "less",
            "markdown",
            "scss",
            "typescript",
            "typescriptreact",
            "yaml",
        },
        ["null-ls"] = {
            condition = function()
                return prettier.config_exists {
                    -- if `false`, skips checking `package.json` for `"prettier"` key
                    check_package_json = true,
                }
            end,
            runtime_condition = function(params)
                -- return false to skip running prettier
                local isDeno = custom_utils.root_js_type == custom_utils.RootJsTypes.DENO
                return not isDeno
            end,
            timeout = 5000,
        },
    }
end
