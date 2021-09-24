local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = KYA:GetModule('UnitFrames');
local ElvUI_UF = E:GetModule('UnitFrames');
local unpack = unpack
local CreateFrame = CreateFrame

UF.Treshholds = {

}
UF.Timers = {
	[1] = {
		r = 1,
		g = 1,
		b = 1,
	},
	[2] = {
		r = 1,
		g = 1,
		b = 1,
	},
	[3] = {
		r = 1,
		g = 1,
		b = 1,
	},
	[4] = {
		r = 1,
		g = 1,
		b = 1,
	},
	[5] = {
		r = 1,
		g = 1,
		b = 1,
	},
}
local function Swap(a,b)
	local c = a;
	a = b;
	b = c;
	return a,b
end
local function PrintTableKeys(t)
	table.foreach(t, function(k,v)
		print(k)
	end)
end
local function ToIndexedTable(t)
	local index, indexedTable = 1, {}	
	table.foreach(t, function(k,v)
		indexedTable[index] = v
		index = index + 1
	end)
	return indexedTable
end
local function GetItemsByKeys(t, keys)
	local extractedTable = {}
	table.foreach(t, function(k,v)		
		for i = 1, #keys do	
			if k == keys[i] then
				extractedTable[keys[i]] = v
			end
		end
	end)
	return extractedTable
end
local function FilterEnabledThresholdGroups(t)
	local t2 = {}	
	table.foreach(t,function(k,v)
		if v.enabled then
			t2[k] = v
		end
	end)
	return t2
end
--[[
	function: SelectionSort
		arg1: Table t
		arg2: Boolean ASC (if ASC is nil or false then the default Direction is DESC)
	 
		Example Usage: 
	 		SelectionSort(t, true) -> Ascended Sort
	 		SelectionSort(t) -> Descended Sort
	 		SelectionSort(t, false) -> Descended Sort
	]] 
local function SelectionSort(t, ASC)
	local index_klein, wert, wert_klein;
	-- Schleife wird von links nach rechts durchlaufen. 
	for index = 1, #t, 1 do
	  	--aktuelle Position 
	  	wert=index;
	   	--[[Schleife läuft durch bis ein kleineres Element als
		* die aktuelle Position gefunden wurde oder bis zum Ende,
		* was bedeutet, die aktuelle Position ist schon
		* das kleinste Element.]]
	   	for index_klein = index+1, #t do
			-- Ein kleineres Element gefunden?			
			
			if ASC and ASC == true and (t[index_klein].colorThreshold < t[wert].colorThreshold) then
				-- Neues kleinstes Element
				wert=index_klein;
			elseif not ASC and (t[index_klein].colorThreshold > t[wert].colorThreshold) then
				-- Neues kleinstes Element
				wert=index_klein;
			end
		end
	   	--[[kleinstes Element an die aktuelle
			* Position falls nötig]]
		if wert ~= index then
			t[wert],t[index] = Swap(t[wert],t[index])
		end
	end
	return t
end
function UF:Construct_AuraWatch(frame)
	local auras = CreateFrame('Frame', frame:GetName() .. 'AuraWatch', frame)
	auras:SetFrameLevel(frame.RaisedElementParent:GetFrameLevel() + 10)
	auras:SetInside(frame.Health)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.strictMatching = true;
	auras.PostCreateIcon = UF.BuffIndicator_PostCreateIcon
	auras.PostUpdateIcon = UF.BuffIndicator_PostUpdateIcon

	return auras
end
function UF:Configure_AuraWatch(frame, isPet)
	local db = frame.db.buffIndicator
	if db and db.enable then
		if not frame:IsElementEnabled('AuraWatch') then
			frame:EnableElement('AuraWatch')
		end

		frame.AuraWatch.size = db.size
		frame.AuraWatch.countFontSize = db.countFontSize

		if frame.unit == 'pet' or isPet then
			frame.AuraWatch:SetNewTable(E.global.unitframe.aurawatch.PET)
		else
			local auraTable
			if db.profileSpecific then
				auraTable = E.db.unitframe.filters.aurawatch
			else
				auraTable = E:CopyTable({}, E.global.unitframe.aurawatch[E.myclass])
				E:CopyTable(auraTable, E.global.unitframe.aurawatch.GLOBAL)
			end
			frame.AuraWatch:SetNewTable(auraTable)
		end
	elseif frame:IsElementEnabled('AuraWatch') then
		frame:DisableElement('AuraWatch')
	end
