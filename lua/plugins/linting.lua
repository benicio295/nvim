return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			linters_by_ft = {
				html = { "htmlhint" },
			},
			linters = {
				-- EXAMPLE BELLOW
				-- eslint = {
				-- prepend_args = {"--settings1", "value"} -- prepend_args is created by me on config. Is not native
				-- }
			},
		},
		config = function(_, opts)
			local lint = require("lint")
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "TextChanged", "ModeChanged" }, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				desc = "Run linters",
				callback = function()
					local names = lint._resolve_linter_by_ft(vim.bo.filetype)
					if #names > 0 then
						lint.try_lint(names)
					end
				end,
			})
		end,
	},
}
