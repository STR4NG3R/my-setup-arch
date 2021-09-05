set noswapfile
set termguicolors
set nu
set rnu
set encoding=UTF-8
set mouse=a
set nowrap
set shiftwidth=2
set tabstop=2
set softtabstop=0
set expandtab
set cmdheight=1
set smartcase
set nobackup
set nowritebackup
set updatetime=300
set timeoutlen=700
set numberwidth=2
set shortmess+=c
set ve+=onemore
set autoindent
set smartindent

let g:import_sort_auto = 1
let g:mapleader = ","
let g:maplocalleader = ","

nnoremap <leader>S :lua require('spectre').open()<CR>
nnoremap <leader>sw :lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s :lua require('spectre').open_visual()<CR>
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>

let g:vim_dadbod_completion_mark = ''

" Source is automatically added, you just need to include it in the chain complete list
let g:completion_chain_complete_list = {
    \   'sql': [
    \    {'complete_items': ['vim-dadbod-completion']},
    \   ],
    \ }
" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1
let g:blamer_enabled = 1
