local mason_nvim_lint = require("mason-nvim-lint")

mason_nvim_lint.setup({
	ensure_installed = { 'luacheck' },
})

return mason_nvim_lint
