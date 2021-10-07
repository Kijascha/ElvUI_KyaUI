local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')
local LDBIcon = E.Libs.LDI

local _G = _G
local CreateFrame = CreateFrame

local pairs, tinsert, tremove = pairs, tinsert, tremove

local texturesToRemove = { 
	[[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]],
	[[Interface\Minimap\MiniMap-TrackingBorder]],
	[[Interface\Minimap\UI-Minimap-Background]], 
}

if not MB.Core then MB.Core = {} end
if not MB.GrabbedMinimapButtons then MB.GrabbedMinimapButtons = {} end


--[[---------------------------------------
            Private GrabbedMinimapButtons Functions
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
local function buttonExists(Button)
    if not Button then return false end
    if not Button.GetName then return false end

    for buttonName, button in pairs(MB.GrabbedMinimapButtons) do
        if buttonName == Button:GetName() and button == Button then 
            return true
        end
    end
    return false;
end
local function getButtonKey(Button)    
    if buttonExists(Button) then
        return Button:GetName();
    end
    return nil;
end
local function getButtonByName(ButtonName)
    if ButtonName then
        return MB.GrabbedMinimapButtons[ButtonName];
    end
    return nil;
end
local function countButtons()
    return #MB.GrabbedMinimapButtons;
end
local function addButton(Button)
    if not buttonExists(Button) then
        MB.GrabbedMinimapButtons[Button:GetName()] = Button;
        return true; --Successfully added
    end
    return false; --Addition failed!
end
local function removeButton(Button)
    local index = getButtonKey(Button);
    if index then
        tremove(MB.GrabbedMinimapButtons,index);
        return true; --Successfully removed
    end
    return false; --Deletion failed!
end
--[[---------------------------------------
            Create Buttons
-------------------------------------------]]

function MB.Core:CreateSlot(bar, slotNumber)	
    if not MB.db then return end
    if not bar then return end
    if not bar.Buttons then bar.Buttons = {} end

    bar.Buttons[slotNumber] = CreateFrame("Button",bar:GetName().."Slot"..slotNumber,bar,"BackdropTemplate");
    bar.Buttons[slotNumber]:SetTemplate("Transparent")
    bar.Buttons[slotNumber]:SetPoint('LEFT',bar, 0,0)	
    bar.Buttons[slotNumber]:SetSize(MB.db.bars.defaultSize or 32,MB.db.bars.defaultSize or 32)
    bar.Buttons[slotNumber]:SetFrameStrata(bar:GetFrameStrata())	
    bar.Buttons[slotNumber]:SetFrameLevel(bar:GetFrameLevel() + 5)
    bar.Buttons[slotNumber]:Show()
    bar.Buttons[slotNumber].isShown = false
    bar.Buttons[slotNumber].isMouseEnter = false	
    bar.Buttons[slotNumber].isMouseLeave = false	
    bar.Buttons[slotNumber].isMouseUp = false
    bar.Buttons[slotNumber].isMouseDown = false
    bar.Buttons[slotNumber].isEmpty = true
    bar.Buttons[slotNumber].MinimapButton = nil;
    bar.Buttons[slotNumber].tooltipText = ''
end

function MB.Core:SetParentForGrabbedMinimapButton(Button, Parent)
    if not Button then return end
    if not Parent then return end
    if Button == Parent then return end
    print(Parent:GetName())
    Button:SetParent(Parent)
    Button:SetPoint("CENTER",Parent,"CENTER",0, 0);
    Button:SetFrameStrata(Parent:GetFrameStrata())
    Button:SetFrameLevel(Parent:GetFrameLevel() + 10)
end
function MB.Core:SkinGrabbedMinimapButton(Button)
    if not Button then return end

    for i=1, Button:GetNumRegions() do
        local Region = select(i, Button:GetRegions())
        local texture = nil
        if Region.GetTexture then texture = Region:GetTexture() end
        
        for j=1, #texturesToRemove do
            if Region:GetTexture() == texturesToRemove[j] then
                Region:SetTexture(nil)
                Region:SetAlpha(0)
            end
        end
    end
    Button:SetTemplate("Transparent")
    local inset = 2
    local scalingFactor = 0.9
    Button.icon:SetSize(Button:GetWidth() * scalingFactor,Button:GetWidth() * scalingFactor)
    Button.icon:SetPoint("TOPLEFT", inset,-inset)
end
function MB.Core:MakeGrabbedMinimapButtonsDraggable(Button)
    Button.isDragging = false;
    Button.isDroppable = false;
    Button.isReadyToDrop = false;

    Button:SetMovable(true)
    Button:RegisterForDrag("LeftButton")
    
    Button:HookScript("OnUpdate", function(self) 
    end)
    Button:SetScript("OnDragStart", function(self) 
        if not MB.Bars.ButtonGrid then return end
        MB.DragAndDrop:DragStart(self, MB.Bars.ButtonGrid.Buttons);
        self.isDragging = true;

        MB.DragAndDrop:ShrinkAndResize(self, self.isDragging);
    end)
    Button:SetScript("OnDragStop", function(self) 
        local success, slot = MB.DragAndDrop:Drop(self);

        self.isDragging = false;
        
        MB.DragAndDrop:ShrinkAndResize(self, self.isDragging);

        local prevParent = self:GetParent();
        if success then
            
            prevParent.isEmpty = true;
            prevParent.MinimapButton = nil;
            slot.isEmpty = false;
            slot.MinimapButton = self;
            slot.MinimapButton.Name = self:GetName();
            
            MB.DragAndDrop:AttachToSlot(self, slot);
        elseif (self:GetParent() ~= E.UIParent or self:GetParent() ~= UIParent) then
            MB.DragAndDrop:AttachToSlot(self, self:GetParent());
        end
        if not V.kyaui.minimapButtons then return end

		-- Grab current button setup
		local currentButtonList = MB.Bars.ButtonGrid.Buttons;
		local savedButtonList =  {};

		for i = 1, #currentButtonList do 
			local set = {					
				SlotID = i,
				SlotName = currentButtonList[i]:GetName() or "",
				IsEmpty = currentButtonList[i].isEmpty or false,
				MinimapButton = currentButtonList[i].MinimapButton or nil,

			}
            --print(tostring(set.SlotName).." - "..tostring(set.IsEmpty))
			savedButtonList[i] = set;
		end
		MB.db.bars.buttonGrid.buttons = savedButtonList;
   end)
end
function MB.Core:GrabMinimapButtons()
    --[[----------------------------------------
                Grab All LibDBIcons
    --------------------------------------------]]
    local n = 1
	for k,v in pairs(LDBIcon:GetButtonList()) do
        local button = LDBIcon:GetMinimapButton(v);

        button.isSkinned = false;
        button.isDraggable = false;
        

        if addButton(button) then 
            if not button.isSkinned then
                MB.Core:SkinGrabbedMinimapButton(button);
                button.isSkinned = true;
            end
            if not button.isDraggable then
                MB.Core:MakeGrabbedMinimapButtonsDraggable(button)
                button.isDraggable = true;
            end
            print(n .. " - " .. button:GetName())
            --print("SUCCESS| Button: "..button:GetName().." successfully grabbed.")
        else
            --print("ERROR| Button: "..button:GetName().." couldn't be grabbed!.")
        end
	end
end