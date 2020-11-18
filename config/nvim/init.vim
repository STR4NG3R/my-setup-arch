"Reload without quit vim
nnoremap <leader>rv :source ~/.vimrc<CR>
nnoremap <leader>v :e ~/.config/nvim/init.vim<CR>
map <C-a> <esc>ggVG<CR>
vnoremap <Esc> <C-\><C-n>
imap ii <Esc>

let g:session_autoload = 'no'
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-startify'
Plug 'yegappan/mru'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'peitalin/vim-jsx-typescript'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'Yggdroot/indentLine'
Plug 'lambdalisue/suda.vim'
Plug 'ryanoasis/vim-webdevicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yuezk/vim-js'
Plug 'ryanoasis/vim-devicons'
Plug 'jelera/vim-javascript-syntax'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

let g:coc_global_extensions = [
      \'coc-explorer',
      \'coc-python',
      \'coc-json', 
      \'coc-flutter', 
      \'coc-java', 
      \'coc-clangd', 
      \'coc-git'
      \]

function InsertIfEmpty()
    if @% == ""
        " No filename for current buffer
        :CocCommand explorer
    elseif filereadable(@%) == 0
        " File doesn't exist yet
        startinsert
    elseif line('$') == 1 && col('$') == 1
        " File is empty
        startinsert
    endif
endfunction

au VimEnter * call InsertIfEmpty()

let mapleader=','
filetype plugin indent on

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
set ruler
if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'violet'
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

"Increase/Decrease size splited windows
nnoremap <Leader>+ <C-w>+
nnoremap <Leader>- <C-w>-

" syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
let g:syntastic_auto_loc_list=1
let g:syntastic_aggregate_errors = 1

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" javascript
let g:javascript_enable_domhtmlcss = 1

"auto_save plug
"let g:auto_save = 1

" vim-airline
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tabline#enabled = 1

colorscheme atom-dark-256

source ~/.config/nvim/vim-editor.vim
source ~/.config/nvim/vim-clip.vim
source ~/.config/nvim/vim-startify.vim
