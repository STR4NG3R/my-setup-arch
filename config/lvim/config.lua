--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leCRader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-1>"] = ":DogeGenerate<CR>"
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

lvim.keys.visual_block_mode["go"] = "<Esc><Cmd>Sort<CR>"
vim.o.relativenumber = true
vim.o.guifont = "FiraCode Nerd Font:h8"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lvim.builtin.which_key.mappings["r"] = {
  name = "+Spectre",
  o = { "<cmd>lua require('spectre').open()<CR>", "Find and Replace" },
  f = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search Current Word" },
  d = { ":lua require('spectre').open_file_search()<CR>", "Search On File" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.direction = 'float'
lvim.builtin.terminal.insert_mappings = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.gitsigns.opts.current_line_blame = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumeko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "phaazon/hop.nvim", branch = "v2" },
  { "ggandor/lightspeed.nvim" },
  { "tpope/vim-surround" },
  { "kkoomen/vim-doge", run = ":call doge#install()" },
  { "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup()
    end
  },
  { "sQVe/sort.nvim" },
  { "ray-x/web-tools.nvim" },
  { 'windwp/nvim-spectre',
    config = function()
      require("pretty-fold").setup({
        color_devicons     = true,
        open_cmd           = 'vnew',
        live_update        = false, -- auto excute search again when you write any file in vim
        line_sep_start     = '┌-----------------------------------------',
        result_padding     = '¦  ',
        line_sep           = '└-----------------------------------------',
        highlight          = {
          ui = "String",
          search = "DiffChange",
          replace = "DiffDelete"
        },
        mapping            = {
          ['toggle_line'] = {
            map = "dd",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle current item"
          },
          ['enter_file'] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "goto current file"
          },
          ['send_to_qf'] = {
            map = "<leader>q",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all item to quickfix"
          },
          ['replace_cmd'] = {
            map = "<leader>c",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "input replace vim command"
          },
          ['show_option_menu'] = {
            map = "<leader>o",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "show option"
          },
          ['run_current_replace'] = {
            map = "<leader>rc",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "replace current line"
          },
          ['run_replace'] = {
            map = "<leader>R",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all"
          },
          ['change_view_mode'] = {
            map = "<leader>v",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "change result view mode"
          },
          ['change_replace_sed'] = {
            map = "trs",
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
            desc = "use sed to replace"
          },
          ['change_replace_oxi'] = {
            map = "tro",
            cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
            desc = "use oxi to replace"
          },
          ['toggle_live_update'] = {
            map = "tu",
            cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
            desc = "update change when vim write file."
          },
          ['toggle_ignore_case'] = {
            map = "ti",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "toggle ignore case"
          },
          ['toggle_ignore_hidden'] = {
            map = "th",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "toggle search hidden"
          },
          ['resume_last_search'] = {
            map = "<leader>l",
            cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
            desc = "resume last search before close"
          },
          -- you can put your mapping here it only use normal mode
        },
        find_engine        = {
          -- rg is map with finder_cmd
          ['rg'] = {
            cmd = "rg",
            -- default args
            args = {
              '--color=never',
              '--no-heading',
              '--with-filename',
              '--line-number',
              '--column',
            },
            options = {
              ['ignore-case'] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "ignore case"
              },
              ['hidden'] = {
                value = "--hidden",
                desc = "hidden file",
                icon = "[H]"
              },
              -- you can put any rg search option you want here it can toggle with
              -- show_option function
            }
          },
          ['ag'] = {
            cmd = "ag",
            args = {
              '--vimgrep',
              '-s'
            },
            options = {
              ['ignore-case'] = {
                value = "-i",
                icon = "[I]",
                desc = "ignore case"
              },
              ['hidden'] = {
                value = "--hidden",
                desc = "hidden file",
                icon = "[H]"
              },
            },
          },
        },
        replace_engine     = {
          ['sed'] = {
            cmd = "sed",
            args = nil,
            options = {
              ['ignore-case'] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "ignore case"
              },
            }
          },
          -- call rust code by nvim-oxi to replace
          ['oxi'] = {
            cmd = 'oxi',
            args = {},
            options = {
              ['ignore-case'] = {
                value = "i",
                icon = "[I]",
                desc = "ignore case"
              },
            }
          }
        },
        default            = {
          find = {
            --pick one of item in find_engine
            cmd = "rg",
            options = { "ignore-case" }
          },
          replace = {
            --pick one of item in replace_engine
            cmd = "sed"
          }
        },
        replace_vim_cmd    = "cdo",
        is_open_target_win = true, --open file on opener window
        is_insert_mode     = false -- start open panel on is_insert_mode
      })
    end
  }
}



-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})




local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.emmet_ls.setup({
  -- on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'javascript', 'typescript' },
})
