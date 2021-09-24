local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MicroBar')
local ElvMB = E:GetModule('ActionBars')

local _G = _G
local pairs = pairs
local assert = assert
local unpack = unpack
local CreateFrame = CreateFrame
local C_StorePublic_IsEnMBled = C_StorePublic.IsEnabled
local UpdateMicroButtonsParent = UpdateMicroButtonsParent
local GetCurrentRegionName = GetCurrentRegionName
local RegisterStateDriver = RegisterStateDriver
local InCombatLockdown = InCombatLockdown
local UnitSex = UnitSex
local GetNetStats = GetNetStats

-- EVENTS
if not MB.Events then MB.Events = {} end
function MB.Events:OnKeyDown(button,keyPressed)
	if keyPressed then
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Pushed))
	else
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Normal))
	end
end

function MB.Events:OnMouse(button)	

	local isMouseDown = (button.isMouseDown == true and button.isMouseUp == false)
	local isMouseUp = (button.isMouseDown == false and button.isMouseUp == true)
	local isClicked = isMouseUp
	local isMouseOver  = (button.isMouseEnter == true and button.isMouseLeave == false)

	local isMouseDownAndIsShown = (isMouseDown == true and button.isShown == true)
	local isMouseDownAndNotIsShown = (isMouseDown == true and button.isShown == false)
	local isMouseUpAndIsShown = (isMouseUp == true and button.isShown == true)
	local isMouseUpAndNotIsShown = (isMouseUp == true and button.isShown == false)

	local isMouseOverAndIsShown = (isMouseOver == true and button.isShown == true)
	local isNotMouseOverAndIsShown = (isMouseOver == false and button.isShown == true)
	local isMouseOverAndNotIsShown = (isMouseOver == true and button.isShown == false)
	
	local isShownAndNoMouse = (not isMouseOver and not isMouseDown and not isMouseUp and button.isShown == true)
	local isNotShownAndNoMouse = (not isMouseOver and not isMouseDown and not isMouseUp and button.isShown == false)

	if isShownAndNoMouse then 
		MB.Events:OnKeyDown(button, true)
		return
	elseif isNotShownAndNoMouse then
		MB.Events:OnKeyDown(button, false)
		return
	end
	if isMouseUp and isMouseOverAndIsShown then	-- MouseUp and MouseOver and Frame is shown
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Highlight))
	elseif isMouseUp and isMouseOverAndNotIsShown then
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Highlight))
	elseif isMouseDown and isMouseOverAndIsShown then	-- MouseDown and MouseOver and Frame is shown
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Pushed))
	elseif isMouseDownAndIsShown then	-- Mousedown and Frame is shown
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Pushed))	
	elseif isMouseDownAndNotIsShown then	-- Mousedown and Frame is not shown
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Pushed))	
	elseif isMouseUpAndIsShown then	-- MouseUp and Frame is shown
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Pushed))	
	elseif isMouseUpAndNotIsShown then	-- MouseUp and Frame is not shown
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Normal))
	elseif isMouseOverAndIsShown then
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Highlight))
	elseif isNotMouseOverAndIsShown then
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Pushed))
	elseif isMouseOverAndNotIsShown then
		button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Highlight))
	else
		if isMouseOver then	
			button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Highlight))
		else
			button.Texture:SetGradientAlpha("VERTICAL", unpack(MB.Utils.Colors.GradientPacks.Normal))
		end			
	end
end

function MB.Events:OnEvent(button, event, ...)
	if button:GetName() == "GuildMicroButton" then
		if ( event == "UPDATE_BINDINGS" ) then
			if ( CommunitiesFrame_IsEnabled() ) then
				button.tooltipText = MicroButtonTooltipText(GUILD_AND_COMMUNITIES, "TOGGLEGUILDTAB");
			elseif ( IsInGuild() ) then
				button.tooltipText = MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB");
			else
				button.tooltipText = MicroButtonTooltipText(LOOKINGFORGUILD, "TOGGLEGUILDTAB");
			end
		end
	end
end

