return {
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require "wilder"
      wilder.setup { modes = { ":", "/", "?" } }

      wilder.set_option("pipeline", {
        wilder.branch(
          -- For command line (:) - use basic filter
          wilder.cmdline_pipeline {
            fuzzy = 1,
            -- Use basic Vim filter instead of lua_fzy
            fuzzy_filter = wilder.vim_fuzzy_filter(),
          },
          -- For search (/ and ?) - use lua_fzy which works
          wilder.vim_search_pipeline {
            fuzzy = 1,
            fuzzy_filter = wilder.lua_fzy_filter(),
          }
        ),
      })
    end,
  },
}
