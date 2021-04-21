call plug#begin(expand('~/.config/nvim/plugged'))
"Synthax parsers, Formaters, Snippets
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'honza/vim-snippets'
Plug 'FooSoft/vim-argwrap'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Themes, Icons, Color Schemes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'folke/tokyonight.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
Plug 'hoob3rt/lualine.nvim'
Plug 'romgrk/barbar.nvim'
"Debug tools
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
"Latex Plugins
Plug 'lervag/vimtex'
Plug 'donRaphaco/neotex', { 'for': 'tex' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
"General Plugins
Plug 'windwp/nvim-ts-autotag'
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}
Plug 'tpope/vim-surround'
Plug 'metakirby5/codi.vim'
Plug 'psliwka/vim-smoothie'
Plug 'lambdalisue/suda.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim' " needed for previews
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-fugitive'
Plug 'glepnir/dashboard-nvim'
Plug 'b3nj5m1n/kommentary'
Plug 'airblade/vim-gitgutter'
" Plug 'sunjon/shade.nvim'
Plug 'dstein64/vim-startuptime'
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
      \'coc-markdownlint',
      \'coc-pairs',
      \]

if !has('nvim')
    set viminfo+=~/.vim/viminfo
endif

source $HOME/.config/nvim/vim-editor.vim 
source $HOME/.config/nvim/vim-mappings.vim
source $HOME/.config/nvim/vim-quickrun.vim
source $HOME/.config/nvim/vim-clip.vim  
source $HOME/.config/nvim/vim-laf.vim
source $HOME/.config/nvim/vim-terminal.vim
source $HOME/.config/nvim/fzf.vim
source $HOME/.config/nvim/rn.vim
source $HOME/.config/nvim/vim-snippets.vim
source $HOME/.config/nvim/git-gutter.vim
source $HOME/.config/nvim/vim-barbar.vim
source $HOME/.config/nvim/dashboard.vim
luafile $HOME/.config/nvim/vim-lua.lua
luafile $HOME/.config/nvim/status.lua
luafile $HOME/.config/nvim/ident_line.lua
" luafile $HOME/.config/nvim/shade.lua

let g:suda_smart_edit = 1
nnoremap <silent> <leader>ag :ArgWrap<CR>
autocmd FileType *.html let b:coc_pairs_diabled = ['<']
autocmd FileType *.jsx let b:coc_pairs_diabled = ['<']

let g:tokyonight_sidebars = [ "quickfix", "__vista__", "terminal" ]
