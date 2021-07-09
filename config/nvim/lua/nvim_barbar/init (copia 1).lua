-- vim.api.nvim_set_keymap('n', '<Tab>', ':BufferNext!<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<S-TAB>', ':BufferPrevious!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-c>', ':BufferClose!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', ':BufferPick!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-<RIGHT>>', ':BufferMoveNext!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-<LEFT>>', ':BufferMovePrevious!<CR>', { noremap = true, silent = true })


local tree ={}
tree.open = function ()
   require'bufferline.state'.set_offset(31, 'FileTree')
   require'nvim-tree'.find_file(true)
end

tree.close = function ()
   require'bufferline.state'.set_offset(0)
   require'nvim-tree'.close()
end

return tree
