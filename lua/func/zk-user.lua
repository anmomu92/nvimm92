local M = {}

-- Replace every literal occurrence of `find` with `repl` (no pattern magic)
function M.gsub_plain(s, find, repl)
	local out, i, n = {}, 1, 0
	while true do
		local a, b = s:find(find, i, true)
		if not a then
			break
		end
		out[#out + 1] = s:sub(i, a - 1)
		out[#out + 1] = repl
		i, n = b + 1, n + 1
	end
	out[#out + 1] = s:sub(i)
	return table.concat(out), n
end

function M.apply_subs(s, subs)
	local total = 0
	for _, sub in ipairs(subs) do
		local res, n = M.gsub_plain(s, sub[1], sub[2])
		s, total = res, total + n
	end
	return s, total
end

function M.update_links(old_name, new_name, skip)
	local notebook = vim.env.ZK_NOTEBOOK_DIR
	if not notebook or notebook == "" then
		return
	end
	notebook = vim.fs.normalize(notebook)

	local old_stem = old_name:gsub("%.md$", "")
	local new_stem = new_name:gsub("%.md$", "")

	local subs = {
		{ old_name, new_name },
		{ "[[" .. old_stem .. "]]", "[[" .. new_stem .. "]]" },
		{ "[[" .. old_stem .. "|", "[[" .. new_stem .. "|" },
	}

	local touched = 0
	local handled = {}

	-- 1. Buffers with unsaved changes: rewrite in memory, leave them modified
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
			local path = vim.api.nvim_buf_get_name(buf)
			if path ~= "" then
				path = vim.fs.normalize(path)
				if path ~= skip and path:match("%.md$") and vim.startswith(path, notebook) then
					handled[path] = true
					local changed = false
					local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
					for i, line in ipairs(lines) do
						local new_line, n = M.apply_subs(line, subs)
						if n > 0 then
							vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { new_line })
							changed = true
						end
					end
					if changed then
						touched = touched + 1
					end
				end
			end
		end
	end

	-- 2. Everything else: rewrite on disk
	local files = vim.fs.find(function(name)
		return name:match("%.md$")
	end, { path = notebook, type = "file", limit = math.huge })

	for _, path in ipairs(files) do
		path = vim.fs.normalize(path)
		if path ~= skip and not handled[path] then
			local f = io.open(path, "r")
			if f then
				local content = f:read("*a")
				f:close()
				local new_content, n = M.apply_subs(content, subs)
				if n > 0 then
					local w = io.open(path, "w")
					if w then
						w:write(new_content)
						w:close()
						touched = touched + 1
					end
				end
			end
		end
	end

	if touched > 0 then
		vim.cmd("checktime")
		vim.notify(("Updated links in %d file(s)"):format(touched))
	end
end

return M
