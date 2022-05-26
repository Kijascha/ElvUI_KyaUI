local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')

local texturesToRemove = { 
	[[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]],
	[[Interface\Minimap\MiniMap-TrackingBorder]],
	[[Interface\Minimap\UI-Minimap-Background]], 
}

local inset = 2
local scalingFactor = 0.9

if not MB.Core then MB.Core = {} end

function MB.Core:SkinMinimapButton(Button)
    if not Button then return end

    for i=1, Button:GetNumRegions() do
        local Region = select(i, Button:GetRegions())
        if Region.IsObjectType and Region:IsObjectType('Texture') then
            --local texture = nil
            --if Region.GetTexture then texture = Region:GetTexture() end            
            --print(texture.." - "..GetFileIDFromPath(texturesToRemove[2]))
            
            local texture = Region.GetTextureFileID and Region:GetTextureFileID()

            for j=1, #texturesToRemove do
                if texture == GetFileIDFromPath(texturesToRemove[j]) then
                    Region:SetTexture()
                    Region:SetAlpha(0)
                end
            end
        end
    end
    Button:SetTemplate("Transparent")
    Button.Icon:SetSize(Button:GetWidth() * scalingFactor,Button:GetWidth() * scalingFactor)
    Button.Icon:SetPoint("TOPLEFT", inset,-inset)
end