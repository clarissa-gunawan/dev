return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    priority = 900,
    config = function()
      require("oil").setup {
        default_file_explorer = true,
        columns = { "icon" },
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            local m = name:match "^%."
            return m ~= nil
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
          -- Sort file names with numbers in a more intuitive order for humans.
          -- Can be "fast", true, or false. "fast" will turn it off for large directories.
          natural_order = "fast",
          -- Sort file and directory names case insensitive
          case_insensitive = false,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { "type", "asc" },
            { "name", "asc" },
          },
          -- Customize the highlight group for the file name
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        delete_to_trash = true,
        keymaps = {
          ["gd"] = function()
            require("oil").set_columns { "icon", "permissions", "size", "mtime" }
          end,
          -- You can pass additional opts to vim.keymap.set by using
          -- a table with the mapping as the first element.
          ["<leader>ff"] = {
            function()
              require("telescope.builtin").find_files {
                cwd = require("oil").get_current_dir(),
              }
            end,
            mode = "n",
            nowait = true,
            desc = "Find files in the current directory",
          },
        },
      }
    end,

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
  },
  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },

  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },
}
