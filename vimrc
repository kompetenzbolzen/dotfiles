let mapleader = ","
execute pathogen#infect()
syntax on
filetype plugin indent on

"Autostart NERDtree
autocmd vimenter * NERDTree

"Switch windows with Alt+Arrow keys
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

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
