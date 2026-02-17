return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#131313',
				base01 = '#131313',
				base02 = '#999ea5',
				base03 = '#999ea5',
				base04 = '#eff6ff',
				base05 = '#f8fbff',
				base06 = '#f8fbff',
				base07 = '#f8fbff',
				base08 = '#ff9fbb',
				base09 = '#ff9fbb',
				base0A = '#add1ff',
				base0B = '#a5ffb1',
				base0C = '#d3e7ff',
				base0D = '#add1ff',
				base0E = '#bbd9ff',
				base0F = '#bbd9ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#999ea5',
				fg = '#f8fbff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#add1ff',
				fg = '#131313',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#999ea5' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#d3e7ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#bbd9ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#add1ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#add1ff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#d3e7ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffb1',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#eff6ff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#eff6ff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#999ea5',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
