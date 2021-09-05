local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

--- Check if a file or directory exists in this path
local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath('data') .. '/site/pack/packer/opt/'

    local plugin_path = plugin_prefix .. plugin .. '/'
    --	print("test "..plugin_path)
    local ok, err, code = os.rename(plugin_path, plugin_path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    --	print(ok, err, code)
    if ok then
        vim.cmd('packadd ' .. plugin)
    end
    return ok, err, code
end

return require('packer').startup(
    function(use)
        use 'windwp/nvim-spectre'
        use 'beauwilliams/statusline.lua'
        use 'sunjon/shade.nvim'
        use 'ruanyl/vim-sort-imports'
        use 'voldikss/vim-floaterm'
        use 'romgrk/barbar.nvim'
        use 'APZelos/blamer.nvim'
        use 'kabouzeid/nvim-lspinstall'
        use 'folke/which-key.nvim'
        use 'kristijanhusak/vim-dadbod-completion'
        use 'wbthomason/packer.nvim'
        use 'neovim/nvim-lspconfig'
        use 'glepnir/lspsaga.nvim'
        use 'nvim-lua/plenary.nvim'
        use 'lewis6991/gitsigns.nvim'
        use 'akinsho/nvim-toggleterm.lua'
        use 'JoosepAlviste/nvim-ts-context-commentstring'
        use 'karb94/neoscroll.nvim'
        use 'NTBBloodbath/rest.nvim'
        use 'monaqa/dial.nvim'
        use 'nicwest/vim-camelsnek'
        -- Debugging
        use "folke/trouble.nvim"
        use "mfussenegger/nvim-dap"
        -- Autocomplete
        use 'nvim-lua/popup.nvim'
        use 'nvim-telescope/telescope.nvim'
        use 'nvim-telescope/telescope-fzy-native.nvim'
        use 'hrsh7th/nvim-compe'
        use 'hrsh7th/vim-vsnip'
        use 'rafamadriz/friendly-snippets' -- Treesitter
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
        use 'windwp/nvim-ts-autotag'
        -- Explorer-
        use 'kyazdani42/nvim-tree.lua'
        use 'sindrets/diffview.nvim'
        use 'kevinhwang91/rnvimr'
        use 'norcalli/nvim-colorizer.lua'
        use 'windwp/nvim-autopairs'
        use 'kevinhwang91/nvim-bqf'
        use 'glepnir/dashboard-nvim'
        use 'kazhala/close-buffers.nvim'
        -- Color
        use 'drewtempelmeyer/palenight.vim'
        use 'folke/tokyonight.nvim'
        use 'andymass/vim-matchup'
        use {
            'jamestthompson3/sort-import.nvim',
            config = function()
                require 'sort-import'.setup()
                require 'sort-import'.sort_import(true)
                -- for asynchronous sorting
            end
        }
        -- Icons
        use 'kyazdani42/nvim-web-devicons'
        use 'tpope/vim-dadbod'
        use 'tpope/vim-surround'
        use 'kristijanhusak/vim-dadbod-ui'
        use 'ahmedkhalf/lsp-rooter.nvim'
        use 'tpope/vim-commentary'
        use {
            'jose-elias-alvarez/nvim-lsp-ts-utils',
            ft = {
                'javascript',
                'javascriptreact',
                'javascript.jsx',
                'typescript',
                'typescriptreact',
                'typescript.tsx'
            }
        }
        use 'mfussenegger/nvim-jdtls'
    end
)

