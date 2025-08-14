return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require("telescope").setup({})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {
			desc = "Launch telescope with all files",
		})
		vim.keymap.set("n", "<leader>fp", builtin.git_files, {
			desc = "Launch telescope with only git files",
		})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
			desc = "Launch telescope with live grep",
		})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {
			desc = "Launch telescope with buffers",
		})
		vim.keymap.set("n", "<leader>fws", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>fWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>fs", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Launch telescope with grep as filter" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	end,
}

-- vim: ts=2 sts=2 sw=2 et
