-- Asistido por: chatGPT

local M = {}

local cmd = vim.cmd
local fun = vim.fn
local api = vim.api


local function taskwarrior_section()
  local handle = io.popen("task +PENDING rc.json.array=on annotations.any: export")
  if not handle then return {} end

  local output = handle:read("*a")
  handle:close()

  local ok, tasks = pcall(fun.json_decode, output)
  if not ok or type(tasks) ~= "table" then return {} end

  local section = {
    { type = "padding", val = 1 },
    { type = "text", val = "TASKS", opts = { hl = "SpecialComment", position = "left" } },
    { type = "padding", val = 1 },
  }

  local task_shortcut_prefix = "<leader>t"  -- e.g., <leader>t1, <leader>t2, ...
  local keymap = {}  -- store key mappings to register later

  local index = 1

  for i, task in ipairs(tasks) do
    local desc = task.description or "[No description]"
    local file_to_open = nil

    if task.annotations then
      for _, ann in ipairs(task.annotations) do
		  local text = ann.description or ""
		  local filepath = text:match(".*:(.+)$")
		  if filepath then
			  filepath = fun.expand(filepath)
			  if fun.filereadable(filepath) == 1 then
				  file_to_open = filepath
			  end
		  end
      end
    end

	if file_to_open then
		local shortcut_key = task_shortcut_prefix .. tostring(index)

		-- Map manually (to be registered later)
		keymap[shortcut_key] = function()
			cmd("edit " .. fun.fnameescape(file_to_open))
		end

		local display = string.format(" %s", desc)

		table.insert(section, {
		  type = "button",
		  val = display,
		  on_press = keymap[shortcut_key],
		  opts = {
			position = "left",
			shortcut = "(" .. tostring(i) .. ") ",
			cursor = 1,
			width = 50,
			highlight = "SpecialComment",
			align_shortcut = "left",
			hl_shortcut = {
				{"Operator", 0, 1},
				{"Number", 1, 2},
				{"Operator", 2, 3},
			},
		  },
		})

		index = index + 1
	  end
	end



  return {
    type = "group",
    val = section,
    opts = { position = "center" },
  }
end

function M.setup()
  local alpha = require("alpha")
  local startify = require("alpha.themes.startify")

  local layout = startify.config.layout

  -- Find index of section_mru and insert before it
  local insert_index = 1
  for i, item in ipairs(layout) do
    if item == startify.section.mru then
      insert_index = i
      break
    end
  end

  table.insert(layout, insert_index-1, taskwarrior_section())

  alpha.setup(startify.config)
end

return M

