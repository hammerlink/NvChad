vim.api.nvim_create_user_command('NodePrettier', function()
  local command = "!bash npx prettier --write " .. vim.api.nvim_buf_get_name(0);
  print(command)
  return command
end,
  {})
