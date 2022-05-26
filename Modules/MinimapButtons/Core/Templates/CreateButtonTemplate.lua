local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')

local CreateFrame = CreateFrame

if not MB.Core then MB.Core = {} end
if not MB.Core.Templates then MB.Core.Templates = {} end
if not MB.Core.Templates.CreateIconTemplate then return end

function MB.Core.Templates:CreateButtonTemplate(buttonName, buttonSize, buttonPoint)

    local buttonTemplate = CreateFrame("BUTTON",buttonName, E.UIParent, "SecureActionButtonTemplate");
    buttonTemplate:SetSize(buttonSize,buttonSize);
    buttonTemplate:SetPoint(unpack(buttonPoint));    
    buttonTemplate:SetTemplate("Transparent");

    return buttonTemplate
end