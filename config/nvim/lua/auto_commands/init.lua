local autocommands = {
  _general_settings = {
    {
      "TextYankPost",
      "*",
      "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
    },
    --[[{
      "BufWinEnter",
      "*",
      "WhichKey",
    },]]--
    {
      "BufWinEnter",
      "dashboard",
      "setlocal cursorline signcolumn=yes cursorcolumn number",
    },
    {
      "BufRead",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
    {
      "BufNewFile",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
    {
      "FileType",
      "qf",
      "set nobuflisted",
    },
  },
  _filetypechanges = {
    { "BufWinEnter", ".tf", "setlocal filetype=hcl" },
    { "BufRead", "*.tf", "setlocal filetype=hcl" },
    { "BufNewFile", "*.tf", "setlocal filetype=hcl" },
    { "BufWinEnter", ".zsh", "setlocal filetype=sh" },
    { "BufRead", "*.zsh", "setlocal filetype=sh" },
    { "BufNewFile", "*.zsh", "setlocal filetype=sh" },
    { "BufNewFile", "*.hbs", "setlocal filetype=html" },
  },
  _markdown = {
    { "FileType", "markdown", "setlocal wrap" },
    { "FileType", "markdown", "setlocal spell" },
  },
  _buffer_bindings = {
    { "FileType", "floaterm", "nnoremap <silent> <buffer> q :q<CR>" },
  },
  _auto_resize = {
    -- will cause split windows to be resized evenly if main window is resized
    { "VimResized", "*", "wincmd =" },
  },
  _packer_compile = {
    -- will cause split windows to be resized evenly if main window is resized
    { "BufWritePost", "plugins.lua", "PackerCompile" },
  },
  custom_groups = {},
  _general_lsp = {
    { "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
  },

}

function define_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd "autocmd!"
    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.cmd(command)
    end
    vim.cmd "augroup END"
  end
end

define_augroups(autocommands)
