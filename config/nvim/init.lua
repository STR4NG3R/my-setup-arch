require('plugins')
require('globals')
require('float_term')
require('keybindings')
require('laf')

vim.cmd('source ~/.config/nvim/vim/clipboard/init.vim')
vim.cmd('source ~/.config/nvim/vim/keybindings/init.vim')
vim.cmd('source ~/.config/nvim/vim/codi/init.vim')
vim.cmd('source ~/.config/nvim/vim/commands/init.vim')
vim.cmd('source ~/.config/nvim/vim/init.vim')

require('nvim_diffview')
require('nvim_barbar')
require('nvim_dashboard')
require('nvim_gitsigns')
require('nvim_treesitter')
require('nvim_neoscroll')
require('nvim_rnvimr')
require('nvim_kommentary')
require('nvim_utils')
require('auto_commands')
require('nvim_compe')
require('nvim_lspinstall')
require('nvim_status')
require('nvim_tree')
require('nvim_specs')
require('nvim__autopairs')
require('nvim_toggleterm')

require('lsp')
require('lsp.bash-ls')
require('lsp.lua-ls')
require('lsp.clangd')
require('lsp.efm-general-ls')
require('lsp.elm-ls')
require('lsp.emmet-ls')
require('lsp.html-ls')
require('lsp.json-ls')
require('lsp.js-ts-ls')
require('lsp.python-ls')
require('lsp.vim-ls')
require('lsp.java-ls')
