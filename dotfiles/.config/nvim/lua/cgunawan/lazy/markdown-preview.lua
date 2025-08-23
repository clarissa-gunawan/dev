return {
  -- INFO: Enhance Editor Experience
  {
    "iamcco/markdown-preview.nvim", -- Markdown previewer
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- event = "VeryLazy",
    build = ":call mkdp#util#install()",
    config = function()
      -- Refresh markdown when saving the buffer or leaving insert mode
      vim.g.mkdp_refresh_slow = 1

      -- Fancy title
      vim.g.mkdp_page_title = "「${name}」"

      -- Dark mode (of course)
      vim.g.mkdp_theme = "dark"

      -- Avoid auto close
      vim.g.mkdp_auto_close = 0

      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_combine_preview_auto_refresh = 1

      vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "[M]arkdown [P]review Toggle" })
    end,
  },
}
