return {
	{
		"saghen/blink.cmp",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"Kaiser-Yang/blink-cmp-avante",
			"giuxtaposition/blink-cmp-copilot",
		},
		version = "*",
		opts = {
			enabled = function()
				local disabled_filetypes = { -- Disable blink
					"markdown",
					"text",
					"Avante",
					"AvanteSelectedFiles",
					"AvantePromptInput",
					"dapui_watches",
				}

				if
					vim.bo.buftype ~= "prompt"
					and vim.b.completion ~= false
					and not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
				then
					return true
				else
					return false
				end
			end,
			keymap = {
				preset = "super-tab",
				["<Tab>"] = {
					"snippet_forward",
					"accept",
					"select_and_accept",
					"fallback",
				},
			},
			appearance = {
				nerd_font_variant = "normal",
				kind_icons = {
					Copilot = "",
					Text = "",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒓",
					Field = "",
					Variable = "",
					Class = "",
					Interface = "",
					Module = "",
					Property = "",
					Unit = "",
					Value = "󰦨",
					Enum = "󰦨",
					Keyword = "",
					Snippet = "",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "󰦨",
					Constant = "󰏿",
					Struct = "",
					Event = "",
					Operator = "",
					TypeParameter = "",
				},
			},
			completion = {
				list = {
					selection = {
						auto_insert = false,
					},
				},
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", "kind", "label_description", gap = 1 } },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
				},
			},
			signature = {
				enabled = true,
			},
			cmdline = {
				keymap = { preset = "inherit" },
				sources = function()
					local cmd_type = vim.fn.getcmdtype()
					if cmd_type == ":" then
						return { "cmdline", "buffer" }
					else
						return {}
					end
				end,
				completion = {
					list = {
						selection = {
							auto_insert = false,
						},
					},
				},
			},
			sources = {
				default = { "avante", "copilot", "lsp", "path", "snippets", "buffer" },
				providers = {
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
					},
					copilot = {
						module = "blink-cmp-copilot",
						name = "copilot",
						async = true,
					},
				},
			},
			fuzzy = {
				sorts = {
					"exact",
					"score",
					"sort_text",
				},
			},
		},
	},
}
