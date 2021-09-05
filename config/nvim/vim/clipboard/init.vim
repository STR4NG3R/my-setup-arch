set clipboard=unnamed
map <C-a> <Esc>ggVG<CR>

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>       "+gP
map <S-Insert>      "+gP

cmap <C-V>      <C-R>+

" exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
" exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>     <C-V>
vmap <S-Insert>     <C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>       <C-V>

" if has("virtualedit")
"   let paste#paste_cmd = {'n': ":call paste#Paste()<CR>"}
"   let paste#paste_cmd['v'] = '"-c<Esc>' . paste#paste_cmd['n']
"   let paste#paste_cmd['i'] = 'x<BS><Esc>' . paste#paste_cmd['n'] . 'gi'

"   func! paste#Paste()
"     let ove = &ve
"     set ve=all
"     normal! `^
"     if @+ != ''
"       normal! "+gP
"     endif
"     let c = col(".")
"     normal! i
"     if col(".") < c " compensate for i<ESC> moving the cursor left
"       normal! l
"     endif
"     let &ve = ove
"   endfunc
" else
"   let paste#paste_cmd = {'n': "\"=@+.'xy'<CR>gPFx\"_2x"}
"   let paste#paste_cmd['v'] = '"-c<Esc>gix<Esc>' . paste#paste_cmd['n'] . '"_x'
"   let paste#paste_cmd['i'] = 'x<Esc>' . paste#paste_cmd['n'] . '"_s'
" endif
