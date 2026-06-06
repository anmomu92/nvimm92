require('nvim-treesitter.configs').setup {
  ensure_installed = { 
	  "html",
	  "markdown", 
	  "markdown_inline",
	  "latex",
  },
  highlight = {
    enable = true,
	additional_vim_regex_highlighting = { "markdown" },
  },
}
