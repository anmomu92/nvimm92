-- Based upon: Piotr1215's dotfiles

local M = {}

local fun = vim.fn
local api = vim.api

--- Search for current files' comments
local function SearchComments()
	local comments = {}

	-- Keywords
	local keys = { "TODO", "HACER", "BUG" }

	-- Traverse every line
	for line_number = 1, api.nvim_buf_line_count(0) do
		local current_line = api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

		-- Buscamos palabras key
		for _,key in ipairs(keys) do
			local pattern = "^%s*[%-%/%#%*]+.*()" .. key
			local start_index, end_index = string.find(current_line, pattern)

			-- If detect keyworkd, catch description
			if start_index then
				local task_description = string.sub(current_line, end_index + 3, string.len(current_line))
				table.insert(comments, {
					description = task_description,
					line_number = line_number,
				})
			end
		end
	end

	-- Devolvemos la tabla con los atributos de los comments
	return comments
end


--- Search for pending tasks related to current file
local function SearchTasks()
	local filepath = fun.expand "%:p"
	local tasks = {}

	-- Obtain file handler
	local handler = io.popen("task +PENDING export")
	if not handler then return {} end

	-- Open file to read its tasks
	local output = handler:read("*a")
	handler:close()

	-- Decode tasks
	local ok, task_list = pcall(fun.json_decode, output)
	if not ok or type(task_list) ~= "table" then return {} end

	-- Extract description, line number and filepath
	for _,task in ipairs(task_list) do
		local desc = task.description
		local line, path

		if task.annotations then
			for _, annotation in ipairs(task.annotations) do
			  -- Seach for a pattern like: nvim:51:/path/to/file.lua
			  local l, p = annotation.description:match("nvim:(%d+):(.+)")
			  if l and p then
				line = tonumber(l)
				path = p
				break
			  end
			end
		  end

		  if desc and line and path == filepath then
			table.insert(tasks, {
			  description = desc,
			  line_number = line,
			})
		  end
		end

		-- Return table with task attributes
		return tasks
end

-- List projects

local function shell_escape(str)
	return "'" .. str:gsub("'", "'\\''") .. "'"
end

--- Update task in function of current file's comments
function M.UpdateTasks()
	local comments = SearchComments()
	local tasks = SearchTasks()
	local path = fun.expand "%:p"

	 -- Build a lookup table for tasks
	 local tasks_lookup = {}
	 for _, input in ipairs(tasks) do
	   local key = input.description -- .. ":" .. tostring(input.line_number)
	   tasks_lookup[key] = true
	 end

	 -- Check if there are comments in the lookup table
	 for _, input in ipairs(comments) do
	   local key = input.description -- .. ":" .. tostring(input.line_number)

	   -- If comment found, delete it from lookup table
	   if tasks_lookup[key] then
		   tasks_lookup[key] = nil
	   -- Else, add comment as task
	   else
		   local d = input.description
		   local l = input.line_number
		   local p = path

		   local annotation = string.format("nvim:%s:%s", l, p)


		   local task_cmd = string.format("task add %s", shell_escape(d))
		   local cmd_annotation = string.format("task +PENDING $(task _ids %s) annotate %s", shell_escape(d), shell_escape(annotation))

		   local task_output = fun.system(task_cmd)
		   print("Output: ", task_output)

		   if task_output then
			   local annotation_output = fun.system(cmd_annotation)
			   print(annotation_output)
		   else
			   print("Error: task not created")
		   end
	   end
	 end

	 -- As remaining tasks where not in the comments, we can delete them
	 for description,_ in pairs(tasks_lookup) do
		local delete_cmd = string.format("task +PENDING %s done", shell_escape(description))

		local delete_output = fun.system(delete_cmd)
		print("Output: ", delete_output)
	 end
end

return M
