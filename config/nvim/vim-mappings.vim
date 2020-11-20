let mapleader=','

"Reload without quit vim
"nnoremap <leader>rv :source $HOME/.config/nvim/init.vim<CR>
nnoremap <leader>v :e ~/.config/nvim/init.vim<CR>
map <C-a> <esc>ggVG<CR>
imap ii <Esc>

nmap <S-Tab> :bp<CR>
nmap <Tab> :bn<CR>
"map <Leader>c :bp\|bd # <CR>
map <Leader>c :bd <CR>
map <Leader>w :bw <CR>


map <Leader>s :vsp <CR>
map <Leader>v :sp <CR>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"Better identing
vnoremap < <gv
vnoremap > >gv

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Terminal window navigation
tnoremap <M-h> <C-\><C-N><C-w>h
tnoremap <M-j> <C-\><C-N><C-w>j
tnoremap <M-k> <C-\><C-N><C-w>k
tnoremap <M-l> <C-\><C-N><C-w>l
inoremap <M-h> <C-\><C-N><C-w>h
inoremap <M-j> <C-\><C-N><C-w>j
inoremap <M-k> <C-\><C-N><C-w>k
inoremap <M-l> <C-\><C-N><C-w>l
tnoremap <Esc> <C-\><C-n>

"Resize In vim
nnoremap <silent> <M-k> :resize -2<CR>
nnoremap <silent> <M-j> :resize +2<CR>
nnoremap <silent> <M-h> :vertical resize -2<CR>
nnoremap <silent> <M-l> :vertical resize +2<CR>

let g:elite_mode=0                      " Disable arrows"
" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
    nnoremap <C-Up>    :resize -2<CR>
    nnoremap <C-Down>  :resize +2<CR>
    nnoremap <C-Left>  :vertical resize -2<CR>
    nnoremap <C-Right> :vertical resize +2<CR>
endif

" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

"Insert commentary
vnoremap <silent> <space>/ :call Comment()

