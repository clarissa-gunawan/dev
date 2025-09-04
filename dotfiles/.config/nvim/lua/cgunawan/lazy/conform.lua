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
      format_on_save = {
        pattern = "*.{lua,python,yaml,json,md,sh,bash,c,cpp,rust,go,js,ts,html,css,scss,xml,cmake,ansible}",
        timeout_ms = 500,
        lsp_format = "fallback",
      },
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
        -- Apply to all files as fallback
        ["_"] = { "trim_whitespace", "trim_newlines" },
        -- You can use 'stop_after_first' to run the first available formatter from the list
      },
      formatters = {
        shfmt = {
          command = "shfmt",
          args = { "-i", "2", "-ci", "-w", "80" }, -- Example args: indent 2 spaces, compact if-statements
          stdin = true, -- shfmt can work with stdin for formatting
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
