return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup()

					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
				keys = require("config.keymaps").dapUIKeys,
			},
		},
		config = function()
			local sign = vim.fn.sign_define

			sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", numhl = "" })
			sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", numhl = "" })
			sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", numhl = "" })
			sign("DapStopped", { text = "●", texthl = "DapStoppedLine", numhl = "" })
			sign("DapBreakpointRejected", { text = "●", texthl = "DapBreakpointRejected", numhl = "" })

			-- Adapters
			local dap = require("dap")
			local js_debug_adapter_path = vim.fn.stdpath("data")
				.. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { js_debug_adapter_path, "${port}" },
				},
			}
			dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

			dap.adapters["python"] = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
				args = { "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			}
			-- END

			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
			vscode.load_launchjs()
		end,
		keys = require("config.keymaps").dapKeys,
	},
	{
		"nvim-neotest/nvim-nio",
		lazy = true,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = { "js-debug-adapter", "debugpy" },
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		},
	},
}
