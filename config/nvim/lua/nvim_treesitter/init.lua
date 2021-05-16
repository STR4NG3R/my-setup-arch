require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  autotag = {
    enable = true
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  playground = {enable = true},
  indent = {enable = true},
  context_commentstring = {enable = true},
  rainbow = {enable = true}
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

