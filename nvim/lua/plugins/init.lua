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
		lazy = false,
		build = ':TSUpdate',
		config = function()
			local fts = {"c", "cpp", "lua", "vim", "bash", "make", "rust", "python", "haskell"}
			require('nvim-treesitter').install(fts)
			vim.api.nvim_create_autocmd('FileType', {
 				pattern = fts,
 				callback = function() vim.treesitter.start() end,
			})
                end,
        },
	{
		"stevearc/oil.nvim",
		opts = {},
	}
}
