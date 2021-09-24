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

if not MB.MicroButtons then MB.MicroButtons = {} end;
local gradientPacks = MB.Utils.Colors.GradientPacks;

function MB.MicroButtons:AchievementMicroButton(button)
    if button.Name == "AchievementMicroButton" then
		button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("Achievement"))
		button.tooltipText = MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT");
		if _G["AchievementFrame"] then
			_G["AchievementFrame"]:HookScript("OnShow", function(self)
				button.isShown = _G["AchievementFrame"]:IsShown()
				MB.Events:OnMouse(button)
			end)
			_G["AchievementFrame"]:HookScript("OnHide", function(self)
				button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Normal))
				button.isShown = false
				button.isMouseEnter = false	
				button.isMouseLeave = false	
				button.isMouseUp = false
				button.isMouseDown = false	
			end)
		end
		button:SetScript('OnClick', function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleAchievementFrame"]()
			self.isShown = _G["AchievementFrame"]:IsShown()
			MB.Events:OnMouse(self)
			if _G["AchievementFrameCloseButton"] then
				_G["AchievementFrameCloseButton"]:HookScript("OnClick",function(self)
					button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Normal))
					button.isShown = false
					button.isMouseEnter = false	
					button.isMouseLeave = false	
					button.isMouseUp = false
					button.isMouseDown = false					
				end)
			end
		end)
    end
end