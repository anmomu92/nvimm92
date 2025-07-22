require('nvim-tree').setup({
	git = {
		ignore = false,
	},
	renderer = {
		highlight_git = true,
		highlight_diagnostics = true,
	},
	modified = {
		enable = true,
	}
})
