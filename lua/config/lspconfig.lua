vim.lsp.config('lua_ls', {
  -- Server-specific settings. See `:help lsp-quickstart`
  filetypes = { 'lua' },
  settings = {
	Lua = {
		diagnostics = {
			enable = false,
		},
	},
    ['lua_ls'] = {},
  },
})

vim.lsp.config('clangd', {
	filetypes = { 'c', 'cpp' },
	settings = {
		['clangd'] = {},
	},
})

vim.lsp.config('verible', {
})

vim.lsp.config('svls', {
})
