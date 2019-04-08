let mapleader = ","
execute pathogen#infect()
syntax on
filetype plugin indent on

"Autostart NERDtree
autocmd vimenter * NERDTree

"Switch windows with keys
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

nmap <F5> :NERDTree<CR>
nmap <F6> :TlistToggle<CR>

"Tab mgmt
nmap <F1> :tabclose<CR>
nmap <F2> :tabprevious<CR>
nmap <F3> :tabnext<CR>
nmap <F4> :tabnew<CR>

"Line number Highlight
set nu
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
