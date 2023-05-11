local cmd = vim.cmd

-- bufferline
cmd("silent! command BufferKill lua require('plugins.configs.bufferline').buf_kill('bd') ")
cmd("silent! command BufferCloseAllButCurrent lua require('plugins.configs.bufferline').buf_kill_others('bd') ")
