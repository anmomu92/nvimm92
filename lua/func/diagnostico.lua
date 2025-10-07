local M = {}

function M.SwitchVirtualLines()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end

return M
