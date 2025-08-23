return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Python test adapter
      "nvim-neotest/neotest-python",
      -- Additional adapters for other languages
      "nvim-neotest/neotest-plenary",
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test: Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test: Run All Test Files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run Nearest",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test: Run Last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open { enter = true, auto_close = true }
        end,
        desc = "Test: Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test: Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test: Stop",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand "%")
        end,
        desc = "Test: Toggle Watch",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run { strategy = "dap" }
        end,
        desc = "Test: Debug Nearest",
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup {
        adapters = {
          require "neotest-python" {
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = {
              justMyCode = false,
              console = "integratedTerminal",
            },
            args = { "--log-level", "DEBUG", "--quiet" },
            runner = "pytest",
            -- Python path detection
            python = function()
              -- Try to detect virtual environment
              local venv_path = os.getenv "VIRTUAL_ENV"
              if venv_path then
                return venv_path .. "/bin/python"
              end
              -- Try poetry
              local handle = io.popen "poetry env info --path 2>/dev/null"
              if handle then
                local result = handle:read "*a"
                handle:close()
                if result and result ~= "" then
                  return vim.trim(result) .. "/bin/python"
                end
              end
              -- Try pipenv
              handle = io.popen "pipenv --venv 2>/dev/null"
              if handle then
                local result = handle:read "*a"
                handle:close()
                if result and result ~= "" then
                  return vim.trim(result) .. "/bin/python"
                end
              end
              -- Fallback to system python
              return "python3"
            end,
            -- pytest discovery
            pytest_discover_instances = true,
            -- Custom test discovery
            is_test_file = function(file_path)
              return vim.endswith(file_path, ".py") and (
                vim.startswith(vim.fn.fnamemodify(file_path, ":t"), "test_") or
                vim.endswith(file_path, "_test.py") or
                vim.endswith(file_path, "_tests.py") or
                string.find(file_path, "/tests/") ~= nil
              )
            end,
          },
          require "neotest-plenary",
        },
        -- Global configuration
        discovery = {
          concurrent = 1,
          enabled = true,
        },
        running = {
          concurrent = true,
        },
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        -- Icons configuration
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✓",
          running = "●",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "○",
          unknown = "?",
          watching = "👁",
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et