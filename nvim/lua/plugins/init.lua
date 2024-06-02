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
                config = function()
                        require'nvim-treesitter.configs'.setup{
                                ensure_installed = {"c", "cpp", "lua", "vim", "bash", "make", "rust"},
                                highlight = {
                                        enable = true
                                }
                        }
                end
        }
}
