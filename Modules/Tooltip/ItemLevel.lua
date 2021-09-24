------------------------------------------------------------------
-- This feature was originally created by Darth and Repooc of S&L.
-- Credits: Darth Predator and Repooc.
-- ElvUI Shadow & Light : https://www.tukui.org/addons.php?id=38
-- Later modified by me for this addon
------------------------------------------------------------------

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local ILT = E:NewModule("ItemLevelTooltip", "AceHook-3.0", "AceEvent-3.0")
local TT = E:GetModule('Tooltip')

ILT.playerGUID = UnitGUID("player")
ILT.playerGUID = UnitGUID("mouseover")

function ILT:GetItemLevel(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == playerGUID and GetStatistic or GetComparisonStatistic

	for tier = 1, #PT.tiers["LONG"] do
		local option = PT.bosses[tier].option
		PT.progressCache[guid].header[tier] = {}
		PT.progressCache[guid].info[tier] = {}
		local statTable = PT.bosses[tier][E.myfaction] or PT.bosses[tier].statIDs
		for level = 1, #statTable do
			PT.highest = 0
			for statInfo = 1, #statTable[level] do
				kills = tonumber((statFunc(statTable[level][statInfo])))
				if kills and kills > 0 then						
					PT.highest = PT.highest + 1
				end
			end
			pos = PT.highest
			if (PT.highest > 0) then
				PT.progressCache[guid].header[tier][level] = ("%s [%s]:"):format(PT.tiers[E.db.eel.progression.NameStyle][tier], PT.levels[level])
				PT.progressCache[guid].info[tier][level] = ("%d/%d"):format(PT.highest, #statTable[level])
				if PT.highest == #statTable[level] then
					break
				end
			end
		end
	end		
end

function PT:UpdateProgression(guid)
	PT.progressCache[guid] = PT.progressCache[guid] or {}
	PT.progressCache[guid].header = PT.progressCache[guid].header or {}
	PT.progressCache[guid].info =  PT.progressCache[guid].info or {}
	PT.progressCache[guid].timer = GetTime()

	PT:GetProgression(guid)
end

function PT:SetProgressionInfo(guid, tt)
	if PT.progressCache[guid] and PT.progressCache[guid].header then
		local updated = 0
		for i=1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]
			for tier = 1, #PT.tiers["LONG"] do
				for level = 1, 4 do
					if (leftTipText:GetText() and leftTipText:GetText():find(PT.tiers[E.db.eel.progression.NameStyle][tier]) and leftTipText:GetText():find(PT.levels[level]) and (PT.progressCache[guid].header[tier][level] and PT.progressCache[guid].info[tier][level])) then
						-- update found tooltip text line
						local rightTipText = _G["GameTooltipTextRight"..i]
						leftTipText:SetText(PT.progressCache[guid].header[tier][level])
						rightTipText:SetText(PT.progressCache[guid].info[tier][level])
						updated = 1
					end
				end
			end
		end
		if updated == 1 then return end
		-- add progression tooltip line
		if PT.highest > 0 then tt:AddLine(" ") end
		for tier = 1, #PT.tiers["LONG"] do
			local option = PT.bosses[tier].option
			if E.db.eel.progression.raids[option] then
				for level = 1, 4 do
					tt:AddDoubleLine(PT.progressCache[guid].header[tier][level], PT.progressCache[guid].info[tier][level], nil, nil, nil, 1, 1, 1)
				end
			end
		end
	end
end

local function AchieveReady(event, GUID)
	if (TT.compareGUID ~= GUID) then return end
	local unit = "mouseover"
	if UnitExists(unit) then
		PT:UpdateProgression(GUID)
		_G["GameTooltip"]:SetUnit(unit)
	end
	ClearAchievementComparisonUnit()
	TT:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

local function OnInspectInfo(self, tt, unit, numTries, r, g, b)
	if InCombatLockdown() then return end
	if not E.db.eel.progression.enable then return end
	if not (unit and CanInspect(unit)) then return end
	local level = UnitLevel(unit)
	if not level or level < MAX_PLAYER_LEVEL then return end
	
	local guid = UnitGUID(unit)
	if not PT.progressCache[guid] or (GetTime() - PT.progressCache[guid].timer) > 600 then
		if guid == PT.playerGUID then
			PT:UpdateProgression(guid)
		else
			ClearAchievementComparisonUnit()
			if not self.loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
				AchievementFrame_DisplayComparison(unit)
				HideUIPanel(_G["AchievementFrame"])
				ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end

			self.compareGUID = guid
			if SetAchievementComparisonUnit(unit) then
				self:RegisterEvent("INSPECT_ACHIEVEMENT_READY", AchieveReady)
			end
			return
		end
	end

	PT:SetProgressionInfo(guid, tt)
end

function PT:Initialize()
	hooksecurefunc(TT, 'AddInspectInfo', OnInspectInfo)
end

E:RegisterModule(PT:GetName())
