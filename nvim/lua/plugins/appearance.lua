return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		url="https://git.jonasgunz.de/todo-comments-nvim",
		branch='main',
		name='todo-comments.nvim',
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			highlight = {
				pattern = [[.*<(KEYWORDS)\s*]],
			}
		}
	}
}
