require("config.lazy")

local api = vim.api
local cmd = vim.cmd

-- Lint file when at save
api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
	require("taskman").UpdateTasks()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})

-- Update the plugins at start
api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy").update({ show = false })
  end
})

-- Vertical help page
api.nvim_create_user_command("Help", function(opts)
  cmd("vertical help " .. opts.args)
end, { nargs = "?", complete = "help" })

-- Alias :h to :Help
cmd("cnoreabbrev <expr> h getcmdtype() == ':' && getcmdline() == 'h' ? 'Help' : 'h'")

