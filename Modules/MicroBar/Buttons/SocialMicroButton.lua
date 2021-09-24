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

function MB.MicroButtons:SocialMicroButton(button)
	if button.Name == "SocialMicroButton" then
		button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("Social"))		
		button.tooltipText = MicroButtonTooltipText(FRIENDS_LIST, "TOGGLESOCIAL");

		if _G["FriendsFrame"] then
			_G["FriendsFrame"]:HookScript("OnShow", function(self)
				button.isShown = _G["FriendsFrame"]:IsShown()
				MB.Events:OnMouse(button)
			end)
			_G["FriendsFrame"]:HookScript("OnHide", function(self)
				button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Normal))
				button.isShown = false
				button.isMouseEnter = false	
				button.isMouseLeave = false	
				button.isMouseUp = false
				button.isMouseDown = false	
			end)
		end
		if KeybindFrames_InQuickKeybindMode() then
			button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Pushed))
		end
		button:SetScript('OnClick', function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleFriendsFrame"]()
			self.isShown = _G["FriendsFrame"]:IsShown()
			MB.Events:OnMouse(self)
			_G["FriendsFrame"].CloseButton:HookScript("OnClick",function(self)
				button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Normal))
				button.isShown = false
				button.isMouseEnter = false	
				button.isMouseLeave = false	
				button.isMouseUp = false
				button.isMouseDown = false					
			end)
		end)
    end
end