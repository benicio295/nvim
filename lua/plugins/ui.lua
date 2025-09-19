return {
	{
		"akinsho/bufferline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		version = "*",
		opts = function()
			return {
				options = {
					show_close_icon = false,
					show_buffer_close_icons = false,
					modified_icon = "+",
					numbers = "ordinal",
					style_preset = require("bufferline").style_preset.default,
					themable = true,
					diagnostics = false,
					close_command = function(n)
						Snacks.bufdelete(n)
					end,
					right_mouse_command = function(n)
						Snacks.bufdelete(n)
					end,
					indicator = {
						style = "underline",
					},
					offsets = {
						{
							filetype = "snacks_layout_box",
							text = "Explorer",
							separator = true,
						},
						{
							filetype = "gitsigns-blame",
							text = "Blame",
							separator = true,
						},
					},
				},
				highlights = require("catppuccin.groups.integrations.bufferline").get_theme({
					styles = { "italic", "bold" },
					custom = {
						all = {
							buffer_visible = {
								fg = "#ffffff",
							},
						},
					},
				}),
			}
		end,
		keys = require("config.keymaps").bufferlineKeys,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},
				lualine_c = {
					{
						"filename",
						path = 4,
						symbols = { modified = "[Modified]", readonly = "[Readonly]", unnamed = "" },
					},
				},
				lualine_x = {
					function()
						local lsps = vim.lsp.get_clients({ bufnr = 0 })
						if #lsps == 0 then
							return "NO LSP"
						end
						local client_names = {}
						for _, client in ipairs(lsps) do
							table.insert(client_names, client.name)
						end
						return table.concat(client_names, ", ")
					end,
					"filetype",
				},
				lualine_y = { "location" },
				lualine_z = {
					"progress",
				},
			},
			extensions = { "lazy" },
			options = {
				theme = "catppuccin",
				globalstatus = true,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {
						"snacks_dashboard",
						"checkhealth",
						"snacks_picker_input",
						"lazy",
						"mason",
					},
				},
			},
		},
	},
	{
		"folke/edgy.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			close_when_all_hidden = false,
			animate = {
				enabled = false,
			},
			bottom = {
				{
					ft = "snacks_terminal",
					size = { height = 0.32 },
					title = "Terminal-%{b:snacks_terminal.id}",
					filter = function(_, win)
						return vim.w[win].snacks_win
							and vim.w[win].snacks_win.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				},
				{
					ft = "trouble",
					size = { height = 0.2, width = 0.38 },
					title = "Trouble",
					filter = function(_, win)
						return vim.w[win].trouble
							and vim.w[win].trouble.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				},
				{
					ft = "qf",
					title = "QuickFix",
				},
			},
		},
		keys = require("config.keymaps").uiEdgyKeys,
	},
	{
		-- deps for avante
		"MunifTanjim/nui.nvim",
		lazy = true,
	},

	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			explorer = {
				enabled = true,
			},
			picker = {
				enabled = true,
				sources = {
					explorer = {
						auto_close = true,
						diagnostics = false,
						tree = true,
						git_status = true,
						git_status_open = true,
						git_untracked = true,
						matcher = {
							fuzzy = true,
						},
						layout = {
							preview = true,
							auto_hide = { "input" },
						},
						win = {
							list = {
								keys = require("config.keymaps").uiPickerExplorerKeys,
							},
						},
					},
					files = {
						exclude = {
							".git",
							".svn",
							".hg",
							"node_modules",
							"vendor",
							"venv",
							".venv",
							"__pycache__",
							"deps",
							".gradle",
							"target",
							"dist",
							"build",
							"out",
							"bin",
							"obj",
							".DS_Store",
							"Thumbs.db",
							".vscode",
							".idea",
							".next",
						},
					},
					projects = {
						patterns = {
							".git",
							"_darcs",
							".hg",
							".bzr",
							".svn",
							"package.json",
							"requirements.txt",
							".venv",
							"venv",
						},
					},
				},
			},
			terminal = {
				enabled = true,
				shell = "fish",
			},
			dashboard = {
				enabled = true,
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
					{ section = "keys", gap = 1, padding = 1 },
				},
				preset = {
					keys = {
						{
							icon = " ",
							key = "o",
							desc = "Open Project",
							action = function()
								Snacks.picker.projects({
									dev = { "~/Documents/Projetos", "~/Documents/Projetos/estudos" },
									recent = false,
								})
							end,
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{
							icon = "󰄬 ",
							key = "h",
							desc = "Health Check",
							action = function()
								local plugin =
									vim.fn.input("Plugin name (leave it empty for everyone): ")
								if plugin and plugin ~= "" then
									vim.cmd("checkhealth " .. plugin)
								else
									vim.cmd("checkhealth")
								end
							end,
						},
						{ icon = "󰒲 ", key = "l", desc = "Lazy Plugins", action = ":Lazy" },
						{ icon = "󰏕 ", key = "m", desc = "Mason Package Manager", action = ":Mason" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				},
			},
		},
		keys = require("config.keymaps").uiSnacksKeys,
	},
}
