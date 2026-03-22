return {
	-- mason.nvim
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
	-- mason-lspconfig.nvim
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
		  require("config.mason-lspconfig")
		end,
	},
	-- nvim-lint
	{
		'mfussenegger/nvim-lint',
		opts = {
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		},
		config = function()
			require("config/nvim-lint")
		end
	},
	-- mason-nvim-lint
	{
		"rshkarin/mason-nvim-lint",
	},
}
