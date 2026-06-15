local map = vim.keymap.set
local api = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = false }

-- IMPORTS
local builtin = require("telescope.builtin")
local zk = require("zk")
local commands = require("zk.commands")
local tema = require("func.tema")
local diagnostico = require("func.diagnostico")
local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local taskwarrior_tui = Terminal:new({ cmd = "taskwarrior-tui", direction = "float", hidden = true })

-- FUNCTIONS
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

-- COMMANDS
commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
commands.add("ZkRecents", make_edit_fn({ createdAfter = "2 weeks ago" }, { title = "Zk Recents" }))

-- -----------
-- Insert mode
-- -----------
map("i", "jk", "<ESC>")
map("i", "<C-h>", "<Left>", { noremap = true, silent = true })
map("i", "<C-l>", "<Right>", { noremap = true, silent = true })

-- -----------
-- Normal mode
-- -----------
-- navigation
map("n", ";", ":", { noremap = true, silent = true, desc = "Enter command mode" })
map("n", "<ESC>", "<cmd>q<CR>", { noremap = true, silent = true, desc = "Exit nvim" })
map("n", "<TAB>", "<cmd>bn<CR>", { noremap = true, silent = true, desc = "Go to next buffer" })
map("n", "<S-TAB>", "<cmd>bp<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })

-- panels and windows
map("n", "<A-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true, desc = "Open lazygit" })
map(
	"n",
	"<A-t>",
	"<cmd>lua _taskwarrior_toggle()<CR>",
	{ noremap = true, silent = true, desc = "Open taskwarrior-tui" }
)
map(
	"n",
	"<A-j>",
	"<cmd>ToggleTerm direction=horizontal<cr>",
	{ noremap = true, silent = true, desc = "Open terminal at bottom" }
)
map(
	"n",
	"<A-l>",
	"<cmd>ToggleTerm direction=vertical size=50<cr>",
	{ noremap = true, silent = true, desc = "Open terminal at right" }
)

-- files and buffers
map("n", "<leader>db", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Delete current buffer" })
map("n", "<leader>df", function()
	local file = vim.fn.expand("%")
	if vim.fn.confirm("Delete file?\n" .. file, "&Yes\n&No", 2) == 1 then
		vim.fn.delete(file)
		vim.cmd("bdelete!")
	end
end, { desc = "Delete current file and buffer" })

-- toggles
map("n", "<leader>tt", tema.SwitchTheme, { desc = "Switch theme", noremap = true })
map("n", "<leader>tv", diagnostico.SwitchVirtualLines, { desc = "Toggle virtual lines" })

-- editing
map("n", "<leader>zw", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.fn.col(".") -- 1-based

	local found = false
	local new_line = line:gsub("()%[%[[^%]]-%]%]()", function(start_pos, end_pos)
		-- start_pos/end_pos are 1-based.
		-- end_pos points just after the match.
		if col >= start_pos and col < end_pos then
			found = true
			return "[{" .. line:sub(start_pos + 1, end_pos - 2) .. "}]"
		end
	end, 1)

	if found then
		vim.api.nvim_set_current_line(new_line)
	else
		vim.notify("Cursor is not on a [[...]] link", vim.log.levels.WARN)
	end
end, { desc = "Wrap [[...]] in braces" })

map("n", "<leader>zu", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.fn.col(".") -- 1-based

	local found = false
	local new_line = line:gsub("()%[%{%[[^%]]-%]%}%]()", function(start_pos, end_pos)
		if col >= start_pos and col < end_pos then
			found = true
			return "[" .. line:sub(start_pos + 2, end_pos - 3) .. "]"
		end
	end, 1)

	if found then
		vim.api.nvim_set_current_line(new_line)
	else
		vim.notify("Cursor is not on a {[[...]]} link", vim.log.levels.WARN)
	end
end, { desc = "Remove braces from {[[...]]}" })

-- -------------
-- Terminal mode
-- -------------
-- map('t', "<leader>q", "<C-\\><C-n>")
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to upper window" })

map("t", "<C-A-l>", "<C-\\><C-n><C-w>>", { desc = "Increase window width" })
map("t", "<C-A-h>", "<C-\\><C-n><C-w><", { desc = "Decrease window width" })
map("t", "<C-A-j>", "<C-\\><C-n><C-w>-", { desc = "Increase window height" })
map("t", "<C-A-k>", "<C-\\><C-n><C-w>+", { desc = "Decrease window height" })

-- --------------
-- Multiple modes
-- --------------
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map({ "n", "i", "v" }, "<A-n>", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer" })

-- Navigation
map({ "n", "v" }, "<C-l>", "<C-W>l", { desc = "Move to right window" })
map({ "n", "v" }, "<C-h>", "<C-W>h", { desc = "Move to left window" })
map({ "n", "v" }, "<C-j>", "<C-W>j", { desc = "Move to lower window" })
map({ "n", "v" }, "<C-k>", "<C-W>k", { desc = "Move to upper window" })

map({ "n", "v" }, "<C-A-l>", "<C-W>>", { desc = "Increase window width" })
map({ "n", "v" }, "<C-A-h>", "<C-W><", { desc = "Decrease window width" })
map({ "n", "v" }, "<C-A-k>", "<C-W>+", { desc = "Increase window height" })
map({ "n", "v" }, "<C-A-j>", "<C-W>-", { desc = "Decrease window height" })

-- ---------
-- Telescope
-- ---------
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- ---------------
-- zk
-- ---------------
-- Create a new note after asking for its title.
api(
	"n",
	"<leader>zn",
	"<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
	vim.tbl_extend("force", opts, { desc = "Create new note" })
)

-- Open notes.
api(
	"n",
	"<leader>zon",
	"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
	vim.tbl_extend("force", opts, { desc = "Open notes" })
)
-- Open notes associated with the selected tags.
api(
	"n",
	"<leader>zt",
	"<Cmd>ZkTags<CR>",
	vim.tbl_extend("force", opts, { desc = "Open notes associated with the selected tags" })
)

-- Search for the notes matching a given query.
api(
	"n",
	"<leader>zf",
	"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
	vim.tbl_extend("force", opts, { desc = "Search notes matching a given query" })
)
-- Search for the notes matching the current visual selection.
api(
	"v",
	"<leader>zf",
	":'<,'>ZkMatch<CR>",
	vim.tbl_extend("force", opts, { desc = "Search notes matching the current visual selection" })
)

-- Show orphan notes
api("n", "<leader>zox", "<Cmd>ZkOrphans<CR>", vim.tbl_extend("force", opts, { desc = "Open orphan notes" }))
-- Show recent notes
api("n", "<leader>zor", "<Cmd>ZkRecents<CR>", vim.tbl_extend("force", opts, { desc = "Open recent notes" }))

-- ---------------
-- barbar
-- ---------------
-- Move to previous/next
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)

-- Re-order to previous/next
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)

-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)

-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
map("n", "<C-s-p>", "<Cmd>BufferPickDelete<CR>", opts)

-- Sort automatically by...
map("n", "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
map("n", "<leader>bn", "<Cmd>BufferOrderByName<CR>", opts)
map("n", "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
map("n", "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
map("n", "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
