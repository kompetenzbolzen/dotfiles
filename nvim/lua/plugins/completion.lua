return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true
	},{
		"hrsh7th/nvim-cmp",
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-vsnip', 
			'hrsh7th/vim-vsnip'
		},
		config = function()
			local cmp_autopairs = require'nvim-autopairs.completion.cmp'
			local cmp = require'cmp'
			cmp.setup {
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' },
				},{
					{ name = 'buffer' },
				})
			}

			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
		end,
	},{
		'neovim/nvim-lspconfig',
		config = function()
			local lspconfig = require('lspconfig')

			lspconfig.rust_analyzer.setup {}
			lspconfig.pyright.setup {}
			lspconfig.clangd.setup {}
		end,

	},
}
