return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
		  require("config.mason-lspconfig")
		end,
	},
}
