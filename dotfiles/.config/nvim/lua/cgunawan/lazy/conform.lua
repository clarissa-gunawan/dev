return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Get the file extension and filetype
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local ft = vim.bo[bufnr].filetype

        -- Check for shebang in the first line
        local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        local is_shell_script = first_line:match "^#!.*/(bash|sh|zsh)"

        -- File types that should be formatted
        local format_filetypes = {
          "lua",
          "python",
          "yaml",
          "json",
          "markdown",
          "sh",
          "bash",
          "zsh",
          "c",
          "cpp",
          "rust",
          "go",
          "javascript",
          "typescript",
          "html",
          "css",
          "scss",
          "xml",
          "cmake",
          "ansible",
        }

        -- File extensions that should be formatted
        local format_extensions = {
          "%.lua$",
          "%.py$",
          "%.yaml$",
          "%.yml$",
          "%.json$",
          "%.md$",
          "%.sh$",
          "%.bash$",
          "%.c$",
          "%.cpp$",
          "%.h$",
          "%.hpp$",
          "%.rs$",
          "%.go$",
          "%.js$",
          "%.ts$",
          "%.html$",
          "%.css$",
          "%.scss$",
          "%.xml$",
        }

        -- Check if filetype matches
        for _, format_ft in ipairs(format_filetypes) do
          if ft == format_ft then
            return {
              timeout_ms = 500,
              lsp_format = "fallback",
            }
          end
        end

        -- Check if it's a shell script by shebang
        if is_shell_script then
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end

        -- Check file extensions as fallback
        for _, pattern in ipairs(format_extensions) do
          if bufname:match(pattern) then
            return {
              timeout_ms = 500,
              lsp_format = "fallback",
            }
          end
        end

        return nil
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        go = { "gofumpt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        xml = { "prettierd", "prettier", stop_after_first = true },
        ansible = { "prettierd", "prettier" },
        cmake = { "prettierd", "prettier" },
        yaml = { "yamlfmt", "yamlfix", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        -- Apply to all files as fallback
        ["_"] = { "trim_whitespace", "trim_newlines" },
        -- You can use 'stop_after_first' to run the first available formatter from the list
      },
      formatters = {
        shfmt = {
          command = "shfmt",
          args = { "-i", "2", "-ci" }, -- 2 spaces indent, compact if-statements
          stdin = true, -- shfmt can work with stdin for formatting
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
