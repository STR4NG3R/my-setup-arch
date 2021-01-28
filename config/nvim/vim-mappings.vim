let mapleader=','

"close all buffers
map <M-c> :bufdo bd <CR>
"quit window
map <M-q> :q! <CR>
"write
map <M-w> :w <CR>

"Reload without quit vim
nnoremap <leader>rv :source $HOME/.config/nvim/init.vim<CR>
nnoremap <leader>v :e ~/.config/nvim/init.vim<CR>
map <C-a> <esc>ggVG<CR>
" imap ii <Esc>

" map <Leader>c :bp \| bd # <CR>
"map <Leader>c :bd! <CR>
map <Leader>w :bw <CR>
map <Leader>s :vsp <CR>
map <Leader>v :sp <CR>

"" Switching windows
nnoremap <nowait><C-j> <C-w>j<CR> 
nnoremap <nowait><C-k> <C-w>k<CR>
nnoremap <nowait><C-l> <C-w>l<CR>
nnoremap <nowait><C-h> <C-w>h<CR>

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
tnoremap <nowait> <M-h> <C-\><C-N><C-w>h
tnoremap <nowait> <M-j> <C-\><C-N><C-w>j
tnoremap <nowait> <M-k> <C-\><C-N><C-w>k
tnoremap <nowait> <M-l> <C-\><C-N><C-w>l
inoremap <nowait> <M-h> <C-\><C-N><C-w>h
inoremap <nowait> <M-j> <C-\><C-N><C-w>j
inoremap <nowait> <M-k> <C-\><C-N><C-w>k
inoremap <nowait> <M-l> <C-\><C-N><C-w>l
tnoremap <nowait> <Esc> <C-\><C-n>

"Resize In vim
nnoremap <nowait> <silent> <M-k> :resize +2<CR>
nnoremap <nowait> <silent> <M-j> :resize -2<CR>
nnoremap <nowait> <silent> <M-h> :vertical resize -2<CR>
nnoremap <nowait> <silent> <M-l> :vertical resize +2<CR>

let g:elite_mode=0                      " Disable arrows"
" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
    nnoremap <C-Up>    :resize -2<CR>
    nnoremap <C-Down>  :resize +2<CR>
    nnoremap <C-Left>  :vertical resize -2<CR>
    nnoremap <C-Right> :vertical resize +2<CR>
endif

" Better nav for omnicomplete
" inoremap <expr> <c-j> ("\<C-n>")
" inoremap <expr> <c-k> ("\<C-p>")

" Insert commentary
map <Leader>/ :Commentary <CR>

" Git config files
nnoremap gps :Gpush
nnoremap gc :Gcommit
nnoremap gs :Gstatus
nnoremap gpl :Gpull
" nnoremap gr :Gremove ;problematic
nnoremap gre :Grename
nnoremap gl :Glog
nnoremap gm :Gmerge 
