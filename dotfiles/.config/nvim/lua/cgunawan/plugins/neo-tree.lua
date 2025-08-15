return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			close_on_start = true,
			close_if_last_window = true,
			filesystem = {
				follow_current_file = { enable = true },
				filtered_items = {
					visible = false,
					hide_gitignored = false,
					hide_hidden = false,
					hide_dotfiles = false,
				},
			},
			window = {
				mapping = {
					["\\"] = "close_window",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		},
		keys = {
			{ "\\", "<CMD>Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
			{ "<leader>e", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle", silent = true },
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git Explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer Explorer",
			},
		},
	},
}
