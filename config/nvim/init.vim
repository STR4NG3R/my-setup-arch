call plug#begin(expand('~/.config/nvim/plugged'))
"Synthax parsers, Formaters, Snippets
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'maxmellon/vim-jsx-pretty'
Plug 'honza/vim-snippets'
Plug 'norcalli/nvim-colorizer.lua'
"Themes, Icons, Color Schemes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'Raimondi/delimitMate'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
" Plug 'vim-airline/vim-airline'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'romgrk/barbar.nvim'
"Web Development
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'alvan/vim-closetag'
"Debug tools
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer' 
Plug 'FooSoft/vim-argwrap'
"CoC Plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
" Latex Plugins
Plug 'lervag/vimtex'
Plug 'donRaphaco/neotex', { 'for': 'tex' }
"General Plugins
" Plug 'RRethy/vim-illuminate'
Plug 'tpope/vim-surround'
Plug 'metakirby5/codi.vim'
Plug 'psliwka/vim-smoothie'
Plug 'iamcco/markdown-preview.vim'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-commentary'
Plug 'vim-syntastic/syntastic'
Plug 'Yggdroot/indentLine'
Plug 'lambdalisue/suda.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim' " needed for previews
Plug 'voldikss/vim-floaterm'
Plug 'Shougo/echodoc.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
call plug#end()

let g:coc_global_extensions = [
      \'coc-explorer',
      \'coc-python',
      \'coc-json', 
      \'coc-flutter', 
      \'coc-java', 
      \'coc-floaterm',
      \'coc-snippets',
      \'coc-html',
      \'coc-prettier',
      \'coc-css',
      \'coc-tag',
      \'coc-eslint',
      \'coc-tsserver',
      \'coc-bootstrap-classname',
      \'coc-texlab',
      \'coc-xml',
      \'coc-phpls',
      \]

if !has('nvim')
    set viminfo+=~/.vim/viminfo
endif

set spell spelllang=es,en 
autocmd BufEnter *.*  set nospell
autocmd BufEnter *.tex  set spell


source $HOME/.config/nvim/vim-mappings.vim
source $HOME/.config/nvim/vim-editor.vim 
source $HOME/.config/nvim/vim-clip.vim  
source $HOME/.config/nvim/vim-startify.vim 
source $HOME/.config/nvim/vim-laf.vim
source $HOME/.config/nvim/vim-terminal.vim
source $HOME/.config/nvim/fzf.vim
source $HOME/.config/nvim/rn.vim
source $HOME/.config/nvim/vim-html.vim
source $HOME/.config/nvim/vim-snippets.vim
source $HOME/.config/nvim/git-gutter.vim
luafile $HOME/.config/nvim/vim-lua.lua
source $HOME/.config/nvim/vim-barbar.vim
luafile $HOME/.config/nvim/vim-lua-status.lua

nnoremap <silent> <leader>a :ArgWrap<CR>
