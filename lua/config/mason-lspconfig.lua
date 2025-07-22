local mason_lspconfig = require("mason-lspconfig")
local lsp = vim.lsp
local map = vim.keymap.set

mason_lspconfig.setup({
  ensure_installed = {
    "pyright",
    "lua_ls",
	"clangd",
	"verible",
	"svls",
	"bashls",
	"html",
	-- "hyprls",
    -- Add more language servers here
  },
  -- automatic_installation = true,
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  map("n", "gd", lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
  map("n", "K", lsp.buf.hover, { buffer = bufnr, desc = "Show Documentation" })
end

-- Automatically set up each server with default config
mason_lspconfig.setup({
	handle = function(name)
		lsp.enable(name)
		lsp.config(name, {
			capabilities = capabilities,
		})
	end,
})

return mason_lspconfig
