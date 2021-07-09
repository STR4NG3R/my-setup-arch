local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

--- Check if a file or directory exists in this path
local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath("data") .. "/site/pack/packer/opt/"

    local plugin_path = plugin_prefix .. plugin .. "/"
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
        vim.cmd("packadd " .. plugin)
    end
    return ok, err, code
end

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require("packer").startup(
  function(use)
    use 'kristijanhusak/vim-dadbod-completion'
    use "wbthomason/packer.nvim"
    use "neovim/nvim-lspconfig"
    use "glepnir/lspsaga.nvim"
    use "kabouzeid/nvim-lspinstall"
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      }
    }
    use 'akinsho/nvim-toggleterm.lua'
    use 'tpope/vim-commentary'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'voldikss/vim-floaterm'
    use 'karb94/neoscroll.nvim'
    use 'NTBBloodbath/rest.nvim'
    use 'monaqa/dial.nvim'
    -- Debugging
    use {
        "folke/trouble.nvim",
        cmd = 'TroubleToggle',
        disable = false
    }
    use "mfussenegger/nvim-dap"
    -- Autocomplete
    use "nvim-lua/popup.nvim"
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-fzy-native.nvim"
    use "hrsh7th/nvim-compe"
    use "hrsh7th/vim-vsnip"
    use "rafamadriz/friendly-snippets"
    use "andymass/vim-matchup"
    use "nacro90/numb.nvim"
    -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use "windwp/nvim-ts-autotag"
    use 'stevearc/vim-arduino'
    use {'edluffy/specs.nvim'}
    -- Explorer-
    use "kyazdani42/nvim-tree.lua"
    use "sindrets/diffview.nvim"
    use "kevinhwang91/rnvimr"

    use {"mg979/vim-visual-multi", branch = "master"}
    use "norcalli/nvim-colorizer.lua"
    --use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}
    use "folke/which-key.nvim"
    use "windwp/nvim-autopairs"
    use "moll/vim-node"
    use "kevinhwang91/nvim-bqf"
    use "glepnir/dashboard-nvim"
    use "ruanyl/vim-sort-imports"
    -- Color
    use "drewtempelmeyer/palenight.vim"
    use "folke/tokyonight.nvim"

    -- Icons
    use "kyazdani42/nvim-web-devicons"
    use "romgrk/barbar.nvim"

    use "hoob3rt/lualine.nvim"
    use "metakirby5/codi.vim"
    use {"donRaphaco/neotex", ft = "tex" }
    use {"iamcco/markdown-preview.nvim",  run = "cd app && yarn install"  }
    use "lambdalisue/suda.vim"
    use "tpope/vim-dadbod"
    use "tpope/vim-surround"
    use "tpope/vim-dotenv"
    use "kristijanhusak/vim-dadbod-ui"
    use "ahmedkhalf/lsp-rooter.nvim"
    use {
        'windwp/nvim-spectre',
        event = "BufRead",
        disable = false
    }
  end
)
