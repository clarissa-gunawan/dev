return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup()
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { desc = "Add file to harpoon" })

      -- Set <space>1..<space>5 be my shortcuts to moving to the files
      for _, idx in ipairs { 1, 2, 3, 4, 5 } do
        vim.keymap.set("n", string.format("<leader>%d", idx), function()
          harpoon:list():select(idx)
        end, { desc = string.format("Go to harpoon mark %d", idx) })
      end

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function()
        harpoon:list():prev()
      end, { desc = "Go to previous harpoon mark" })
      vim.keymap.set("n", "<C-S-N>", function()
        harpoon:list():next()
      end, { desc = "Go to next harpoon mark" })

      -- Basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set("n", "<leader>he", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
  },
}
