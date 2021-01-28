"" Configs for https://github.com/AndrewRadev/tagalong.vim

"" Configs for https://github.com/alvan/vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'
inoremap <silent> <c-c> <c-c>:call tagalong#Apply()<cr>

