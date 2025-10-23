return {
	{
		"zbirenbaum/copilot.lua",
		event = "BufReadPost",
		build = ":Copilot auth",
		opts = {
			panel = {
				enabled = false,
			},
			filetypes = {
				markdown = false,
				text = false,
				AvanteInput = false,
				Avante = false,
				AvanteSelectedFiles = false,
				AvantePromptInput = false,
				dapui_watches = false,
				["*"] = true,
			},
			suggestion = {
				auto_trigger = true,
				hide_during_completion = true,
				keymap = require("config.keymaps").copilotKeys,
			},
			should_attach = function(_, bufname)
				if string.match(bufname, "%.env") then
					return false
				end
				return true
			end,
		},
	},
	{
		"Kaiser-Yang/blink-cmp-avante",
		lazy = true,
	},
	{
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "BufReadPost",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			"HakonHarnes/img-clip.nvim",
		},
		opts = {
			instructions_file = "avante.md",
			provider = "copilot",
			auto_suggestions_provider = nil,
			providers = {
				copilot = {
					model = "gpt-5-mini",
				},
			},
			repo_map = {
				ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules" },
			},
			selector = {
				provider = "snacks",
			},
			behaviour = {
				support_paste_from_clipboard = true,
				auto_suggestions = false,
				auto_set_keymaps = true,
			},
			slash_commands = {},
			shortcuts = {},
			windows = {
				edit = {
					border = "solid",
				},
				ask = {
					border = "solid",
				},
				input = {
					height = 12,
				},
			},
			prompt_logger = require("config.keymaps").avanteKeys.prompt_logger,
			mappings = require("config.keymaps").avanteKeys.mappings,
			selection = {
				hint_display = "immediate",
			},
		},
		keys = require("config.keymaps").avanteKeys.keys,
	},
}
