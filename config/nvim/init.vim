call plug#begin(expand('~/.config/nvim/plugged'))
"Synthax parsers, Formaters, Snippets
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'honza/vim-snippets'
Plug 'norcalli/nvim-colorizer.lua'
"Themes, Icons, Color Schemes
Plug 'tomasiser/vim-code-dark'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'Raimondi/delimitMate'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'romgrk/barbar.nvim'
"Web Development
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/tagalong.vim'
"Debug tools
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
Plug 'FooSoft/vim-argwrap'
"CoC Plugins
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
" Latex Plugins
Plug 'lervag/vimtex'
Plug 'donRaphaco/neotex', { 'for': 'tex' }
"General Plugins
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}
Plug 'RRethy/vim-illuminate'
Plug 'tpope/vim-surround'
Plug 'metakirby5/codi.vim'
Plug 'psliwka/vim-smoothie'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-commentary'
Plug 'lambdalisue/suda.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim' " needed for previews
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
call plug#end()

let g:coc_global_extensions = [
      \'coc-explorer',
      \'coc-python',
      \'coc-json', 
      \'coc-flutter', 
      \'coc-java', 
      \'coc-clangd', 
      \'coc-spell-checker',
      \'coc-floaterm',
      \'coc-snippets',
      \'coc-html',
      \'coc-prettier',
      \'coc-spell-checker',
      \'coc-cspell-dicts',
      \'coc-css',
      \'coc-stylelint',
      \'coc-tag',
      \'coc-eslint',
      \'coc-tsserver',
      \'coc-bootstrap-classname',
      \'coc-texlab',
      \'coc-xml',
      \'coc-phpls',
      \'coc-emmet',
      \]

if !has('nvim')
    set viminfo+=~/.vim/viminfo
endif

set spell spelllang=es,en 
" autocmd BufEnter *.*  set nospell
" autocmd BufEnter *.tex  set spell


source $HOME/.config/nvim/vim-editor.vim 
source $HOME/.config/nvim/vim-mappings.vim
source $HOME/.config/nvim/vim-quickrun.vim
source $HOME/.config/nvim/vim-clip.vim  
source $HOME/.config/nvim/vim-startify.vim 
source $HOME/.config/nvim/vim-laf.vim
source $HOME/.config/nvim/vim-terminal.vim
source $HOME/.config/nvim/fzf.vim
source $HOME/.config/nvim/rn.vim
source $HOME/.config/nvim/vim-html.vim
source $HOME/.config/nvim/vim-snippets.vim
source $HOME/.config/nvim/git-gutter.vim
source $HOME/.config/nvim/vim-barbar.vim
luafile $HOME/.config/nvim/vim-lua.lua
luafile $HOME/.config/nvim/vim-lua-status.lua
luafile $HOME/.config/nvim/ident_line.lua

let g:suda_smart_edit = 1
nnoremap <silent> <leader>ag :ArgWrap<CR>
autocmd FileType javascript.jsx setlocal commentstring={/*\ %s\ */}
