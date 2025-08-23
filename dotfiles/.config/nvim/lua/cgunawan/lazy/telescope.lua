return {
  {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
  },
  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-tree/nvim-web-devicons", enabled = true },
    },

    config = function()
      require("telescope").setup {
        defaults = {
          -- Global settings for all pickers
          file_ignore_patterns = {
            "%.git/.*", -- Exclude .git directory and all its contents
            "node_modules/.*",
            "target/.*", -- Rust build directory
            "build/.*",
            "dist/.*",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension "fzf"

      local builtin = require "telescope.builtin"
      -- Files
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sF", function()
        builtin.find_files { hidden = true }
      end, { desc = "[S]earch [F]iles (including hidden)" })
      vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[S]earch [G]it files" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent files" })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })

      -- Text/Grep
      vim.keymap.set("n", "<leader>sl", builtin.live_grep, { desc = "[S]earch [L]ive grep" })
      vim.keymap.set("n", "<leader>sL", function()
        builtin.live_grep { additional_args = { "--hidden" } }
      end, { desc = "[S]earch [L]ive grep (including hidden)" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sW", function()
        local word = vim.fn.expand "<cWORD>"
        builtin.grep_string { search = word }
      end, { desc = "[S]earch current [W]ORD" })
      vim.keymap.set("n", "<leader>sp", function()
        builtin.grep_string { search = vim.fn.input "Grep > " }
      end, { desc = "[S]earch [P]rompt" })

      -- Telescope/System
      vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "[S]earch [T]elescope" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
