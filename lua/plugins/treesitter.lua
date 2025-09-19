return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		branch = "master",
		build = ":TSUpdate",
		opts = {
			sync_install = false,
			auto_install = false,
			ensure_installed = {
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"lua",
				"luadoc",
				"regex",
				"json",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"htmldjango",
				"css",
				"xml",
				"dockerfile",
				"prisma",
				"gitignore",
				"python",
				"yaml",
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = require("config.keymaps").treesitterKeys,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			local treesitter_folding_augroup =
				vim.api.nvim_create_augroup("TreesitterFolding", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = treesitter_folding_augroup,
				desc = "Enable Folding for current window",
				pattern = { -- Languages to enable folding
					"lua",
					"json",
					"typescriptreact",
					"javascript",
					"typescript",
					"html",
					"css",
					"prisma",
					"python",
				},
				callback = function()
					vim.opt.foldmethod = "expr"
					vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.opt.foldlevelstart = 99
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			max_lines = 3,
			on_attach = function(buf)
				local disable_filetypes = { "text", "markdown" }
				if vim.tbl_contains(disable_filetypes, vim.bo[buf].filetype) then
					return false
				end
				return true
			end,
			line_numbers = false,
		},
	},
}
