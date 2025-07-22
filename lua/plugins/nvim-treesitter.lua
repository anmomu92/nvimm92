return {
	  'nvim-treesitter/nvim-treesitter',
	  lazy = false,
	  branch = 'master',
	  build = ':TSUpdate',
	  config = function()
		require('config/nvim-treesitter')
	  end
	}
