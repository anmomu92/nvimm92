-- Basado en: dotfiles de Piotr1215

local M = {}

local fun = vim.fn
local api = vim.api

--- Busca los comentarios del fichero actual
local function BuscaComentarios()
	local comentarios = {}

	-- Palabras clave
	local claves = { "TODO", "HACER", "BUG" }

	-- Recorremos todas las líneas del fichero
	for num_linea = 1, api.nvim_buf_line_count(0) do
		local linea_actual = api.nvim_buf_get_lines(0, num_linea - 1, num_linea, false)[1]

		-- Buscamos palabras clave
		for _,clave in ipairs(claves) do
			local patron = "^%s*[%-%/%#%*]+.*()" .. clave
			local indice_ini, indice_fin = string.find(linea_actual, patron)

			-- Si detectamos palabra clave, recogemos la descripción
			if indice_ini then
				local descripcion_tarea = string.sub(linea_actual, indice_fin + 3, string.len(linea_actual))
				table.insert(comentarios, {
					descripcion = descripcion_tarea,
					num_linea = num_linea,
				})
			end
		end
	end

	-- Devolvemos la tabla con los atributos de los comentarios
	return comentarios
end


--- Busca las tareas pendientes relacionadas con el fichero actual
local function BuscaTareas()
	local ruta_fichero = fun.expand "%:p"
	local tareas = {}

	-- Obtenemos el descriptor de fichero
	local manejador = io.popen("task +PENDING export")
	if not manejador then return {} end

	-- Abrimos el fichero con las tareas para lectura
	local salida = manejador:read("*a")
	manejador:close()

	-- Decodificamos las tareas
	local ok, lista_tareas = pcall(fun.json_decode, salida)
	if not ok or type(lista_tareas) ~= "table" then return {} end

	-- Extraemos la descripción, el número de línea y la ruta del fichero
	for _,tarea in ipairs(lista_tareas) do
		local desc = tarea.description
		local linea, ruta

		if tarea.annotations then
			for _, anotacion in ipairs(tarea.annotations) do
			  -- Busca un patrón tipo: nvim:51:/path/to/file.lua
			  local l, r = anotacion.description:match("nvim:(%d+):(.+)")
			  if l and r then
				linea = tonumber(l)
				ruta = r
				break
			  end
			end
		  end

		  if desc and linea and ruta == ruta_fichero then
			table.insert(tareas, {
			  descripcion = desc,
			  num_linea = linea,
			})
		  end
		end

		-- Devolvemos la tabla con los atributos de las tareas
		return tareas
end

local function shell_escape(str)
	return "'" .. str:gsub("'", "'\\''") .. "'"
end

--- Actualizar las tareas en función de los comentarios del fichero actual
function M.ActualizaTareas()
	local comentarios = BuscaComentarios()
	local tareas = BuscaTareas()
	local ruta = fun.expand "%:p"

	 -- Construimos una tabla de búsqueda para las tareas
	 local tareas_lookup = {}
	 for _, entrada in ipairs(tareas) do
	   local key = entrada.descripcion -- .. ":" .. tostring(entrada.num_linea)
	   tareas_lookup[key] = true
	 end

	 -- Comprobamos si existen comentarios en la tabla de búsqueda
	 for _, entrada in ipairs(comentarios) do
	   local key = entrada.descripcion -- .. ":" .. tostring(entrada.num_linea)

	   -- Si el comentario se encuentra, lo borramos de la tabla de tareas
	   if tareas_lookup[key] then
		   tareas_lookup[key] = nil
	   -- Sino, añadimos el comentario como tarea
	   else
		   local d = entrada.descripcion
		   local l = entrada.num_linea
		   local r = ruta

		   local anotacion = string.format("nvim:%s:%s", l, r)


		   local cmd_tarea = string.format("task add %s", shell_escape(d))
		   local cmd_anotacion = string.format("task +PENDING $(task _ids %s) annotate %s", shell_escape(d), shell_escape(anotacion))

		   local salida_tarea = fun.system(cmd_tarea)
		   print("Salida: ", salida_tarea)

		   if salida_tarea then
			   local salida_anotacion = fun.system(cmd_anotacion)
			   print(salida_anotacion)
		   else
			   print("Error: no se creó la tarea")
		   end
	   end
	 end

	 -- Las tareas restantes no estaban en los comentarios, por lo que se pueden borrar
	 for descripcion,_ in pairs(tareas_lookup) do
		local cmd_borrado = string.format("task +PENDING %s done", shell_escape(descripcion))

		local salida_borrado = fun.system(cmd_borrado)
		print("Salida: ", salida_borrado)
	 end
end

return M
