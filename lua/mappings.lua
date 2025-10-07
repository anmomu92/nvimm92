local map = vim.keymap.set
local api = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=false }

local builtin = require('telescope.builtin')
local zk = require('zk')
local commands = require("zk.commands")
local tema = require('func.tema')
local diagnostico = require('func.diagnostico')
local tasks = require('func.tasks')
local Terminal  = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local taskwarrior_tui = Terminal:new({ cmd = "taskwarrior-tui", direction = "float", hidden = true })

-- Functions
function _lazygit_toggle()
  lazygit:toggle()
end

function _taskwarrior_toggle()
	taskwarrior_tui:toggle()
end

local function make_edit_fn(defaults, picker_options)
	return function(options)
		options = vim.tbl_extend("force", defaults, options or {})
		zk.edit(options, picker_options)
	end
end

-- Commands
commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
commands.add("ZkRecents", make_edit_fn({ createdAfter = "2 weeks ago" }, { title = "Zk Recents" }))

-- +++++ Insert mode +++++
map('i', "jk", "<ESC>")
map('i', "<C-h>", "<Left>", { noremap = true, silent = true })
map('i', "<C-l>", "<Right>", { noremap = true, silent = true })


-- +++++ Normal mode +++++
map('n', ';', ':', { noremap = true, silent = true, desc = "Enter command mode" })
map('n', '<ESC>', '<cmd>q<CR>', { noremap = true, silent = true, desc = "Exit nvim" })
map('n', '<TAB>', '<cmd>bn<CR>', { noremap = true, silent = true, desc = "Go to next buffer" })
map('n', '<S-TAB>', '<cmd>bp<CR>', { noremap = true, silent = true, desc = "Go to previous buffer" })
map('n', '<leader>bb', '<cmd>bd<CR>', { noremap = true, silent = true, desc = "Delete current buffer" })

map("n", "<A-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = "Open lazygit" })
map("n", "<A-t>", "<cmd>lua _taskwarrior_toggle()<CR>", { noremap = true, silent = true, desc = "Open taskwarrior-tui" })
map("n", "<A-j>", "<cmd>ToggleTerm direction=horizontal<cr>", { noremap = true, silent = true, desc = "Open terminal at bottom" })
map("n", "<A-l>", "<cmd>ToggleTerm direction=vertical size=50<cr>", { noremap = true, silent = true, desc = "Open terminal at right" })


-- Navigation
map('n', '<A-1>', '<cmd>BufferGoto 1<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 1" }))
map('n', '<A-2>', '<cmd>BufferGoto 2<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 2" }))
map('n', '<A-3>', '<cmd>BufferGoto 3<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 3" }))
map('n', '<A-4>', '<cmd>BufferGoto 4<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 4" }))
map('n', '<A-5>', '<cmd>BufferGoto 5<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 5" }))
map('n', '<A-6>', '<cmd>BufferGoto 6<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 6" }))
map('n', '<A-7>', '<cmd>BufferGoto 7<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 7" }))
map('n', '<A-8>', '<cmd>BufferGoto 8<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 8" }))
map('n', '<A-9>', '<cmd>BufferGoto 9<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 9" }))
map('n', '<A-0>', '<cmd>BufferGoto 0<CR>', vim.tbl_extend("force", opts, { desc = "Go to buffer 10" }))

map('n', "<leader>tt", tema.SwitchTheme, { desc = "Switch theme", noremap = true })
map('n', "<leader>tv", diagnostico.SwitchVirtualLines, { desc = 'Toggle virtual lines' })
-- map('n', "<leader>at", tasks.UpdateTasks, { desc = 'Update tasks' })

-- Telescope
map('n', "<leader>ff", builtin.find_files, { desc = 'Telescope find files' })
map('n', "<leader>fg", builtin.live_grep, { desc = 'Telescope live grep' })
map('n', "<leader>fb", builtin.buffers, { desc = 'Telescope buffers' })
map('n', "<leader>fh", builtin.help_tags, { desc = 'Telescope help tags' })

-- +++++ Any mode +++++
map({ 'n', 'i', 'v' }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map({ 'n', 'i', 'v' }, "<A-n>", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer" })

-- Navigation
map({ 'n', 'v' }, "<C-l>", "<C-W>l", { desc = "Move to right window" })
map({ 'n', 'v' }, "<C-h>", "<C-W>h", { desc = "Move to left window" })
map({ 'n', 'v' }, "<C-j>", "<C-W>j", { desc = "Move to lower window" })
map({ 'n', 'v' }, "<C-k>", "<C-W>k", { desc = "Move to upper window" })

map({ 'n', 'v' }, "<C-A-l>", "<C-W>>", { desc = "Increase window width" })
map({ 'n', 'v' }, "<C-A-h>", "<C-W><", { desc = "Decrease window width" })
map({ 'n', 'v' }, "<C-A-k>", "<C-W>+", { desc = "Increase window height" })
map({ 'n', 'v' }, "<C-A-j>", "<C-W>-", { desc = "Decrease window height" })

-- +++++ Modo terminal +++++
-- map('t', "<leader>q", "<C-\\><C-n>")
map('t', "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })
map('t', "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
map('t', "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to lower window" })
map('t', "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to upper window" })

map('t', "<C-A-l>", "<C-\\><C-n><C-w>>", { desc = "Increase window width" })
map('t', "<C-A-h>", "<C-\\><C-n><C-w><", { desc = "Decrease window width" })
map('t', "<C-A-j>", "<C-\\><C-n><C-w>-", { desc = "Increase window height" })
map('t', "<C-A-k>", "<C-\\><C-n><C-w>+", { desc = "Decrease window height" })


-- +++++ zk +++++
-- Create a new note after asking for its title.
api("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", vim.tbl_extend("force", opts, { desc = "Create new note" }))

-- Open notes.
api("n", "<leader>zon", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", vim.tbl_extend("force", opts, { desc = "Open notes" }))
-- Open notes associated with the selected tags.
api("n", "<leader>zt", "<Cmd>ZkTags<CR>", vim.tbl_extend("force", opts, { desc = "Open notes associated with the selected tags" }))

-- Search for the notes matching a given query.
api("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", vim.tbl_extend("force", opts, { desc = "Search notes matching a given query" }))
-- Search for the notes matching the current visual selection.
api("v", "<leader>zf", ":'<,'>ZkMatch<CR>", vim.tbl_extend("force", opts, { desc = "Search notes matching the current visual selection" }))

-- Show orphan notes
api("n", "<leader>zox", "<Cmd>ZkOrphans<CR>", vim.tbl_extend("force", opts, { desc = "Open orphan notes" }))
-- Show orphan notes
api("n", "<leader>zor", "<Cmd>ZkRecents<CR>", vim.tbl_extend("force", opts, { desc = "Open recent notes" }))
