return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },

    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
      local fugitive_group = vim.api.nvim_create_augroup("fugitive_group", {})
      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufWinEnter", {
        group = fugitive_group,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end
          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git "push"
          end, { desc = "Git push" })

          -- NOTE: Rebase always
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git { "pull", "--rebase" }
          end, { desc = "Git pull (rebase)" })

          -- NOTE: Easily set the branch remotely
          vim.keymap.set("n", "<leader>t", ":Git push -u origin ", { desc = "Git push upstream" })
        end,
      })
      vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Get diff from left" })
      vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Get diff from right" })
    end,
  },

  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      }

      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk { "next" }
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk { "prev" }
          end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)

        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hi", gitsigns.preview_hunk_inline)

        map("n", "<leader>hb", function()
          gitsigns.blame_line { full = true }
        end)

        map("n", "<leader>hd", gitsigns.diffthis)

        map("n", "<leader>hD", function()
          gitsigns.diffthis { "~" }
        end)

        map("n", "<leader>hQ", function()
          gitsigns.setqflist { "all" }
        end)
        map("n", "<leader>hq", gitsigns.setqflist)

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>tw", gitsigns.toggle_word_diff)

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk)
      end
    end,
  },
}
