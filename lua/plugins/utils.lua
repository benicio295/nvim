return {
	{
		"folke/snacks.nvim",
		opts = {
			indent = {
				filter = function(buf)
					local disabled_filetypes = { -- languages to disable indent
						"markdown",
						"text",
						"AvanteSelectedFiles",
						"AvantePromptInput",
						"dapui_watches",
					}

					local current_filetype = vim.bo[buf].filetype
					if vim.tbl_contains(disabled_filetypes, current_filetype) then
						return false -- disable indent
					end
					return vim.g.snacks_indent ~= false
						and vim.b[buf].snacks_indent ~= false
						and vim.bo[buf].buftype == ""
				end,
				enabled = true,
				indent = {
					char = "┆",
					hl = {
						"HighlightDarkGreen",
						"HighlightDarkOrange",
						"HighlightDarkBlue",
						"HighlightDarkYellow",
						"HighlightDarkPurple",
						"HighlightDarkRed",
					},
				},
				scope = {
					enabled = true,
					underline = true,
					char = "┋",
					hl = {
						"HighlightGreen",
						"HighlightOrange",
						"HighlightBlue",
						"HighlightYellow",
						"HighlightPurple",
						"HighlightRed",
					},
				},
				animate = {
					enabled = false,
				},
			},
			bigfile = {
				enabled = true,
				size = 1 * 1024 * 1024,
				line_length = 800,
			},
			bufdelete = {
				enabled = true,
			},
			image = {
				enabled = true,
				doc = {
					inline = false,
					float = false,
				},
			},
			words = {
				enabled = true,
				debounce = 0,
			},
			scroll = {
				enabled = true,
				animate = {
					duration = { step = 15, total = 500 },
				},
				animate_repeat = {
					duration = { step = 5, total = 70 },
				},
			},
		},
		config = function(_, opts)
			vim.api.nvim_set_hl(0, "HighlightDarkGreen", { fg = "#006102" })
			vim.api.nvim_set_hl(0, "HighlightGreen", { fg = "#00C402" })
			vim.api.nvim_set_hl(0, "HighlightDarkOrange", { fg = "#614100" })
			vim.api.nvim_set_hl(0, "HighlightOrange", { fg = "#D49300" })
			vim.api.nvim_set_hl(0, "HighlightDarkBlue", { fg = "#004161" })
			vim.api.nvim_set_hl(0, "HighlightBlue", { fg = "#0094D6" })
			vim.api.nvim_set_hl(0, "HighlightDarkYellow", { fg = "#615900" })
			vim.api.nvim_set_hl(0, "HighlightYellow", { fg = "#BDAC00" })
			vim.api.nvim_set_hl(0, "HighlightDarkPurple", { fg = "#670096" })
			vim.api.nvim_set_hl(0, "HighlightPurple", { fg = "#A300EB" })
			vim.api.nvim_set_hl(0, "HighlightDarkRed", { fg = "#7D0000" })
			vim.api.nvim_set_hl(0, "HighlightRed", { fg = "#C70000" })
			require("snacks").setup(opts)
		end,
	},
	{
		"folke/flash.nvim",
		opts = {
			search = {
				exclude = {
					"snacks_picker_list",
					"AvantePromptInput",
				},
			},
			modes = {
				search = {
					enabled = false,
				},
			},
		},
		keys = require("config.keymaps").utilsFlashKeys,
	},
	{
		"folke/trouble.nvim",
		opts = {
			warn_no_results = false,
			open_no_results = true,
		},
		keys = require("config.keymaps").troubleKeys,
	},
	{
		"echasnovski/mini.move",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			mappings = require("config.keymaps").miniMoveKeys,
		},
	},
	{
		"echasnovski/mini.comment",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			mappings = require("config.keymaps").miniCommentKeys,
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_filetype = {
				"snacks_picker_input",
				"AvanteSelectedFiles",
				"Avante",
				"AvantePromptInput",
				"dapui_watches",
			},
			fast_wrap = {
				chars = { "{", "[", "(", '"', "'", "<" },
			},
		},
	},
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
		opts = {
			signs = false,
			keywords = {
				FIX = {
					icon = " ",
					color = "error",
					alt = { "FIXME", "BUG", "ISSUE" },
				},
				TODO = { icon = " ", color = "info" },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			},
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = require("config.keymaps").persistenceKeys,
	},
	{
		"rasulomaroff/reactive.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		ft = {
			"javascript",
			"typescript",
			"css",
			"html",
			"typescriptreact",
			"javascriptreact",
		},
		opts = {
			filetypes = {
				"javascript",
				"typescript",
				"css",
				"html",
				"typescriptreact",
				"javascriptreact",
			},
			user_commands = false,
			lazy_load = true,
			user_default_options = {
				css_fn = true,
				css = true,
				tailwind = "both",
				tailwind_opts = {
					update_names = true,
				},
				sass = { enable = true, parsers = { "css" } },
			},
		},
	},
	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			default = {
				dir_path = "assets-paste",
				prompt_for_file_name = false,
				drag_and_drop = {
					insert_mode = true,
				},
			},
		},
		keys = require("config.keymaps").imgClipKeys,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			file_types = { "markdown", "Avante" },
			sign = { enabled = false },
			heading = {
				icons = { " " },
				width = "block",
				min_width = 50,
				left_pad = 1,
				right_pad = 1,
			},
			code = {
				left_pad = 3,
				border = "thick",
			},
			checkbox = {
				custom = {
					important = {
						raw = "[~]",
						rendered = "󰓎 ",
						highlight = "DiagnosticWarn",
					},
				},
			},
		},
	},
}
