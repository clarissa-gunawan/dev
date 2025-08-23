return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",
      -- Required dependency for nvim-dap-ui
      "nvim-neotest/nvim-nio",
      -- Installs the debug adapters for you
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      -- Python debugger
      "mfussenegger/nvim-dap-python",
    },
    keys = function(_, keys)
      local dap = require "dap"
      local dapui = require "dapui"
      return {
        -- Basic debugging keymaps
        { "<F5>", dap.continue, desc = "Debug: Start/Continue" },
        { "<F1>", dap.step_into, desc = "Debug: Step Into" },
        { "<F2>", dap.step_over, desc = "Debug: Step Over" },
        { "<F3>", dap.step_out, desc = "Debug: Step Out" },
        { "<leader>b", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
        {
          "<leader>B",
          function()
            dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
          end,
          desc = "Debug: Set Breakpoint",
        },
        -- Toggle to see last session result
        { "<F7>", dapui.toggle, desc = "Debug: See last session result." },
        unpack(keys),
      }
    end,
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      require("mason-nvim-dap").setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          "debugpy", -- Python debugger
        },
      }

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Python DAP configuration
      require("dap-python").setup("debugpy")
      
      -- Python debugging configurations
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " ")
        end,
        console = "integratedTerminal",
        cwd = "${workspaceFolder}",
        pythonPath = function()
          -- Try to detect virtual environment
          local venv_path = os.getenv("VIRTUAL_ENV")
          if venv_path then
            return venv_path .. "/bin/python"
          end
          -- Fallback to system python
          return "/usr/bin/python3"
        end,
      })

      -- Django debugging configuration
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Django",
        program = "${workspaceFolder}/manage.py",
        args = { "runserver", "--noreload" },
        console = "integratedTerminal",
        django = true,
        cwd = "${workspaceFolder}",
        pythonPath = function()
          local venv_path = os.getenv("VIRTUAL_ENV")
          if venv_path then
            return venv_path .. "/bin/python"
          end
          return "/usr/bin/python3"
        end,
      })

      -- Flask debugging configuration
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Flask",
        module = "flask",
        env = {
          FLASK_APP = "${workspaceFolder}/app.py",
          FLASK_ENV = "development",
        },
        args = { "run", "--no-debugger", "--no-reload" },
        console = "integratedTerminal",
        cwd = "${workspaceFolder}",
        pythonPath = function()
          local venv_path = os.getenv("VIRTUAL_ENV")
          if venv_path then
            return venv_path .. "/bin/python"
          end
          return "/usr/bin/python3"
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et