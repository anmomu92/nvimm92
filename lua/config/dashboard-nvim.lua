local function get_taskwarrior_tasks()
  local handle = io.popen(
	  "task +PENDING limit:5 rc.report.next.columns=description rc.report.next.labels=off rc.color=off rc.verbose=nothing"
  )

  if not handle then
	  return {}
  end

  local result = handle:read("*a")
  handle:close()
  local tasks = {}

  for line in result:gmatch("[^\r\n]+") do
    if #line > 0 and not line:match("^%s*$") then
      table.insert(tasks, "✓" .. line)
    end
  end

  return tasks
end

local function get_taskwarrior_tasks()
  local handle = io.popen("task +PENDING limit:5 export")
  if not handle then return {} end
  local output = handle:read("*a")
  handle:close()

  local ok, data = pcall(vim.fn.json_decode, output)
  if not ok or type(data) ~= "table" then return {" Failed to load tasks"} end

  local lines = {}
  for _, task in ipairs(data) do
    local desc = " " .. (task.description or "[No description]")
    table.insert(lines, desc)

    if task.annotation then
      -- For single annotation (older taskwarrior versions)
      table.insert(lines, "     " .. task.annotation)
    elseif task.annotations then
      -- For multiple annotations
      for _, a in ipairs(task.annotations) do
        if a.description then
          table.insert(lines, "     " .. a.description)
        end
      end
    end
  end

  return lines
end


-- HACER: tarea de prueba

require('dashboard').setup({
	theme = 'hyper',
	config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      {
        icon = '🗁',
        desc = ' Projects ',
        action = 'Telescope projects',
        key = 'p',
      },
      {
        icon = '🗎',
        desc = ' Recently used ',
        action = 'Telescope oldfiles',
        key = 'r',
      },
      {
        icon = ' ',
        desc = ' Change theme ',
        action = 'Telescope colorscheme',
        key = 't',
      },
    },
    footer = get_taskwarrior_tasks()
  }
})
