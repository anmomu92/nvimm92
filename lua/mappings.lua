local map = vim.keymap.set
local builtin = require('telescope.builtin')
local tema = require('func.tema')
local diagnostico = require('func.diagnostico')
local tareas = require('func.tareas')
local Terminal  = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

-- Functions
function _lazygit_toggle()
  lazygit:toggle()
end

-- +++++ Modo inserción +++++
map('i', "jk", "<ESC>")
map('i', "<C-h>", "<Left>", { noremap = true, silent = true })
map('i', "<C-l>", "<Right>", { noremap = true, silent = true })

-- +++++ Modo normal +++++
map('n', ';', ':', { desc = "Entrar en modo comando" })
map('n', '<ESC>', '<cmd>q<CR>', { noremap = true, silent = true, desc = "Salir del búfer" })
map('n', '<TAB>', '<cmd>bn<CR>', { noremap = true, silent = true, desc = "Ir a siguiente búfer" })
map('n', '<S-TAB>', '<cmd>bp<CR>', { desc = "Ir a anterior búfer" })
map('n', '<leader>bb', '<cmd>bd<CR>', { desc = "Borrar búfer" })
map("n", "<A-g>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
map("n", "<A-j>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true })
map("n", "<A-l>", "<cmd>ToggleTerm direction=vertical size=50<cr>", { noremap = true, silent = true })



-- Navegación
map('n', '<A-1>', '<cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<cmd>BufferGoto 0<CR>', opts)

map('n', "<leader>tt", tema.AlternaTema, { desc = "Alternar tema", noremap = true })
map('n', "<leader>tv", diagnostico.AlternaLineasVirtuales, { desc = 'Alternar líneas virtuales' })
-- map('n', "<leader>at", tareas.ActualizaTareas, { desc = 'Actualizar tareas' })

-- Telescope
map('n', "<leader>ff", builtin.find_files, { desc = 'Telescope find files' })
map('n', "<leader>fg", builtin.live_grep, { desc = 'Telescope live grep' })
map('n', "<leader>fb", builtin.buffers, { desc = 'Telescope buffers' })
map('n', "<leader>fh", builtin.help_tags, { desc = 'Telescope help tags' })

-- +++++ Todos los modos +++++
map({ 'n', 'i', 'v' }, "<C-s>", "<cmd>w<CR>", { desc = "Guardar el fichero" })
map({ 'n', 'i', 'v' }, "<A-n>", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Alternar explorador" })

-- Navegación
map({ 'n', 'v' }, "<C-l>", "<C-W>l")
map({ 'n', 'v' }, "<C-h>", "<C-W>h")
map({ 'n', 'v' }, "<C-j>", "<C-W>j")
map({ 'n', 'v' }, "<C-k>", "<C-W>k")

map({ 'n', 'v' }, "<C-A-l>", "<C-W>>")
map({ 'n', 'v' }, "<C-A-h>", "<C-W><")
map({ 'n', 'v' }, "<C-A-j>", "<C-W>-")
map({ 'n', 'v' }, "<C-A-k>", "<C-W>+")

-- +++++ Modo terminal +++++
-- map('t', "<leader>q", "<C-\\><C-n>")
map('t', "<C-l>", "<C-\\><C-n><C-w>l")
map('t', "<C-h>", "<C-\\><C-n><C-w>h")
map('t', "<C-j>", "<C-\\><C-n><C-w>j")
map('t', "<C-k>", "<C-\\><C-n><C-w>k")

map('t', "<C-A-l>", "<C-\\><C-n><C-w>>")
map('t', "<C-A-h>", "<C-\\><C-n><C-w><")
map('t', "<C-A-j>", "<C-\\><C-n><C-w>-")
map('t', "<C-A-k>", "<C-\\><C-n><C-w>+")
