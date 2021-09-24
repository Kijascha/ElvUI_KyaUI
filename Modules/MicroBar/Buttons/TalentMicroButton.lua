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

function MB.MicroButtons:TalentMicroButton(button)
    if button.Name == "TalentMicroButton" then
		--Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
		button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("Talent"))

		button.tooltipText = MicroButtonTooltipText(TALENTS_BUTTON, "TOGGLETALENTS")
		if _G.PlayerTalentFrame then
			_G.PlayerTalentFrame:HookScript("OnShow", function(self)
				button.isShown = _G.PlayerTalentFrame:IsShown()
				MB.Events:OnMouse(button)
			end)
			_G.PlayerTalentFrame:HookScript("OnHide", function(self)
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
			_G["ToggleTalentFrame"]()
			self.isShown = _G.PlayerTalentFrame:IsShown()
			MB.Utils:GetCurrentTalentSpecialization()
			MB.Events:OnMouse(self)		
			_G.PlayerTalentFrame.CloseButton:HookScript("OnClick",function(self)
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