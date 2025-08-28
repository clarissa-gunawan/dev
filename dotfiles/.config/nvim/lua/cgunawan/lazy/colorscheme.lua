return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      vim.g.have_nerd_font = true
      require("nvim-web-devicons").setup(opts)
    end,
  },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    -- https://vimcolorschemes.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("tokyonight").setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Nord Theme
  {
    -- Nord Theme
    -- https://vimcolorschemes.com/gbprod/nord.nvim
    "gbprod/nord.nvim",
    lazy = false, -- Load immediately if you want to use it as default
    priority = 1000, -- High priority for colorschemes
    config = function()
      -- Optional: Configure Nord Settings
      --@diagnostic disable-next-line: missing-fields
      require("nord").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        diff = { mode = "bg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
        borders = true, -- Enable the border between vertically split windows visible
        errors = { mode = "bg" }, -- Display mode for errors and diagnostics
        -- values : [bg|fg|none]
        search = { theme = "vim" }, -- theme for highlighting search results
        -- values : [vim|vscode]
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          variables = { italic = false },
        },
      }
      -- vim.cmd.colorscheme 'nord'
    end,
  },
  {
    -- Iceberg Theme Original Cocopn
    -- https://vimcolorschemes.com/cocopon/iceberg.vim
    "cocopon/iceberg.vim",
    config = function()
      vim.cmd.colorscheme "iceberg"
      vim.o.background = "dark"
    end,
  },
  {
    -- Iceberg Theme Lua
    -- https://github.com/oahlen/iceberg.nvim
    "oahlen/iceberg.nvim",
    config = function()
      --vim.cmd.colorscheme "iceberg-dark"
    end,
  },
  {
    -- Nordic Theme warmer darker Nord
    -- https://vimcolorschemes.com/alexvzyl/nordic.nvim
    "AlexvZyl/nordic.nvim",
    config = function()
      --  vim.cmd.colorscheme "nordic"
    end,
  },
  {
    -- Vague Theme
    -- https://vimcolorschemes.com/vague2k/vague.nvim
    "vague2k/vague.nvim",
    config = function()
      -- vim.cmd.colorscheme "vague"
    end,
  },
  {
    -- Catppucin Theme
    -- https://vimcolorschemes.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        float = {
          transparent = false, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        auto_integrations = true,
        color_overrides = {
          all = {
            base = "#181825",
          },
        },
      }
      -- vim.cmd.colorscheme "catppuccin"
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
