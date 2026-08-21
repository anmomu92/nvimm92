local mason_nvim_lint = require("mason-nvim-lint")

mason_nvim_lint.setup({
	ensure_installed = { "luacheck" },
	automatic_installation = true,
})

return mason_nvim_lint
