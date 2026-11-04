return {
	{
		"luochen1990/rainbow",
		init = function()
			vim.g.rainbow_active = 1
		end
	},
	{
		"jamessan/vim-gnupg"
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ':TSUpdate',
		config = function()
			local ts = require('nvim-treesitter')
			local fts = {"c", "cpp", "lua", "vim", "bash", "make", "rust", "python", "haskell"}
			ts.setup({})
			ts.install(fts)
			vim.api.nvim_create_autocmd('FileType', {
				pattern = fts,
				callback = function()
					vim.treesitter.start()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					vim.wo[0][0].foldmethod = 'expr'
					vim.wo.foldlevel = 99
				end,
			})
                end,
        },
	{
		"stevearc/oil.nvim",
		opts = {},
	}
}
