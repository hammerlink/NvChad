local utils = require "core.utils"
local custom_utils = require "custom.utils"
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "vuels", "pyright", "rust_analyzer", "yamlls", "prismals" }

local has_deno_json = custom_utils.root_cwd_file_exists "deno.json"
local has_package_json = custom_utils.root_cwd_file_exists "package.json"
local has_pnpm_workspace = custom_utils.root_cwd_file_exists "pnpm-workspace.yaml"

-- pnpm-workspace.yaml
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--compile-commands-dir=build",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--query-driver=/usr/bin/g++", -- Adjust this path based on your system
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_dir = lspconfig.util.root_pattern(
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git"
    ),
    single_file_support = true,
}

if has_deno_json then
    print "deno detected, ts_ls disabled"
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
        local pnpmPackages = custom_utils.getPnpmWorkSpacePackages()
        lspconfig.ts_ls.setup {
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
        table.insert(servers, "ts_ls")
    end
else
    table.insert(servers, "ts_ls")
end

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

--
-- lspconfig.pyright.setup { blabla}
