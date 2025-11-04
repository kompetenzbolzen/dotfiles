return {
	{
		"vimwiki/vimwiki",
		init = function()
			vim.g.vimwiki_list = {{
				syntax="markdown",
				ext=".md",
				path="$DOTFILE_SYNCDIR/notes/",
				auto_toc=1,
			}}
		end
	},
}
