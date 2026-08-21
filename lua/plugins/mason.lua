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
					package_uninstalled = "✗",
				},
			},
		},
	},
	-- mason-lspconfig.nvim
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "pyright", "lua_ls", "gopls", "ts_ls", "verible", "svls", "bashls", "html" },
			-- automatic_enable = true is the v2 default
		},
	},

	-- nvim-lint
	{
		"mfussenegger/nvim-lint",
		opts = {
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		},
		config = function()
			require("config.nvim-lint")
		end,
	},
	-- mason-nvim-lint
	{
		"rshkarin/mason-nvim-lint",
		config = function()
			require("config.mason-nvim-lint")
		end,
	},
}
