let g:session_autoload = 'no'
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'drewtempelmeyer/palenight.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-startify'
Plug 'yegappan/mru'
Plug 'ap/vim-css-color'
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
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim' " needed for previews
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'liuchengxu/vim-which-key'
Plug 'voldikss/vim-floaterm'
call plug#end()

let g:coc_global_extensions = [
      \'coc-explorer',
      \'coc-python',
      \'coc-json', 
      \'coc-flutter', 
      \'coc-java', 
      \'coc-clangd', 
      \'coc-git',
      \'coc-floaterm',
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

source $HOME/.config/nvim/vim-mappings.vim
source $HOME/.config/nvim/vim-editor.vim 
source $HOME/.config/nvim/vim-clip.vim  
source $HOME/.config/nvim/vim-startify.vim 
source $HOME/.config/nvim/vim-laf.vim
source $HOME/.config/nvim/vim-terminal.vim
source $HOME/.config/nvim/fzf.vim
source $HOME/.config/nvim/which-key.vim

