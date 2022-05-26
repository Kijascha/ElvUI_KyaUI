local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')

if not MB.Core then MB.Core = {} end

function MB.Core:SetParent(Button, Parent)
    if not Button then return end
    if not Parent then return end

    if Button == Parent then return end
    if MB.DeveloperMode then
        print(Parent:GetName())
    end

    Button:SetParent(Parent)
    Button:SetPoint("CENTER",Parent,"CENTER",0, 0);
    Button:SetFrameStrata(Parent:GetFrameStrata())
    Button:SetFrameLevel(Parent:GetFrameLevel() + 10)
end