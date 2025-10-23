local keymaps = {
	copilotKeys = {
		accept = "<M-a>",
		accept_word = "<M-a>w",
		accept_line = false,
		dismiss = "<M-d>",
		next = false,
		prev = false,
	},
	avanteKeys = {
		prompt_logger = {
			next_prompt = {
				normal = "<C-n>",
				insert = "<C-n>",
			},
			prev_prompt = {
				normal = "<C-p>",
				insert = "<C-p>",
			},
		},
		mappings = {
			-- Use <Nop> to disable a default keymap
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			suggestion = {
				accept = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
			jump = { --Jump to code block Avante window
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			cancel = { -- For close edit mode
				normal = { "<C-c>", "<Esc>", "q" },
				insert = { "<C-c>" },
			},
			ask = "<leader>aa",
			new_ask = "<leader>an",
			zen_mode = "<Nop>",
			edit = "<leader>ae",
			refresh = "<Nop>",
			focus = "<leader>af", -- Focus on Avante Window
			stop = "<leader>aS", -- Stop generating
			toggle = {
				default = "<Nop>",
				debug = "<Nop>",
				selection = "<Nop>",
				suggestion = "<Nop>",
				repomap = "<Nop>",
			},
			sidebar = {
				expand_tool_use = "<S-Tab>",
				next_prompt = "]p", -- jump to next prompt Avante window
				prev_prompt = "[p", -- jump to prev prompt Avante window
				apply_all = "A",
				apply_cursor = "a",
				retry_user_request = "r",
				edit_user_request = "e",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
				toggle_code_window = "x",
				remove_file = "d",
				add_file = "@",
				close = { "q" },
				close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
				toggle_code_window_from_input = nil, -- e.g., { normal = "x", insert = "<C-;>" }
			},
			files = {
				add_current = "<leader>ac", -- Add current buffer to selected files
				add_all_buffers = "<leader>al", -- Add all buffer files to selected files
			},
			select_model = "<leader>a?",
			select_history = "<leader>ah",
			confirm = {
				focus_window = "<C-w>f",
				code = "c",
				resp = "r",
				input = "i",
			},
		},
		keys = {
			{ "<leader>a!", "<cmd>AvanteSwitchProvider<cr>", desc = "Switch Provider" },
			{
				"<leader>a",
				mode = { "n", "v" },
				"<cmd>AvanteChat<cr>",
				desc = "Open Chat",
			},
		},
	},
	imgClipKeys = {
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
	persistenceKeys = {
		{
			"<leader>r",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Last Session",
		},
	},
	troubleKeys = {
		{ "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Open/Close Diagnostics (Trouble)" },
		{
			"<leader>tt",
			function()
				local edgy_win = nil
				for _, win_id in ipairs(vim.api.nvim_list_wins()) do
					if
						vim.bo[vim.api.nvim_win_get_buf(win_id)].filetype == "trouble"
						and vim.w[win_id].trouble.mode == "todo"
					then
						edgy_win = require("edgy").get_win(win_id)
					end
				end

				if edgy_win then
					edgy_win:close()
				else
					vim.cmd("Trouble todo filter = {tag = {FIX,TODO,NOTE}}")
				end
			end,
			desc = "Open/Close TODO-Comments (Trouble)",
		},
	},
	conformKeys = {
		{
			"==",
			mode = { "n", "v" },
			function()
				require("conform").format()
			end,
			desc = "Format code",
		},
	},
	gitsignsKeys = function(buffer)
		local gitsigns = require("gitsigns")

		vim.keymap.set("n", "<leader>gb", function()
			gitsigns.blame()
		end, { buffer = buffer, desc = "Blame Buffer in split" })

		vim.keymap.set("n", "<leader>gd", function()
			vim.ui.input({ prompt = "Diff: " }, function(diff)
				if not diff or diff == "" then
					return
				end
				gitsigns.diffthis(diff)
			end)
		end, { buffer = buffer, desc = "Diff" })
	end,
	treesitterKeys = {
		init_selection = "<C-s>",
		node_incremental = "<C-s>",
		scope_incremental = false,
		node_decremental = "<bs>", --backspace
	},
	lspKeys = function(buffer)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
			buffer = buffer,
			desc = "Go to Definition (Source)",
		})
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {
			buffer = buffer,
			desc = "Go to Type Definition",
		})
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
			buffer = buffer,
			desc = "Goto Declaration",
		})
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
			buffer = buffer,
			desc = "Go to Implementation",
		})
		vim.keymap.set("n", "gr", function()
			local edgy_win = nil
			for _, win_id in ipairs(vim.api.nvim_list_wins()) do
				if vim.bo[vim.api.nvim_win_get_buf(win_id)].filetype == "qf" then
					edgy_win = require("edgy").get_win(win_id)
				end
			end

			if edgy_win then
				edgy_win:close()
			else
				vim.lsp.buf.references()
			end
		end, {
			buffer = buffer,
			desc = "Open/Close References",
		})
		vim.keymap.set({ "i", "n" }, "<c-k>", function()
			return vim.lsp.buf.signature_help()
		end, {
			buffer = buffer,
			desc = "Signature Help",
		})
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
			buffer = buffer,
			desc = "Code Action",
		})
		vim.keymap.set("n", "<c-r>", vim.lsp.buf.rename, {
			buffer = buffer,
			desc = "Rename Code",
		})
		vim.keymap.set("n", "]r", function()
			Snacks.words.jump(vim.v.count1)
		end, {
			buffer = buffer,
			desc = "Next Reference",
		})
		vim.keymap.set("n", "[r", function()
			Snacks.words.jump(-vim.v.count1)
		end, {
			buffer = buffer,
			desc = "Prev Reference",
		})
	end,
	dapUIKeys = {
		{
			"<leader>dt",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle Windows",
		},
	},
	dapKeys = {
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Breakpoint Condition. When you want to pause execution only if a certain condition is met (e.g. a variable reaches a certain value).",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Run/Continue",
		},
		{
			"<leader>dr",
			function()
				require("dap").restart()
			end,
			desc = "DAP Restart",
		},
		{
			"<leader>dg",
			function()
				require("dap").goto_()
			end,
			desc = "Go to Line (No Execute)",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = "Down",
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = "Up",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "Pause",
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = "Session",
		},
		{
			"<leader>dT",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate",
		},
	},
	utilsFlashKeys = {
		{
			"<c-j>",
			mode = "n",
			function()
				require("flash").jump()
			end,
			desc = "Jump to..",
		},
		{
			"S",
			mode = "n",
			function()
				require("flash").treesitter()
			end,
			desc = "Select based scope",
		},
		{
			"R",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"s",
			mode = "n",
			function()
				require("flash").treesitter_search()
			end,
			desc = "Select",
		},
	},
	miniMoveKeys = {
		left = "<S-left>",
		right = "<S-right>",
		down = "<S-down>",
		up = "<S-up>",
		line_left = "<S-left>",
		line_right = "<S-right>",
		line_down = "<S-down>",
		line_up = "<S-up>",
	},
	miniCommentKeys = {
		comment = "",
		comment_line = "--",
		comment_visual = "--",
		textobject = "--",
	},
	bufferlineKeys = {
		{ "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to Tab 1" },
		{ "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to Tab 2" },
		{ "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to Tab 3" },
		{ "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to Tab 4" },
		{ "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to Tab 5" },
		{ "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to Tab 6" },
		{ "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to Tab 7" },
		{ "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to Tab 8" },
		{ "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to Tab 9" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Tab" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Tab" },
		{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move Tab Prev" },
		{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move Tab Next" },
		{
			"<leader>bd",
			function()
				Snacks.bufdelete(vim.api.nvim_get_current_buf())
			end,
			desc = "Delete Tab",
		},
	},
	uiEdgyKeys = {
		-- close window
		["q"] = function(win)
			win:close()
		end,
		-- hide window
		["<c-q>"] = false,
		-- close sidebar
		["Q"] = function(win)
			win.view.edgebar:close()
		end,
		-- next open window
		["]w"] = function(win)
			win:next({ visible = true, focus = true })
		end,
		-- previous open window
		["[w"] = function(win)
			win:prev({ visible = true, focus = true })
		end,
		-- next loaded window
		["]W"] = function(win)
			win:next({ pinned = false, focus = true })
		end,
		-- prev loaded window
		["[W"] = function(win)
			win:prev({ pinned = false, focus = true })
		end,
		-- increase width
		["<c-w>>"] = false,
		-- decrease width
		["<c-w><lt>"] = false,
		-- increase height
		["<c-w>+"] = false,
		-- decrease height
		["<c-w>-"] = false,
		-- reset all custom sizing
		["<c-w>="] = false,
	},
	uiSnacksKeys = {
		{
			"<leader>tT",
			function()
				Snacks.picker.todo_comments()
			end,
			desc = "TODO Comments Search",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log({
					confirm = function(picker, item)
						picker:close()
						if item and item.commit then
							require("gitsigns").show_commit(item.commit)
						end
					end,
				})
			end,
			desc = "Git Log (With plugin Gitsigns)",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Open/Close Explorer",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>d",
			function()
				Snacks.dashboard()
			end,
			desc = "Go to Dashboard",
		},
		{
			"<leader>t",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "open/close selected terminal",
		},
		{
			"<leader>s",
			function()
				local directions = { "Vertical", "Horizontal" }
				Snacks.picker.select(directions, { prompt = "choose split" }, function(direction_choice)
					if not direction_choice then
						return
					end

					vim.ui.input({ prompt = "Percent size (0-100): " }, function(size)
						if not size or size == "" then
							return
						end
						local size_percent = tonumber(size)

						if not size_percent or size_percent < 0 or size_percent > 100 then
							vim.notify("Invalid size. Please enter a number between 0 - 100")
							return
						end

						if direction_choice == "Vertical" then
							local total_width = vim.o.columns
							local target_width = math.floor((total_width * size_percent) / 100)
							vim.cmd("vsplit | vertical resize " .. target_width)
						else
							local total_height = vim.o.lines
							local target_height = math.floor((total_height * size_percent) / 100)
							vim.cmd("split | resize " .. target_height)
						end
					end)
				end)
			end,
			desc = "Create split",
		},
	},
	uiPickerExplorerKeys = {
		["<BS>"] = false,
		["l"] = "confirm",
		["h"] = false,
		["a"] = "explorer_add",
		["d"] = "explorer_del",
		["r"] = "explorer_rename",
		["c"] = "explorer_copy",
		["m"] = "explorer_move",
		["o"] = "explorer_open",
		["P"] = false,
		["y"] = { "explorer_yank", mode = { "n", "x" } },
		["p"] = "explorer_paste",
		["u"] = false,
		["<c-c>"] = false,
		["<leader>/"] = false,
		["<c-t>"] = false,
		["."] = "explorer_focus",
		["I"] = false,
		["H"] = "toggle_hidden",
		["Z"] = false,
		["]g"] = false,
		["[g"] = false,
		["]d"] = false,
		["[d"] = false,
		["]w"] = false,
		["[w"] = false,
		["]e"] = false,
		["[e"] = false,
	},
}

return keymaps
