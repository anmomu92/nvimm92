require("config.lazy")

local api = vim.api
local cmd = vim.cmd

-- Functions to run when writing a Buffer
api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
	require("taskman").UpdateTasks()
  end,
})

-- Funtions to run when entering Vim
api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").update({ show = false })
  end
})

-- User commands
-- Vertical help
api.nvim_create_user_command("Help", function(opts)
  cmd("vertical help " .. opts.args)
end, { nargs = "?", complete = "help" })

-- Alias :h to :Help
cmd("cnoreabbrev <expr> h getcmdtype() == ':' && getcmdline() == 'h' ? 'Help' : 'h'")

