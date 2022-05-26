local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')

local CreateFrame = CreateFrame

if not MB.Core then MB.Core = {} end
if not MB.Core.Templates then MB.Core.Templates = {} end

function MB.Core.Templates:CreateIconTemplate(buttonParent, iconTexture, texCoord)
    local width, height = buttonParent:GetSize();

    local iconTemplate = buttonParent:CreateTexture();    
    iconTemplate:SetPoint("CENTER", buttonParent, "CENTER", 0, 0)
    iconTemplate:SetTexture(133640);
    iconTemplate:SetTexCoord(unpack(texCoord));
    iconTemplate:SetSize(height * .9 , width * .9);
    
    local mouseUpButtonSize = width * .9
    local mouseDownButtonSize = width * .7

    buttonParent:SetScript("OnMouseUp", function(self) 
        self.Icon:SetSize(mouseUpButtonSize,mouseUpButtonSize)
    end)        
    buttonParent:SetScript("OnMouseDown", function(self) 
       self.Icon:SetSize(mouseDownButtonSize,mouseDownButtonSize)
    end)
    return iconTemplate;
end