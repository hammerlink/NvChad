local present, null_ls = pcall(require, "null-ls")
local custom_utils = require "custom.utils"

local isDeno = custom_utils.root_js_type == custom_utils.RootJsTypes.DENO

if not present then
    return
end

local b = null_ls.builtins

local sources = {

    -- webdev stuff
    b.formatting[isDeno and "deno_fmt" or "prettier"], -- choosed deno for ts/js files cuz its very fast!
    -- b.formatting.prettier, -- so prettier works only on these filetypes

    -- Lua
    b.formatting.stylua,

    -- cpp
    b.formatting.clang_format,

    -- rust
    b.formatting.rustfmt,

    -- sql
    b.formatting.pg_format,
}

null_ls.setup {
    debug = true,
    sources = sources,
}
