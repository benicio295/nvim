local g = vim.g
g.mapleader = " "
g.maplocalleader = "\\"

local opt = vim.opt
opt.foldlevel = 99
opt.number = true
opt.cursorline = true
opt.smartcase = true
opt.expandtab = true
opt.shiftwidth = 5
opt.tabstop = 5
opt.mouse = "a"
opt.confirm = true
opt.showmode = false
opt.list = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.grepformat = "%f:%l:%c:%m"
opt.signcolumn = "yes"
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.linebreak = true
opt.virtualedit = "block"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.laststatus = 3
opt.wrap = false
opt.termguicolors = true
opt.cmdheight = 0
opt.ruler = false
opt.guicursor = table.concat({
	"n-v-c:block-blinkwait700-blinkoff400-blinkon250",
})
