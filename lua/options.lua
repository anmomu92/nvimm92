-- local o = vim.o
local o = vim.o
local g = vim.g
local d = vim.diagnostic

-- Line numbers
o.number = true
o.numberwidth = 4

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- python
g.python3_host_prog = "/usr/bin/python3"

-- Folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldenable = false
o.foldlevel = 0
o.foldlevelstart = 0

-- disable netrw at the very start of your init.lua
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
o.termguicolors = true
o.undofile = true

-- Syntax
--o.syntax = "on"

-- Appearance
--o.wrapmargin = 4
o.linebreak = true
o.title = true


-- Controlar el texto virtual que aparece en el diagnóstico
d.config({ virtual_text = false })
