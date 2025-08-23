return {
  {
    -- Python-specific utilities and optimizations
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Use the regexp branch for better performance
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
  {
    -- Enhanced Python text objects and motions
    "jeetsukumaran/vim-pythonsense",
    ft = "python",
  },
  {
    -- Python docstring generator
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      {
        "<leader>nf",
        function()
          require("neogen").generate { type = "func" }
        end,
        desc = "Generate function docstring",
        ft = "python",
      },
      {
        "<leader>nc",
        function()
          require("neogen").generate { type = "class" }
        end,
        desc = "Generate class docstring",
        ft = "python",
      },
    },
    opts = {
      snippet_engine = "nvim",
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et