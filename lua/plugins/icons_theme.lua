return {
	{
		"echasnovski/mini.icons",
		lazy = true,
		version = false,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				blink_cmp = {
					style = "bordered",
				},
				dap = true,
				dap_ui = true,
				flash = true,
				gitsigns = {
					enabled = true,
					transparent = false,
				},
				mason = true,
				mini = true,
				render_markdown = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				treesitter = true,
				treesitter_context = true,
				snacks = {
					enabled = true,
				},
				lsp_trouble = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
}
