local M = {}

function M.AlternaTema()
  if vim.o.background == "dark" then
    vim.o.background = "light"
	vim.cmd("colorscheme gruvbox")
  else
    vim.o.background = "dark"
	vim.cmd("colorscheme gruvbox")
  end
end

return M
