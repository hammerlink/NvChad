local utils = require "core.utils"
local custom_utils = require "custom.utils"
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd", "vuels", "pyright", "rust_analyzer", "yamlls" }

local has_deno_json = custom_utils.root_cwd_file_exists "deno.json"
local has_package_json = custom_utils.root_cwd_file_exists "package.json"
local has_pnpm_workspace = custom_utils.root_cwd_file_exists "pnpm-workspace.yaml"

-- pnpm-workspace.yaml

if has_deno_json then
    print "deno detected, tsserver disabled"
    lspconfig.denols.setup {
        on_attach = function(client, bufnr)
            utils.load_mappings("lspconfig", { buffer = bufnr })

            if client.server_capabilities.signatureHelpProvider then
                require("nvchad.signature").setup(client)
            end

            if
                not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens"
            then
                client.server_capabilities.semanticTokensProvider = nil
            end
        end,
        -- on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        -- capabilities = capabilities,
    }
elseif has_package_json then
    if has_pnpm_workspace then
        print "pnpm workspace detected"
        local pnpmPackages = custom_utils.getPNpmWorkSpacePackages()
        lspconfig.tsserver.setup {
            root_dir = function()
                return custom_utils.root_dir
            end,
            on_attach = function(client, bufnr)
                -- print("attaching buffer lsp " .. bufnr .. " client " .. client.name .. " id " .. client.id)

                if not client.monoRepoCheck then
                    for _, pkgPath in pairs(pnpmPackages) do
                        -- print("adding workspace: " .. pkgPath)
                        vim.lsp.buf.add_workspace_folder(pkgPath)
                    end
                    client.monoRepoCheck = "done"
                end

                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false

                utils.load_mappings("lspconfig", { buffer = bufnr })

                if client.server_capabilities.signatureHelpProvider then
                    require("nvchad.signature").setup(client)
                end

                if
                    not utils.load_config().ui.lsp_semantic_tokens
                    and client.supports_method "textDocument/semanticTokens"
                then
                    client.server_capabilities.semanticTokensProvider = nil
                end
            end,
        }
    else
        table.insert(servers, "tsserver")
    end
else
    table.insert(servers, "tsserver")
end

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

--
-- lspconfig.pyright.setup { blabla}
