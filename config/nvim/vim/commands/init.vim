command! LspCodeAction lua require 'nvim_utils'.code_action()
command! LspDeclaration lua require 'nvim_utils'.declaration()
command! LspDefinition lua require 'nvim_utils'.definition()
command! LspDocumentSymbol lua require 'nvim_utils'.document_symbol()
command! LspFormatting lua require 'nvim_utils'.formatting()
command! LspFormattingSync lua require 'nvim_utils'.formatting_sync()
command! LspHover lua require 'nvim_utils'.hover()
command! LspImplementation lua require 'nvim_utils'.implementation()
command! LspRangeCodeAction lua require 'nvim_utils'.range_code_action()
command! LspRangeFormatting lua require 'nvim_utils'.range_formatting()
command! LspReferences lua require 'nvim_utils'.references()
command! LspRename lua require 'nvim_utils'.rename()
command! LspTypeDefinition lua require 'nvim_utils'.type_definition()
command! LspWorkspaceSymbol lua require 'nvim_utils'.workspace_symbol()
command! LspGotoNext lua require 'nvim_utils'.goto_next()
command! LspGotoPrev lua require 'nvim_utils'.goto_prev()
command! LspShowLineDiagnostics lua require 'nvim_utils'.show_line_diagnostics()
command! NextHunk lua require 'nvim_utils'.next_hunk()
command! PrevHunk lua require 'nvim_utils'.prev_hunk()
command! StageHunk lua require 'nvim_utils'.stage_hunk()
command! UndoStageHunk lua require 'nvim_utils'.undo_stage_hunk()
command! ResetHunk lua require 'nvim_utils'.reset_hunk()
command! ResetBuffer lua require 'nvim_utils'.reset_buffer()
command! PreviewHunk lua require 'nvim_utils'.preview_hunk()
command! BlameLine lua require 'nvim_utils'.blame_line()
command! W noa w

" Debugging
command! DebugToggleBreakpoint lua require'dap'.toggle_breakpoint()
command! DebugStart lua require'dap'.continue()
command! DebugContinue lua require'dap'.continue()
command! DebugStepOver lua require'dap'.step_over()
command! DebugStepOut lua require'dap'.step_out()
command! DebugStepInto lua require'dap'.step_into()
command! DebugToggleRepl lua require'dap'.repl.toggle()
command! DebugGetSession lua require'dap'.session()

" Available Debug Adapters:
"   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
" 
" Adapter configuration and installation instructions:
"   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
" 
" Debug Adapter protocol:
"   https://microsoft.github.io/debug-adapter-protocol/

" TODO Add full support later
" nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
" nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
" nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
" nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
" nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
" nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
" nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
" nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
" nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>

autocmd! User GoyoEnter lua require('gitsigns').toggle_signs()
autocmd! User GoyoLeave lua require('gitsigns').toggle_signs()

autocmd User GoyoEnter set laststatus=0 
autocmd User GoyoLeave set laststatus=2
