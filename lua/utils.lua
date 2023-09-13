local M = {}

M.map = function(mode, keys, cmd, opt)
	local options = { noremap = true, silent = true, nowait = true }
	if opt then
		options = vim.tbl_extend("force", options, opt)
	end

	-- all valid modes allowed for mappings
	-- :h map-modes
	local valid_modes = {
		[""] = true,
		["n"] = true,
		["v"] = true,
		["s"] = true,
		["x"] = true,
		["o"] = true,
		["!"] = true,
		["i"] = true,
		["l"] = true,
		["c"] = true,
		["t"] = true,
	}

	-- helper function for M.map
	-- can gives multiple modes and keys
	local function map_wrapper(mode, lhs, rhs, options)
		if type(lhs) == "table" then
			for _, key in ipairs(lhs) do
				map_wrapper(mode, key, rhs, options)
			end
		else
			if type(mode) == "table" then
				for _, m in ipairs(mode) do
					map_wrapper(m, lhs, rhs, options)
				end
			else
				if valid_modes[mode] and lhs and rhs then
					vim.keymap.set(mode, lhs, rhs, options)
				else
					mode, lhs, rhs = mode or "", lhs or "", rhs or ""
					print(
						"Cannot set mapping [ mode = '" .. mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]"
					)
				end
			end
		end
	end

	map_wrapper(mode, keys, cmd, options)
end

-- load plugin after entering vim ui
M.lazy_load = function(plugin)
	vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
		callback = function()
			local file = vim.fn.expand("%")
			local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

			if condition then
				vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

				-- dont defer for treesitter as it will show slow highlighting
				-- This deferring only happens only when we do "nvim filename"
				if plugin ~= "nvim-treesitter" then
					vim.schedule(function()
						require("lazy").load({ plugins = plugin })

						if plugin == "nvim-lspconfig" then
							vim.cmd("silent! do FileType")
						end
					end, 0)
				else
					require("lazy").load({ plugins = plugin })
				end
			end
		end,
	})
end

return M
