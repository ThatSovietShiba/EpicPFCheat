local httpService = game:GetService('HttpService')

local ScriptManager = {} do
	ScriptManager.Folder = 'LinoriaLibSettings'
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
			local sfile = slist[i]
			if sfile:sub(-5) == '.lua' then
				-- i hate this but it has to be done ...

				local pos = sfile:find('.lua', 1, true)
				local start = pos

				local char = sfile:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = sfile:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(scripts, sfile:sub(pos + 1, start - 1))
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
			Options.ScriptManager_ScriptList.Values = self:RefreshScriptList()
			Options.ScriptManager_ScriptList:SetValues()
			Options.ScriptManager_ScriptList:SetValue(nil)
		end)


		ScriptManager:SetIgnoreIndexes({ 'ScriptManager_ConfigList', 'ScriptManager_ConfigName' })
	end

	ScriptManager:BuildFolderTree()
end

return ScriptManager
