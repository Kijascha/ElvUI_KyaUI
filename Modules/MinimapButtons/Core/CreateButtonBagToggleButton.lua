local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')

function MB.Core:CreateButtonBagToggleButton()
    local buttonBagToggleButton = MB.Core.Templates:CreateButtonTemplate("KyaUI_ButtonBagToggleButton",32,{"RIGHT",E.UIParent,"RIGHT",0,0})
    buttonBagToggleButton.Icon = MB.Core.Templates:CreateIconTemplate(buttonBagToggleButton, iconTexture, texCoord)

    buttonBagToggleButton:SetScript("OnClick", function(self)
        if not MB.Bars.ButtonGrid then return end

        if MB.Bars.ButtonGrid:IsShown() then 
            MB.Bars.ButtonGrid:Hide();
        else
            MB.Bars.ButtonGrid:Show();
        end
    end);
    return buttonBagToggleButton;
end