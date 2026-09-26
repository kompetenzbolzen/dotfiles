return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		url="https://gitea.muc.jag.re/jonas/todo-comments.nvim.git",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			highlight = {
				pattern = [[.*<(KEYWORDS)\s*]],
			}
		}
	}
}
