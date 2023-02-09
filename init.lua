vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

require "core"
require "core.options"

-- setup packer + plugins

pcall(require, "custom")

require("core.utils").load_mappings()
