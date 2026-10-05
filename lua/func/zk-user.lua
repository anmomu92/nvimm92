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

function M.update_links(old_name, new_name, skip)
	local notebook = vim.env.ZK_NOTEBOOK_DIR
	if not notebook or notebook == "" then
		return
	end

	local old_stem = old_name:gsub("%.md$", "")
	local new_stem = new_name:gsub("%.md$", "")

	local subs = {
		{ old_name, new_name }, -- (avek-bash-shell.md)
		{ "[[" .. old_stem .. "]]", "[[" .. new_stem .. "]]" }, -- [[avek-bash-shell]]
		{ "[[" .. old_stem .. "|", "[[" .. new_stem .. "|" }, -- [[avek-bash-shell|Bash]]
	}

	local files = vim.fs.find(function(name)
		return name:match("%.md$")
	end, { path = notebook, type = "file", limit = math.huge })

	local touched = 0
	for _, path in ipairs(files) do
		if path ~= skip then
			local f = io.open(path, "r")
			if f then
				local content = f:read("*a")
				f:close()
				local total = 0
				for _, s in ipairs(subs) do
					local res, n = M.gsub_plain(content, s[1], s[2])
					content, total = res, total + n
				end
				if total > 0 then
					local w = io.open(path, "w")
					if w then
						w:write(content)
						w:close()
						touched = touched + 1
					end
				end
			end
		end
	end

	if touched > 0 then
		vim.cmd("checktime") -- reload any affected buffers that are open
		vim.notify(("Updated links in %d file(s)"):format(touched))
	end
end

return M
