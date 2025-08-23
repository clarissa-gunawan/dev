return {
  { -- ROS2 related plugin
    "ErickKramer/nvim-ros2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      autocmds = true,
      telescope = true,
      treesitter = true,
    },
    config = function()
      -- ====================================================
      -- ROS 2 related commands
      -- ====================================================
      vim.keymap.set("n", "<leader>li", ":Telescope ros2 interfaces<CR>", { desc = "[ROS 2]: List interfaces" })
      vim.keymap.set("n", "<leader>ln", ":Telescope ros2 nodes<CR>", { desc = "[ROS 2]: List nodes" })
      vim.keymap.set("n", "<leader>la", ":Telescope ros2 actions<CR>", { desc = "[ROS 2]: List actions" })
      vim.keymap.set("n", "<leader>lt", ":Telescope ros2 topics<CR>", { desc = "[ROS 2]: List topics" })
      vim.keymap.set("n", "<leader>ls", ":Telescope ros2 services<CR>", { desc = "[ROS 2]: List services" })
      vim.api.nvim_command [[
            command! ColconBuild :! CC=clang CXX=clang++ colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        ]]
      vim.api.nvim_command [[
            command! -nargs=1 ColconBuildSingle :! CC=clang CXX=clang++ colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --packages-up-to <args>
        ]]
      vim.api.nvim_command [[
            command! ColconBuildDebug :! CC=clang CXX=clang++ colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug
        ]]
      vim.api.nvim_command [[
           command! -nargs=1 ColconBuildDebugSingle :! CC=clang CXX=clang++ colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug --packages-up-to <args>
        ]]

      -- Test
      vim.api.nvim_command [[
            command! ColconTest :! colcon test
        ]]
      vim.api.nvim_command [[
            command! -nargs=1 ColconTestSingle :! colcon test --packages-select <args>
        ]]
      vim.api.nvim_command [[
            command! ColconTestResult :! colcon test-result --all
        ]]
    end,
  },
}
