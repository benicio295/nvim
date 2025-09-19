---@diagnostic disable: undefined-field
return {
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		config = function()
			local lsp = vim.lsp
			local diagnostic = vim.diagnostic
			local api = vim.api

			api.nvim_create_autocmd("LspAttach", {
				group = api.nvim_create_augroup("keymaps_lsp", { clear = true }),
				desc = "When LSP attach add LSP Keymaps",
				callback = function(args)
					require("config.keymaps").lspKeys(args.buf)
				end,
			})

			local diagnostic_icons = {
				[diagnostic.severity.ERROR] = "",
				[diagnostic.severity.WARN] = "",
				[diagnostic.severity.HINT] = "",
				[diagnostic.severity.INFO] = "",
			}

			diagnostic.config({
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = false,
					prefix = "",
				},
				severity_sort = true,
				signs = {
					text = diagnostic_icons,
				},
			})

			lsp.config("*", {
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},
			})

			lsp.config("ts_ls", {
				before_init = function(params, _)
					if params.capabilities and params.capabilities.textDocument then
						params.capabilities.textDocument.publishDiagnostics = false
					end
				end,
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			})

			lsp.config("cssls", {
				settings = {
					css = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			local docker_compose_augroup = api.nvim_create_augroup("LspDockerCompose", { clear = true })
			api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				group = docker_compose_augroup,
				desc = "Run LSP properly docker_compose_language_service when open compose",
				pattern = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },
				callback = function()
					vim.bo.filetype = "yaml.docker-compose"
				end,
			})

			-- NOTE: if you use UV, you need install/update/uninstall Ruff with UV. Open nvim with UV (uv run nvim) and open Mason normally
			vim.lsp.config("ruff", {
				init_options = {
					settings = {
						lineLength = 112,
					},
				},
			})

			lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (
								vim.uv.fs_stat(path .. "/.luarc.json")
								or vim.uv.fs_stat(path .. "/.luarc.jsonc")
							)
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
							},
						},
						diagnostics = {
							globals = { "vim", "Snacks" },
						},
						codeLens = {
							enable = true,
						},
						completion = {
							callSnippet = "Replace",
						},
						doc = {
							privateName = { "^_" },
						},
						format = {
							enable = false,
						},
						hint = {
							enable = true,
							arrayIndex = "Disable",
							semicolon = "Disable",
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})

			local codelens_augroup = api.nvim_create_augroup("LspCodeLensRefresh", { clear = true })
			api.nvim_create_autocmd("LspAttach", {
				group = codelens_augroup,
				desc = "When LSP Attach, get a client LSP and refresh codelens",
				callback = function(args)
					local client = lsp.get_client_by_id(args.data.client_id)
					if client and client:supports_method("textDocument/codeLens") then
						api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
							group = codelens_augroup,
							desc = "Refresh CodeLens on BufEnter, CursorHold, InsertLeave",
							buffer = args.buf,
							callback = function()
								lsp.codelens.refresh({ bufnr = args.buf })
							end,
						})
					end
				end,
			})

			local inlay_hint_augroup = api.nvim_create_augroup("LspInlayHint", { clear = true })
			api.nvim_create_autocmd("LspAttach", {
				group = inlay_hint_augroup,
				desc = "When LSP Attach, check if file is still open, not an terminal, plugins, etc and enable inlayhints",
				callback = function(args)
					local client = lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf
					if
						client
						and client:supports_method("textDocument/inlayHint")
						and api.nvim_buf_is_valid(bufnr)
						and vim.bo[bufnr].buftype == ""
					then
						lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"eslint",
				"jsonls",
				"html",
				"cssls",
				"tailwindcss",
				"css_variables",
				"cssmodules_ls",
				"lemminx",
				"marksman",
				"dockerls",
				"docker_compose_language_service",
				"yamlls",
				"gh_actions_ls",
				"prismals",
				"pyright",
				"ruff",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
