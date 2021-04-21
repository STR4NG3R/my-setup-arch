require "nvim-treesitter.configs".setup {
  autotag = {
    enable = true
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false -- Whether the query persists across vim sessions
  }
}
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"java", "cpp", "javascript", "typescript", "python", "json", "php"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
require'colorizer'.setup()
DEFAULT_OPTIONS = {
RGB      = true;         -- #RGB hex codes
RRGGBB   = true;         -- #RRGGBB hex codes
names    = true;         -- "Name" codes like Blue
RRGGBBAA = true;        -- #RRGGBBAA hex codes
rgb_fn   = true;        -- CSS rgb() and rgba() functions
hsl_fn   = true;        -- CSS hsl() and hsla() functions
css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
-- Available modes: foreground, background
mode     = 'foreground'; -- Set the display mode.
}
