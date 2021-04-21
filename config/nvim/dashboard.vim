let g:dashboard_custom_header = [
    \ '  ______________________________    _____   _______     ________ ________ __________  ____   ____.___    _____   ',
    \ ' /   _____/\__    ___/\______   \  /  |  |  \      \   /  _____/ \_____  \\______   \ \   \ /   /|   |  /     \  ',
    \ ' \_____  \   |    |    |       _/ /   |  |_ /   |   \ /   \  ___   _(__  < |       _/  \   Y   / |   | /  \ /  \ ',
    \ ' /        \  |    |    |    |   \/    ^   //    |    \\    \_\  \ /       \|    |   \   \     /  |   |/    Y    \',
    \ '/_______  /  |____|    |____|_  /\____   | \____|__  / \______  //______  /|____|_  /    \___/   |___|\____|__  /',
    \ '        \/                    \/      |__|         \/         \/        \/        \/                          \/ '
\]

let g:dashboard_custom_shortcut={
\ 'last_session'       : 'SPC s l',
\ 'find_history'       : 'SPC f h',
\ 'find_file'          : 'SPC f f',
\ 'new_file'           : 'SPC c n',
\ 'change_colorscheme' : 'SPC t c',
\ 'find_word'          : 'SPC f a',
\ 'book_marks'         : 'SPC f b',
\ }
" let g:dashboard_preview_command = 'cat'
" let g:dashboard_preview_pipeline = 'lolcat'
" let g:dashboard_preview_file_height = 12
" let g:dashboard_preview_file_width = 80
let g:dashboard_default_executive ='fzf'
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
map <F6> :Dashboard<CR>
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2

" let g:dashboard_custom_shortcut_icon['last_session'] = ' '
" let g:dashboard_custom_shortcut_icon['find_history'] = 'ﭯ '
" let g:dashboard_custom_shortcut_icon['find_file'] = ' '
" let g:dashboard_custom_shortcut_icon['new_file'] = ' '
" let g:dashboard_custom_shortcut_icon['change_colorscheme'] = ' '
" let g:dashboard_custom_shortcut_icon['find_word'] = ' '
" let g:dashboard_custom_shortcut_icon['book_marks'] = ' '
