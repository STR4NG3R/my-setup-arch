nmap <F5> <Plug>RestNvim<CR>
nmap <F7> :DBUIToggle<CR>
"quit window
map <silent><nowait><M-q> :q! <CR>
"write
map <silent><nowait><M-w> :w! <CR>
"" Switching windows
nnoremap <nowait><C-j> <C-w>j<CR> 
nnoremap <nowait><C-k> <C-w>k<CR>
nnoremap <nowait><C-l> <C-w>l<CR>
nnoremap <nowait><C-h> <C-w>h<CR>

"" Clean search (highlight)
nnoremap <silent> <Leader><Space> :noh<cr>

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
