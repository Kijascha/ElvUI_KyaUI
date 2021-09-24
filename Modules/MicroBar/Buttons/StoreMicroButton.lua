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

function MB.MicroButtons:StoreMicroButton(button)
    if button.Name == "StoreMicroButton" then
		button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("Store"))

		button.tooltipText = BLIZZARD_STORE; 
		if (not C_StorePublic.IsEnabled() and GetCurrentRegionName() == 'US') then
			button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Disabled))
			button:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip_SetTitle(GameTooltip,button.tooltipText)
				if _G[self.Name].disabledTooltip then
					GameTooltip:AddLine(_G[self.Name].disabledTooltip,.9,.2,.2);
				end
				GameTooltip:Show()		
			end)
			button:SetScript('OnLeave', function(self)
				GameTooltip:Hide()
			end)
		else
			button:SetScript('OnClick', function(self)
				if InCombatLockdown() then
					return
				end
				_G.StoreMicroButton:Click()
			end)
		end
    end
end