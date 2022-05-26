local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')
local LDBIcon = E.Libs.LDI

if not MB.Core then MB.Core = {} end
if not MB.GrabbedMinimapButtons then MB.GrabbedMinimapButtons = {} end
if not MB.Core.List then MB.Core.List = {} end

--[[---------------------------------------
            Core List functions
-------------------------------------------]]
local function SaveButtonListToDB(buttonList)
	if not MB.db then return end
    if not buttonList.Buttons then return end

    for i = 1, #buttonList.Buttons do

        local set = {}
        set.Slot = buttonList.Buttons[i]:GetName();
        if buttonList.Buttons[i].MinimapButton  then
            set.Button = buttonList.Buttons[i].MinimapButton:GetName();
        end
        MB.db.bars.buttonGrid.buttons = set
    end
end
function MB.Core.List:Exists(Table, Object)
    if not Button then return false end
    --if not type(Button) == "Button" then return false end
    if not Object.GetName then return false end

    for key, value in pairs(Table) do
        if key == Object:GetName() and value == Object then 
            return true
        end
    end 
    --if tContains(MB.GrabbedMinimapButtons, Button) then return true end 
    return false;
end
function MB.Core.List:GetKey(Table, Object)    
    if MB.Core.List:Exists(Object) then
        return Object:GetName();
    end
    return nil;
end
function MB.Core.List:GetItemByKey(Table, Key)
    if Key then
        return Table[Key];
    end
    return nil;
end
function MB.Core.List:Count(Table)
    return #Table;
end
function MB.Core.List:AddObject(Table, Object)
    if not MB.Core.List:Exists(Object) then
        Table[Object:GetName()] = Object;
        return true; --Successfully added
    end
    return false; --Addition failed!
end
function MB.Core.List:RemoveObject(Table, Object)
    local index = MB.Core.List:GetKey(Object);
    if index then
        tremove(Table,index);
        return true; --Successfully removed
    end
    return false; --Deletion failed!
end
function MB.Core:GetMinimapButtonIcon(IconName)
	local IconPath = "Interface\\AddOns\\ElvUI_KyaUI\\Media\\Textures\\Icons\\MinimapButtons\\";
	local ending = ".tga";
	return (IconPath..IconName..ending);
end