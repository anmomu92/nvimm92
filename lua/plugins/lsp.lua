return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre", -- Lazy-load when a file is opened
		config = function()
			-- Basic LSP setup
			require("config.lspconfig")
		end,
	},
}