function MB.Events:OnEnter(self, slow)
	if self.isMouseEnter then
		MB.tooltip:ClearLines()	

			
		if self.Name == "MainMenuMicroButton" then
			
			-- Display on Button:
			local framerate = floor(GetFramerate())
			local _, _, _, latency = GetNetStats()

			local fps = framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4
			local ping = latency < 150 and 1 or (latency >= 150 and latency < 300) and 2 or (latency >= 300 and latency < 500) and 3 or 4

			local downBandwith, upBandwith, homePing, worldPing = GetNetStats()
			
            local pStrings = MB.Utils.PerformanceStrings
			MB.tooltip:AddLine(self.tooltipText,1,1,1,1);
			MB.tooltip:AddLine(' ');
			MB.tooltip:AddDoubleLine(L["Home Latency:"], format(pStrings.HomeLatency, homePing), .78, .38, .38, .84, .75, .65)
			MB.tooltip:AddDoubleLine(L["World Latency:"], format(pStrings.HomeLatency, worldPing), .78, .38, .38, .84, .75, .65)	
			MB.tooltip:AddLine(' ');
			MB.tooltip:AddDoubleLine("FPS:", format(pStrings.FPS, framerate), .78, .38, .38, .84, .75, .65)			
			MB.tooltip:AddLine(' ');
			MB.tooltip:AddDoubleLine("Bandwidth:", format(pStrings.Bandwidth, downBandwith, upBandwith), .78, .38, .38, .84, .75, .65)		
			
			if KYA.BS then
				MB.tooltip:AddLine(' ');
				local sessionErrors = #BugSack:GetErrors(BugGrabber:GetSessionId());
				local sessionCount = ''
				if sessionErrors > 0 then sessionCount = "\#"..sessionErrors end

				MB.tooltip:AddDoubleLine('BugSack',sessionCount,1,1,1,.5,.5,.5);			
				
				-- Got from the BugSack AddOn Credits goes to the original author
				local line = "%d. %s (x%d)"			
				local errs = BugSack:GetErrors(BugGrabber:GetSessionId())
				if #errs == 0 then
					MB.tooltip:AddLine(BugSack.L["You have no bugs, yay!"])
				else
					for i, err in next, errs do
						MB.tooltip:AddLine(line:format(i, BugSack.ColorStack(err.message), err.counter), .5, .5, .5)
						if i > 8 then break end
					end
				end
				MB.tooltip:AddLine(" ")
				MB.tooltip:AddLine(BugSack.L.minimapHint, 0.2, 1, 0.2, 1)
			end
			MB.tooltip:Show();
		else
			if ( not KeybindFrames_InQuickKeybindMode() ) then
				if _G[self.Name] and _G[self.Name].tooltipText then	
					if ( _G[self.Name]:IsEnabled() or _G[self.Name].minLevel or _G[self.Name].disabledTooltip or _G[self.Name].factionGroup) then				
						GameTooltip_SetTitle(MB.tooltip, self.tooltipText);
						if ( not _G[self.Name]:IsEnabled() ) then
							if ( _G[self.Name].factionGroup == "Neutral" ) then
								MB.tooltip:AddLine(FEATURE_NOT_AVAILBLE_PANDAREN, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
								MB.tooltip:Show();
							elseif ( _G[self.Name].minLevel ) then
								MB.tooltip:AddLine(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, _G[self.Name].minLevel), RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
								MB.tooltip:Show();
							elseif ( _G[self.Name].disabledTooltip ) then
								local disabledTooltipText = GetValueOrCallFunction(_G[self.Name], "disabledTooltip");
								MB.tooltip:AddLine(disabledTooltipText, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true);
								MB.tooltip:Show();
							end
						end
					end
				else
					GameTooltip_SetTitle(MB.tooltip, self.tooltipText);
				end

                -- Add special tooltip infos for each micro button here
                if self.Name == "TalentMicroButton" then
                    local currentSpec = MB.Utils.GetCurrentTalentSpecialization()
                    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"

                    MB.tooltip:AddLine(' ');
                    MB.tooltip:AddLine(L["Current Specialization: "]..currentSpecName);
                    MB.tooltip:Show();
                end
			end
		end
	end
end
MB.Wait, MB.Count = .15, 0
function MB.Events:OnUpdate(self, elapsed)
    if not elapsed then return end
	MB.Wait = MB.Wait - elapsed

	if MB.Wait < 0 then
		MB.Wait = 1

		if InCombatLockdown() then
			if MB.Count > 3 then
                MB.Events:OnEnter(self)
				MB.Count = 0
			else
				MB.Events:OnEnter(self, MB.Count)
				MB.Count = MB.Count + 1
			end
		else
			MB.Events:OnEnter(self)
		end
	end
end