end
function UF:BuffIndicator_PostCreateIcon(button)
	button.cd.CooldownOverride = 'unitframe'
	button.cd.skipScale = true

	E:RegisterCooldown(button.cd)

	local blizzCooldownText = button.cd:GetRegions()
	if blizzCooldownText:IsObjectType('FontString') then
		button.cd.blizzText = blizzCooldownText
	end

	button.overlay:Hide()

	button.icon.border = button:CreateTexture(nil, 'BACKGROUND');
	button.icon.border:SetOutside(button.icon, 1, 1)
	button.icon.border:SetTexture(E.media.blankTex)
	button.icon.border:SetVertexColor(0, 0, 0)

	ElvUI_UF:Configure_FontString(button.count)
	ElvUI_UF:Update_FontString(button.count)

	button.count:ClearAllPoints()
	button.count:Point('BOTTOMRIGHT', 1, 1)
	button.count:SetJustifyH('RIGHT')

end

function UF:BuffIndicator_PostUpdateIcon(unit, button)
 if not UF.db then UF.db.kyaui = E.db.kyaui end
	local settings = self.watched[button.spellID]

	if settings then -- This should never fail.		
		
		local onlyText = settings.style == 'timerOnly' -- schwellenwerte für diese Option hinzufügen
		local colorIcon = settings.style == 'coloredIcon'
		local textureIcon = settings.style == 'texturedIcon'

		if (colorIcon or textureIcon) and not button.icon:IsShown() then
			button.icon:Show()
			button.icon.border:Show()
			button.cd:SetDrawSwipe(true)
		elseif onlyText and button.icon:IsShown() then
			button.icon:Hide()
			button.icon.border:Hide()
			button.cd:SetDrawSwipe(false)
		end

		if not E.db.cooldown.enable then -- cooldown module is off, handle blizzards cooldowns
			if onlyText then
				button.cd:SetHideCountdownNumbers(false)

				if button.cd.blizzText then
					button.cd.blizzText:SetTextColor(settings.color.r, settings.color.g, settings.color.b)
				end
			else
				button.cd:SetHideCountdownNumbers(not settings.displayText)

				if button.cd.blizzText then
					button.cd.blizzText:SetTextColor(1, 1, 1)
				end
			end
		elseif button.cd.timer then
			button.cd.textThreshold = settings.textThreshold ~= -1 and settings.textThreshold
			button.cd.hideText = (not onlyText and not settings.displayText) or nil
			button.cd.timer.skipTextColor = onlyText or nil

			if button.cd.timer.text then
				button.cd.timer.text:SetTextColor(settings.color.r, settings.color.g, settings.color.b)
			end
		end


		if colorIcon then
			button.icon:SetTexture(E.media.blankTex)
			button.icon:SetVertexColor(settings.color.r, settings.color.g, settings.color.b)

			if settings.isStatic == true then
				button.cd:Hide();
			end

			-- Just get our Threshold Groups only -> Ignore the rest
			local extractedSettings = GetItemsByKeys(settings, {'thresholdGroup1','thresholdGroup2','thresholdGroup3','thresholdGroup4','thresholdGroup5'})
			
			-- Only handle enabled Threshold Groups
			extractedSettings = FilterEnabledThresholdGroups(extractedSettings)

			-- Turn the table into an indexed one -> Removes all keys and replaces them with indices
			extractedSettings = ToIndexedTable(extractedSettings)

			-- Perform a selection sort to bring them in the right order
			extractedSettings = SelectionSort(extractedSettings)
	
			if not UF.db.filterExtension.enabled then
				table.foreach(extractedSettings, function(k,v)
					--v.enabled = false  
				end)
			end
			button:SetScript('OnUpdate', function(self)
				if self.cd.timer then
					local current = self.cd.timer.endTime-GetTime()			
		
					table.foreach(extractedSettings, function(k,v)
						if UF.db.filterExtension.enabled and v.enabled then	
							if current <= v.colorThreshold then
								button.icon:SetVertexColor(v.color.r, v.color.g, v.color.b)
							end
						end
					end)
				end
			end)			
		elseif textureIcon then
			button.icon:SetVertexColor(1, 1, 1)
			button.icon:SetTexCoord(unpack(E.TexCoords))
		end

		if textureIcon and button.filter == 'HARMFUL' then
			button.icon.border:SetVertexColor(1, 0, 0)
		else
			button.icon.border:SetVertexColor(0, 0, 0)
		end
	end
end
