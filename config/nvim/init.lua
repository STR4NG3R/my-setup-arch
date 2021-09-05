require('plugins')
require('globals')
require('laf')

vim.cmd('source ~/.config/nvim/vim/clipboard/init.vim')
vim.cmd('source ~/.config/nvim/vim/keybindings/init.vim')
vim.cmd('source ~/.config/nvim/vim/commands/init.vim')
vim.cmd('source ~/.config/nvim/vim/init.vim')

require('nvim_which_key')
require('nvim_shade')
require('auto_commands')
require('nvim_diffview')
require('nvim_dashboard')
require('nvim_gitsigns')
require('nvim_treesitter')
require('nvim_neoscroll')
require('nvim_rnvimr')
require('nvim_utils')
require('nvim_compe')
require('nvim_lspinstall')
require('nvim_tree')
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
require('lsp.tailwindcss-ls')

vim.api.nvim_set_keymap('n', '<Tab>', ':BufferNext!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferPrevious!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c>', ':BufferClose!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-<RIGHT>>', ':BufferMoveNext!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-<LEFT>>', ':BufferMovePrevious!<CR>', { noremap = true, silent = true })

vim.g.floaterm_keymap_toggle = '<F1>'
vim.g.floaterm_keymap_next   = '<F2>'
vim.g.floaterm_keymap_prev   = '<F3>'
vim.g.floaterm_keymap_new    = '<F4>'
vim.g.floaterm_gitcommit='floaterm'
vim.g.floaterm_autoinsert=1
vim.g.floaterm_width=0.9
vim.g.floaterm_height=0.9
vim.g.floaterm_wintitle=0
vim.g.floaterm_autoclose=0
vim.g.floaterm_position="center"
