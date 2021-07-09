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
set updatetime=750
set shortmess+=c
set ve+=onemore
set autoindent
set smartindent

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })

nnoremap <Tab> :BufferNext! <CR>
nnoremap <S-Tab> :BufferPrevious! <CR>

" let g:compe.source.vim_dadbod_completion = v:true
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
nnoremap <buffer> <leader>am :ArduinoVerify<CR>
nnoremap <buffer> <leader>au :ArduinoUpload<CR>
nnoremap <buffer> <leader>ad :ArduinoUploadAndSerial<CR>
nnoremap <buffer> <leader>ab :ArduinoChooseBoard<CR>
nnoremap <buffer> <leader>ap :ArduinoChooseProgrammer<CR>


" npm install --save-dev import-sort-cli import-sort-parser-babylon import-sort-parser-typescript import-sort-style-renke

