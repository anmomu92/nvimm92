-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
  local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
  local opts = { noremap=true, silent=false }

  -- Open the link under the caret.
  map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", vim.tbl_extend("force", opts, { desc = "Open the link under the caret" }))

  -- Create a new note after asking for its title.
  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", vim.tbl_extend("force", opts, { desc = "Create new note" }))
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", vim.tbl_extend("force", opts, { desc = "Create new note using selection for title in same dir as current buffer" }))
  map("v", "vawt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", vim.tbl_extend("force", opts, { desc = "Create new note using selection for title in same dir as current buffer" }))
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map("v", "<leader>znc", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", vim.tbl_extend("force", opts, { desc = "Create new note using selection for content in same dir as current buffer" }))
  map("v", "vawc", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", vim.tbl_extend("force", opts, { desc = "Create new note using selection for content in same dir as current buffer" }))

  -- Open notes linking to the current buffer.
  map("n", "<leader>zob", "<Cmd>ZkBacklinks<CR>", vim.tbl_extend("force", opts, { desc = "Open notes linking to the current buffer" }))
  -- Alternative for backlinks using pure LSP and showing the source context.
  --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Open notes linked by the current buffer.
  map("n", "<leader>zol", "<Cmd>ZkLinks<CR>", vim.tbl_extend("force", opts, { desc = "Open notes linked by the current buffer" }))

  -- Insert a link at current position
  map("n", "<leader>zl", "<Cmd>ZkInsertLink<CR>", vim.tbl_extend("force", opts, { desc = "Insert link" }))
  -- Insert a link around selected text
  map("v", "<leader>zl", ":'<,'>ZkInsertLinkAtSelection { matchSelected = true }<CR>", vim.tbl_extend("force", opts, { desc = "Insert link around selected text" }))

  -- Preview a linked note.
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", vim.tbl_extend("force", opts, { desc = "Preview a linked note" }))
  -- Open the code actions for a visual selection.
  map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", vim.tbl_extend("force", opts, { desc = "Open the code actions for a visual selection" }))
end
