nmap <F6> :Startify <CR>

let g:startify_custom_header = [
    \ '  ______________________________    _____   _______     ________ ________ __________  ____   ____.___    _____   ',
    \ ' /   _____/\__    ___/\______   \  /  |  |  \      \   /  _____/ \_____  \\______   \ \   \ /   /|   |  /     \  ',
    \ ' \_____  \   |    |    |       _/ /   |  |_ /   |   \ /   \  ___   _(__  < |       _/  \   Y   / |   | /  \ /  \ ',
    \ ' /        \  |    |    |    |   \/    ^   //    |    \\    \_\  \ /       \|    |   \   \     /  |   |/    Y    \',
    \ '/_______  /  |____|    |____|_  /\____   | \____|__  / \______  //______  /|____|_  /    \___/   |___|\____|__  /',
    \ '        \/                    \/      |__|         \/         \/        \/        \/                          \/ '
  \ ]

let g:startify_session_dir = '~/.config/nvim/session'


let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']                        },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']                     },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']                    },
          \ ]

let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:webdevicons_enable_startify = 1
" Italics for my favorite color scheme
let g:palenight_terminal_italics=1

function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction

let g:startify_bookmarks = [
            \ { 'c': '~/.config/qtile/config.py' },
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.bashrc' },
            \ '~/Documentos',
            \ ]

let g:startify_enable_special = 0
