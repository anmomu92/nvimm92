local cmp = require('cmp')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	enabled = function()
		local disabled = false
		disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
		disabled = disabled or (vim.fn.reg_recording() ~= '')
		disabled = disabled or (vim.fn.reg_executing() ~= '')
		disabled = disabled or require('cmp.config.context').in_treesitter_capture('comment')
		return not disabled
	end,
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
		require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
	  ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
	  ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      -- { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
})

return cmp
