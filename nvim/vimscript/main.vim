set nu rnu
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

nmap <silent> gc :bd<CR>
nmap <silent> gn :$tabnew +edit\ .<CR>

" fix for stuck No Name buffers after file open (neovim #17841)
set nohidden

set background=dark
colorscheme neofusion
