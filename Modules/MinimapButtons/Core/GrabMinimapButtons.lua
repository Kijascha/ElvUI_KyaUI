local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');
local LDBIcon = E.Libs.LDI

if not MB.Core then return end

function MB.Core:GrabMinimapButtons()
    
    for _, Frame in pairs({ Minimap, _G.MinimapBackdrop, _G.MinimapCluster }) do

        -- get all children elements from the Minimap-Frame
		local NumChildren = Frame:GetNumChildren() 

		for i = 1, NumChildren do

            local object = select(i, Frame:GetChildren())

            -- check if the element has the right object-type
            if object and (object:IsObjectType('Button') or object:IsObjectType('Frame')) then
                
				local name = object:GetName()
				if name and strfind(name, "LibDBIcon10_") then
                    local button = LDBIcon:GetMinimapButton(name) or _G[name];
                    MB.DragAndDrop:RegisterForDragAndDrop(button)
                end
            end
        end
    end
end