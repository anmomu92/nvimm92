return {
	'mfussenegger/nvim-lint',
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	},
	config = function()
		require("config/nvim-lint")
	end
}
