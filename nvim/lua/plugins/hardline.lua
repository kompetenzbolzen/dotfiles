return {
	{
		"ojroques/nvim-hardline",
		config = function()
			require("hardline").setup {
				bufferline = true,
				theme = 'nord',
			}
		end,
	}
}
