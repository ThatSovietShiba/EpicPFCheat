local httpService = game:GetService('HttpService')

local ScriptManager = {} do
	ScriptManager.Folder = 'LinoriaLibSettings'
	ScriptManager.Ignore = {}
	ScriptManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = 'Toggle', idx = idx, value = object.Value } 
			end,
			Load = function(idx, data)
				if Toggles[idx] then 
					Toggles[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = 'Slider', idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		ColorPicker = {
			Save = function(idx, object)
				return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex() }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValueRGB(Color3.fromHex(data.value))
				end
			end,
		},
		KeyPicker = {
			Save = function(idx, object)
				return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue({ data.key, data.mode })
				end
			end,
		}
	}

	function ScriptManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function ScriptManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

	function ScriptManager:BuildFolderTree()
		local paths = {
			self.Folder,
			self.Folder .. '/themes',
			self.Folder .. '/configs',
			self.Folder .. '/Scripts'
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ScriptManager:RefreshScriptList()
		local slist = listfiles(self.Folder .. '/Scripts')

		local scripts = {}
		for i = 1, #slist do
			local file = slist[i]
			if file:sub(-5) == '.lua' then
				-- i hate this but it has to be done ...

				local pos = file:find('.lua', 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(scripts, file:sub(pos + 1, start - 1))
				end
			end
		end
		
		return scripts
	end

	function ScriptManager:SetLibrary(library)
		self.Library = library
	end

	function ScriptManager:BuildConfigSection(tab)
		assert(self.Library, 'Must set ScriptManager.Library')

		local section = tab:AddRightGroupbox('Scripts')

		section:AddDropdown('ScriptManager_ScriptList', { Text = 'Script list', Values = self:RefreshScriptList(), AllowNull = true })

		section:AddDivider()

		section:AddButton('Refresh config list', function()
			Options.ScriptManager_ScriptList.Values = self:RefreshConfigList()
			Options.ScriptManager_ScriptList:SetValues()
			Options.ScriptManager_ScriptList:SetValue(nil)
		end)


		ScriptManager:SetIgnoreIndexes({ 'ScriptManager_ConfigList', 'ScriptManager_ConfigName' })
	end

	ScriptManager:BuildFolderTree()
end

return ScriptManager
