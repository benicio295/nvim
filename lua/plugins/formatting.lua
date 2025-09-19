return {
	{
		"stevearc/conform.nvim",
		cmd = "ConformInfo",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier", "mdformat" },
				yaml = { "prettier" },
			},
			default_format_opts = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			formatters = {
				stylua = {
					inherit = true,
					prepend_args = {
						"--syntax",
						"LuaJIT",
						"--column-width",
						"112",
						"--indent-width",
						"5",
					},
				},
			},
		},
		keys = require("config.keymaps").conformKeys,
	},
}
