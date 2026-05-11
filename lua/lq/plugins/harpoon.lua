return {
	{
		"ThePrimeagen/harpoon",
		event = "VimEnter",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")
			local map = vim.keymap.set
			map("n", "<leader>a", mark.add_file)
			map("n", "<C-k>", ui.toggle_quick_menu)

			map("n", "<leader>A", function()
				-- Check if in git repo
				local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")
				if vim.v.shell_error ~= 0 or #git_root == 0 then
					vim.notify("Not in a git repository", vim.log.levels.WARN)
					return
				end
				git_root = git_root[1]

				-- Clear existing marks
				mark.clear_all()

				-- Add git modified/untracked files
				local files = vim.fn.systemlist("git ls-files --modified --others --exclude-standard")
				local count = 0
				for _, file in ipairs(files) do
					local abs_path = git_root .. "/" .. file
					if vim.fn.filereadable(abs_path) == 1 then
						mark.add_file(abs_path)
						count = count + 1
					end
				end

				vim.notify("Added " .. count .. " modified file(s) to harpoon", vim.log.levels.INFO)
			end, { desc = "Add git modified files to harpoon" })

			map("n", "<A-l>", function()
				ui.nav_next()
			end)
			map("n", "<A-j>", function()
				ui.nav_prev()
			end)
			map("n", "<A-1>", function()
				ui.nav_file(1)
			end)
			map("n", "<A-2>", function()
				ui.nav_file(2)
			end)
			map("n", "<A-3>", function()
				ui.nav_file(3)
			end)
			map("n", "<A-4>", function()
				ui.nav_file(4)
			end)
		end,
	},
}
