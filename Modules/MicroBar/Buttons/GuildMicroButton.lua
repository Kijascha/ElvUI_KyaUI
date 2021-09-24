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
function MB.MicroButtons:GuildMicroButton(button)
    if button.Name == "GuildMicroButton" then
        button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("Guild"))		

        if ( CommunitiesFrame_IsEnabled() ) then
            button.tooltipText = MicroButtonTooltipText(GUILD_AND_COMMUNITIES, "TOGGLEGUILDTAB");
        elseif ( IsInGuild() ) then
            button.tooltipText = MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB");
        else
            button.tooltipText = MicroButtonTooltipText(LOOKINGFORGUILD, "TOGGLEGUILDTAB");
        end
        if _G["CommunitiesFrame"] then
            _G["CommunitiesFrame"]:HookScript("OnShow", function(self)
                button.isShown = _G["CommunitiesFrame"]:IsShown()
                MB.Events:OnMouse(button)
            end)
            _G["CommunitiesFrame"]:HookScript("OnHide", function(self)
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
            _G["ToggleGuildFrame"]()
            self.isShown = _G["CommunitiesFrame"]:IsShown()
            MB.Events:OnMouse(self)
            _G["CommunitiesFrame"].CloseButton:HookScript("OnClick",function(self)
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