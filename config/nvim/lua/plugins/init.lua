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
    -- Packer can manage itself as an optional plugin
    use "wbthomason/packer.nvim"

    -- TODO refactor all of this (for now it works, but yes I know it could be wrapped in a simpler function)

    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      }
    }
    use 'b3nj5m1n/kommentary'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use "ryanoasis/vim-devicons"
    use "voldikss/vim-floaterm"    
    use "karb94/neoscroll.nvim"
    use {
      'NTBBloodbath/rest.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
    }
    -- Debugging
    use "mfussenegger/nvim-dap"
    -- Autocomplete
    use {"neoclide/coc.nvim", branch= "release"}
    use "hrsh7th/vim-vsnip"
    use "rafamadriz/friendly-snippets"

    -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use "windwp/nvim-ts-autotag"
    use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
    use {"junegunn/fzf.vim"}
    use {"antoinemadec/coc-fzf", branch =  "release"}

    -- Explorer
    use "sindrets/diffview.nvim"
    use "kevinhwang91/rnvimr"

    use {"mg979/vim-visual-multi", branch = "master"}
    use "norcalli/nvim-colorizer.lua"
    --use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}
    use "folke/which-key.nvim"
    use "windwp/nvim-autopairs"
    use "kevinhwang91/nvim-bqf"
    use "glepnir/dashboard-nvim"
    use "terrortylor/nvim-comment" 

    -- Color
    use "drewtempelmeyer/palenight.vim"
    use "folke/tokyonight.nvim"

    -- Icons
    use "kyazdani42/nvim-web-devicons"
    use "romgrk/barbar.nvim"

    use "hoob3rt/lualine.nvim"
    use "metakirby5/codi.vim"
    use "lervag/vimtex"
    use {"donRaphaco/neotex", ft = "tex" }
    use {"iamcco/markdown-preview.nvim",  run = "cd app && yarn install"  }
    use "lambdalisue/suda.vim"
    use "tpope/vim-dadbod"
    use "tpope/vim-surround"
    use "tpope/vim-dotenv"
    use "kristijanhusak/vim-dadbod-ui"



  end
)

