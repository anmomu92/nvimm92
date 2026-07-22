require("render-markdown").setup({
	latex = {
		enabled = true,
		-- injections = false,
		render_modes = false,
		converter = { "utftex", "latex2text" },
		inline = true,
		block = true,
		highlight = "RenderMarkdownMath",
		position = "center",
		top_pad = 0,
		bottom_pad = 0,
	},
})
