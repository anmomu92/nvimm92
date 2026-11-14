require("config.lazy")
local zk_user = require("func.zk-user")

local api = vim.api
local cmd = vim.cmd

-- Functions to run when writing a Buffer
api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
		require("taskman").UpdateTasks()
	end,
})

-- rename markdown file and update links
api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.md",
	callback = function(args)
		local current_dir = vim.fn.expand("%p:h")
		local zk_dir = os.getenv("ZK_NOTEBOOK_DIR")
		if current_dir == zk_dir then
			local old = vim.api.nvim_buf_get_name(args.buf)
			local dir, prefix = old:match("^(.*/)(%w+)%-[^/]*%.md$")
			if not prefix then
				return
			end

			local first = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1]
			local title = first and first:match("^#%s+(.+)$")
			if not title then
				return
			end

			local slug = vim.trim(title):lower():gsub("[^%w]+", "-"):gsub("^%-", ""):gsub("%-$", "")
			local new = dir .. prefix .. "-" .. slug .. ".md"
			if new == old then
				return
			end

			vim.fn.rename(old, new)
			vim.api.nvim_buf_set_name(args.buf, new)
			vim.cmd("silent noautocmd write!")

			zk_user.update_links(vim.fs.basename(old), vim.fs.basename(new), new)
		end
	end,
})

-- User commands
-- Vertical help
api.nvim_create_user_command("Help", function(opts)
	cmd("vertical help " .. opts.args)
end, { nargs = "?", complete = "help" })

-- Alias :h to :Help
cmd("cnoreabbrev <expr> h getcmdtype() == ':' && getcmdline() == 'h' ? 'Help' : 'h'")

-- autocenter the cursor
local group = vim.api.nvim_create_augroup("AutoCenter", { clear = true })

local last_line = 0
api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = group,
	callback = function()
		local line = vim.fn.line(".")
		if line == last_line then
			return
		end
		last_line = line

		local view = vim.fn.winsaveview()
		vim.cmd("normal! zz")
		view.topline = vim.fn.winsaveview().topline
		vim.fn.winrestview(view)
	end,
})
