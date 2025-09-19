return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre", -- Lazy-load when a file is opened
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",             -- Optional: For LSP-powered autocompletion
	  "hrsh7th/nvim-cmp",
    },
    config = function()
      -- Basic LSP setup
      require("config.lspconfig")
    end,
  },
}
