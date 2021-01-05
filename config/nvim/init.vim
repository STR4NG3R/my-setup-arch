call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'drewtempelmeyer/palenight.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-startify'
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
Plug 'voldikss/vim-floaterm'
Plug 'Shougo/echodoc.vim'
Plug 'tpope/vim-fugitive'
Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '3c07232', 'do': ':TSUpdate'}
Plug 'Raimondi/delimitMate'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
Plug 'mlaursen/vim-react-snippets'
call plug#end()

let g:coc_global_extensions = [
      \'coc-explorer',
      \'coc-python',
      \'coc-json', 
      \'coc-flutter', 
      \'coc-java', 
      \'coc-clangd', 
      \'coc-floaterm',
      \'coc-snippets',
      \'coc-css',
      \]

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"java", "cpp", "javascript", "typescript"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  },  -- list of language that will be disabled
  },
}
EOF

if !has('nvim')
    set viminfo+=~/.vim/viminfo
endif

source $HOME/.config/nvim/vim-mappings.vim
source $HOME/.config/nvim/vim-editor.vim 
source $HOME/.config/nvim/vim-clip.vim  
source $HOME/.config/nvim/vim-startify.vim 
source $HOME/.config/nvim/vim-laf.vim
source $HOME/.config/nvim/vim-terminal.vim
source $HOME/.config/nvim/fzf.vim
source $HOME/.config/nvim/vim-snippets.vim
source $HOME/.config/nvim/rn.vim
