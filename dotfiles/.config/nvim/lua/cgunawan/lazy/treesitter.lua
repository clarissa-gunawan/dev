return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Install parsers
      require("nvim-treesitter").setup {
        ensure_installed = {
          "vimdoc",
          "javascript",
          "typescript",
          "c",
          "lua",
          "rust",
          "jsdoc",
          "bash",
          "go",
          "python",
          "cpp",
          "html",
          "markdown",
          "markdown_inline",
          "templ",
        },
        sync_install = false,
        auto_install = true,
      }

      -- Enable treesitter-based highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf = args.buf
          local ft = args.match

          -- Disable for html
          if ft == "html" then
            return
          end

          -- Disable for large files
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            vim.notify(
              "File larger than 100KB treesitter disabled for performance",
              vim.log.levels.WARN,
              { title = "Treesitter" }
            )
            return
          end

          -- Enable treesitter highlighting
          pcall(vim.treesitter.start, buf)
        end,
      })

      -- Enable additional vim regex highlighting for markdown
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function()
          vim.bo.syntax = "on"
        end,
      })

      -- Register templ filetype
      vim.treesitter.language.register("templ", "templ")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
  },
  -- Note: playground is deprecated, use built-in :InspectTree instead
}
-- vim: ts=2 sts=2 sw=2 et
