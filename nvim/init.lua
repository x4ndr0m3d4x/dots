-- Disable netrw (file explore)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1) end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Vim settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.diagnostic.config({
	update_in_insert = true,
	virtual_text = false,
	virtual_lines = {
		current_line = true
	},
	signs = true,
	underline = true
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Treesitter (syntax highlighting)
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			event = { "BufRead" },
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					highlight = { enable = true },
					auto_install = true
				})
			end
		},

		-- LSPs using Mason & lsp-config, as well as coq_nvim for completion
		{
			"williamboman/mason.nvim",
			lazy = false,
			config = true
		},
		{
			"williamboman/mason-lspconfig.nvim",
			lazy = false,
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "clangd", "tailwindcss", "html", "ts_ls", "lua_ls", "pyright", "rust_analyzer", "tinymist" }
				})

				-- Default LSP configuration
				require("mason-lspconfig").setup_handlers {
					function(server_name)
						require("lspconfig")[server_name].setup {}
					end
				}
			end,
		},
		{
			"neovim/nvim-lspconfig", -- REQUIRED
			lazy = false, -- REQUIRED
			dependencies = {
				-- Main completion plugin 
				{ "ms-jpq/coq_nvim", branch = "coq" },
				-- 9000+ Snippets
				{ "ms-jpq/coq.artifacts", branch = "artifacts" },
			},
			init = function()
				vim.g.coq_settings = {
					auto_start = "shut-up",
				}
			end
		},

		-- File Explorer
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			config = true
		},

		-- Catppuccin theme
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					flavour = "mocha",
				})
			end,
			init = function()
				vim.cmd.colorscheme "catppuccin"
			end,
		},

		-- Git integration (required for status line)
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				signcolumn = false
			}
		},

		-- Status line
		{
			"rebelot/heirline.nvim",
			config = function()
				local heirline = require("heirline")
				local utils = require("heirline.utils")
				local conditions = require("heirline.conditions")

				-- Define colors
				local colors = {
					red = utils.get_highlight("DiagnosticError").fg,
					green = utils.get_highlight("String").fg,
					blue = utils.get_highlight("Function").fg,
					yellow = utils.get_highlight("DiagnosticWarn").fg,
					purple = utils.get_highlight("Statement").fg,
					cyan = utils.get_highlight("Special").fg,
					orange = utils.get_highlight("Constant").fg,
					gray = utils.get_highlight("NonText").fg,
					fg = utils.get_highlight("Normal").fg,
					bg = utils.get_highlight("Normal").bg,
					git_add = utils.get_highlight("diffAdded").fg,
					git_del = utils.get_highlight("diffRemoved").fg,
					git_change = utils.get_highlight("diffChanged").fg
				}

				-- Load the colors
				heirline.load_colors(colors)

				-- Logo (just for padding)
				local Logo = {
					hl = { bold = true },
					{
						provider = "| ",
					},
					{
						provider = "",
						hl = { fg = colors.green }
					},
					{
						provider = " | ",
					},
				}

				-- Vim mode component
				local ViMode = {
					init = function(self)
						self.mode = vim.fn.mode(1)
					end,
					static = {
						mode_names = {
							n = "NORMAL",
							i = "INSERT",
							ic = "INSERT",
							c = "COMMAND",
							v = "VISUAL",
							V = "VISUAL LINE",
							["\22"] = "VISUAL BLOCK",
							t = "TERMINAL",
							R = "REPLACE",
							r = "REPLACE",
							no = "OP-PENDING",
						},
						mode_colors = {
							n = "red",
							i = "green",
							ic = "green",
							v = "cyan",
							V = "cyan",
							["\22"] = "cyan",
							c = "orange",
							t = "red",
							r = "yellow"
						}
					},
					provider = function(self)
						local mode_str = self.mode_names[self.mode] or self.mode or "UNKNOWN"
						return "%2(" .. mode_str .. "%)"
					end,
					hl = function(self)
						local color = self.mode_colors[self.mode]
						return { fg = color, bold = true }
					end,
				}

				-- Git branch component
				local GitBranch = {
					condition = conditions.is_git_repo,

					init = function(self)
						self.status_dict = vim.b.gitsigns_status_dict
					end,

					hl = { bold = true },

					-- Branch name
					{
						provider = " | ",
					},
					{
						provider = function()
							local branch = vim.b.gitsigns_head
							return branch and " " .. branch or ""
						end,
						hl = { fg = colors.orange }
					},
					-- Added
					{
						provider = function(self)
							local count = self.status_dict.added or 0
							return count > 0 and (" | ")
						end,
					},
					{
						provider = function(self)
							local count = self.status_dict.added or 0
							return count > 0 and ("+" .. count)
						end,
						hl = { fg = colors.git_add }
					},
					-- Removed
					{
						provider = function(self)
							local count = self.status_dict.removed or 0
							return count > 0 and (" | ")
						end,
					},
					{
						provider = function(self)
							local count = self.status_dict.removed or 0
							return count > 0 and ("-" .. count)
						end,
						hl = { fg = colors.git_del }
					},
					-- Changed
					{
						provider = function(self)
							local count = self.status_dict.changed or 0
							return count > 0 and (" | ")
						end,
					},
					{
						provider = function(self)
							local count = self.status_dict.changed or 0
							return count > 0 and ("~" .. count)
						end,
						hl = { fg = colors.git_change }
					},

				}

				-- LSP status component
				local LSPStatus = {
					condition = conditions.lsp_attached,
					init = function(self)
						local lsp_clients = vim.lsp.get_clients()
						self.lsp_names = {}
						for _, client in pairs(lsp_clients) do
							table.insert(self.lsp_names, client.name)
						end
						self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
						self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
						self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					end,
					hl = { bold = true },
					-- LSP server name
					{
						provider = function(self)
							return table.concat(self.lsp_names, ", ")
						end,
						hl = { fg = colors.purple }
					},
					-- Errors
					{
						provider = " | "
					},
					{
						provider = function(self)
							return self.errors .. " "
						end,
						hl = { fg = colors.red }
					},
					-- Warnings
					{
						provider = " | "
					},
					{
						provider = function(self)
							return self.warnings .. " "
						end,
						hl = { fg = colors.orange }
					},
					-- Hints
					{
						provider = " | "
					},
					{
						provider = function(self)
							return self.hints .. " "
						end,
						hl = { fg = colors.green }
					},
				}

				-- Line and column component
				local LineCol = {
					provider = function()
						local line = vim.fn.line(".")
						local col = vim.fn.col(".")
						return string.format("| %3d:%-3d |", line, col)
					end,
					hl = { fg = colors.fg, bold = true },
				}

				-- Define the status line
				local StatusLine = {
					Logo,
					ViMode,
					GitBranch,
					{
						provider = "%=",
						hl = { bold = true }
					}, -- right align
					LSPStatus,
					{
						provider = " ",
						hl = { bold = true }
					},
					LineCol
				}

				-- Setup the status line
				heirline.setup({ statusline = StatusLine })
			end,
		},

		-- Tabline
		{
			"akinsho/bufferline.nvim",
			version = "*",
			opts = {
				options = {
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
							highlight = "Directory"
						}
					}
				}
			}
		},

		-- Wakatime
		{
			"wakatime/vim-wakatime",
			lazy = false
		}
	},

	-- Automatically check for plugin updates
	checker = { enabled = true },
})

-- Change all diagnostic highlights to use curly lines
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
	undercurl = true,
	sp = vim.api.nvim_get_hl_by_name("DiagnosticError", true).foreground
});
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
	undercurl = true,
	sp = vim.api.nvim_get_hl_by_name("DiagnosticWarn", true).foreground
});
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
	undercurl = true,
	sp = vim.api.nvim_get_hl_by_name("DiagnosticInfo", true).foreground
});
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
	undercurl = true,
	sp = vim.api.nvim_get_hl_by_name("DiagnosticHint", true).foreground
});
