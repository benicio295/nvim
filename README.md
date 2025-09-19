# Nvim config (For Linux and MacOS)

## Prerequisites

Before you begin, ensure you have the following installed:

- **Neovim**: Latest stable version (built with LuaJIT).
- **Terminal**: A terminal that supports true color, Kitty graphics protocol, undercurl, and special UTF-8 glyphs (e.g., Kitty, Ghostty).
- **Font**: A Nerd Font.
- **Core Dependencies**:
  - Git
  - C Compiler
  - Python with pip
  - NodeJS with npm
- **System Tools**:
  - `lua`
  - `luarocks`
  - `ImageMagick`
  - `ghostscript` (gs)
  - `fd`
  - `ripgrep` (rg)
  - `SQLite3`
  - `GNU tar`
  - `curl`
  - `unzip`
  - `gzip`
- **Clipboard Manager** (choose one):
  - `pngpaste` (macOS)
  - `xclip` (Linux with X11)
  - `wl-clipboard` (Linux with Wayland)

## Installation

1. **Backup or delete your Neovim configuration (if exists):**

   ```bash
   mv ~/.config/nvim <destination>
   mv ~/.local/share/nvim <destination> # OPTIONAL
   mv ~/.local/state/nvim <destination> # OPTIONAL
   mv ~/.cache/nvim <destination> # OPTIONAL
   ```

1. **Clone the repository:**

```bash
git clone https://github.com/benicio295/nvim.git ~/.config
```

## Post-Installation

1. **Launch Neovim.** `lazy.nvim` will automatically install the plugins.
1. **LSP and DAP Servers**: `mason.nvim` will automatically install the configured Language Servers (LSPs) and Debug Adapters (DAPs).
1. **Press `h` to checkhealth** to identify and resolve any potential issues.
1. **Change configs (press `c` to open Config):**
   - Open `plugins/ui.lua`. Go to **line 255** and define the location where all your projects are. Example: `~/Documents/`. Then go to **line 238** and set your default shell.
1. Auth Github Copilot with `:Copilot auth` (if you haven't already)

## Key Mappings

Here are some key mappings to get you started. The `<leader>` is set to space key on your keyboard.

| Keybinding | Description |
| --------------- | ----------------------------------------- |
| `<leader>e` | Open/Close Explorer |
| `<leader>/` | Grep |
| `<leader>d` | Go to Dashboard |
| `<leader>t` | Toggle Terminal |
| `==` | Format code |
| `<leader>a` | Open AI Chat |
| `<M-a>` | Accept Copilot suggestions |
| `<leader>m`|Open MCP Hub |
| `<leader>p` | Paste image from system clipboard |
| `<leader>r` | Restore Last Session |
| `<leader>td` | Open/Close Diagnostics |
| `[b` / `]b` | Previous/Next Tab |
| `<leader>bd` | Close Tab |

To view or change all key mappings, go to `config/keymaps.lua`

## Installed Plugins

This configuration comes with a curated list of plugins to enhance your development workflow. Here are some of them:

### AI

- **copilot.lua**: GitHub Copilot integration.
- **avante.nvim**: A multi-modal AI companion.
- **mcphub.nvim**: A client MCP.

### UI

- **bufferline.nvim**: A sleek buffer line.
- **lualine.nvim**: A fast and customizable status line.
- **edgy.nvim**: Manages window layouts.
- **catppuccin**: A soothing pastel theme.
- **nvim-web-devicons**: File type icons.

### Development

- **nvim-lspconfig**: A collection of common configurations for the Nvim LSP client.
- **mason.nvim**: Manages LSPs, DAPs, linters, and formatters.
- **nvim-treesitter**: Provides advanced syntax highlighting and code analysis.
- **conform.nvim**: A lightweight and opinionated formatter.
- **nvim-lint**: An asynchronous linter.
- **nvim-dap**: Debug Adapter Protocol implementation.
- **gitsigns.nvim**: Git decorations.

### Completion

- **blink.cmp**: A fast and extensible completion engine.

### Utilities

- **snacks.nvim**: A collection of useful utilities.
- **flash.nvim**: Enhances navigation within and between files.
- **trouble.nvim**: A pretty list for diagnostics, references, and more.
- **mini.nvim**: A collection of minimal and fast Lua modules.
- **persistence.nvim**: Persists sessions.
- **todo-comments.nvim**: Highlights and searches for TODO comments.
- **nvim-autopairs**: Inserts and manages pairs of characters.

To view all installed plugins, go to `lua/plugins` dir
