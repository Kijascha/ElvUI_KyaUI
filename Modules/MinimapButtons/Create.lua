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
if not MB.Bars then MB.Bars = {} end
if not MB.GrabbedMinimapButtons then MB.GrabbedMinimapButtons = {} end

--[[---------------------------------------
            Private Bar Functions
-------------------------------------------]]
local function barExists(Bar)
    if not bar then return false end
    if not bar.GetName then return false end

    for barName, bar in pairs(MB.Bars) do
        if barName == Bar:GetName() and bar == Bar then 
            return true
        end
    end
    return false;
end
local function getBarKey(bar)    
    if barExists(bar) then
        return bar:GetName();
    end
    return nil;
end
local function getBarByName(barName)
    if barName then
        return MB.Bars[barName];
    end
    return nil;
end
local function countBars()
    return #MB.Bars;
end
local function addBar(bar)
    if not barExists(bar) then
        MB.Bars[bar:GetName()] = bar;
        return true; --Successfully added
    end
    return false; --Addition failed!
end
local function removeBar(bar)
    local index = getBarKey(bar);
    if index then
        tremove(MB.Bars,index);
        return true; --Successfully removed
    end
    return false; --Deletion failed!
end
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
            Create Bars
-------------------------------------------]]

local function CreateBar(Name, Parent)
    if not MB.db then return end
    if not MB.db.enabled then return end
    if not MB.db.bars then return end

    local point = MB.db.bars.defaultPoint;
	local bar = CreateFrame("Frame",Name, Parent, "BackdropTemplate")
	bar:SetPoint(
        point.Point or "CENTER",
        point.Anchor or Parent,
        point.RelativePoint or "CENTER",
        point.XOffSet or 0,
        point.YOffSet or 0);
	bar:SetFrameStrata("MEDIUM")
	bar:EnableMouse(true)
    bar:SetSize(MB.db.bars.defaultSize or 32, MB.db.bars.defaultSize or 32)
	bar:SetScale(MB.db.bars.defaultScale or 1)
	bar:SetTemplate(MB.db.bars.defaultTemplate or "Transparent")
	E.FrameLocks[bar] = true
		
	bar.Buttons = {} 

    return addBar(bar); -- return if either bar is successfully added or not
end

function MB.Core:CreateQuickAccessBar()
    if not MB.db then return end
    if not MB.db.bars.quickAccessBar then return end

    local barName = "KyaUI_QuickAccessBar";
    local parent = E.UIParent;
    local point = MB.db.bars.quickAccessBar.defaultPoint;
    
    if CreateBar(barName, parent) then
        local bar = getBarByName(barName)
        bar:SetPoint(
            point.Point or "RIGHT",
            point.Anchor or parent,
            point.RelativePoint or "RIGHT",
            point.XOffSet or 0,
            point.YOffSet or 0);	
        
        E:CreateMover(bar, barName.."Mover", barName, nil, nil, nil, "ALL,MINIMAP,KYAUI", nil, "kyaui,quickAccessBar")

        return true;
    end
    return false;
end
function MB.Core:CreateButtonGrid()
    if not MB.db then return end
    if not MB.db.bars.buttonGrid then return end

    local barName = "KyaUI_ButtonGrid";
    local parent = E.UIParent;
    local point = MB.db.bars.buttonGrid.defaultPoint;
    
    if CreateBar(barName, parent) then
        local bar = getBarByName(barName)
        bar:SetPoint(
            point.Point or "CENTER",
            point.Anchor or parent,
            point.RelativePoint or "CENTER",
            point.XOffSet or 0,
            point.YOffSet or 0);	
        
        
        E:CreateMover(bar, barName.."Mover", barName, nil, nil, nil, "ALL,MINIMAP,KYAUI", nil, "kyaui,buttonGrid")
    
        return true;
    end
    return false;
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
function MB.Core:MakeGrabbedMinimapButtonsDraggable(Button,UpdateFunc)
    Button.isDragging = false;
    Button.isDroppable = false;
    Button.isReadyToDrop = false;

    Button:SetMovable(true)
    Button:RegisterForDrag("LeftButton")
    
    Button:HookScript("OnUpdate", function(self) 
    end)
    Button:SetScript("OnDragStart", function(self) 
        if not MB.Bars["KyaUI_ButtonGrid"] then return end
        MB.DragAndDrop:DragStart(self, MB.Bars["KyaUI_ButtonGrid"].Buttons);
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

            MB.DragAndDrop:AttachToSlot(self, slot);
        elseif (self:GetParent() ~= E.UIParent or self:GetParent() ~= UIParent) then
            MB.DragAndDrop:AttachToSlot(self, self:GetParent());
        end
        if not V.kyaui.minimapButtons then return end

		-- Grab current button setup
		local currentButtonList = MB.Bars["KyaUI_ButtonGrid"].Buttons;
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
	for k,v in pairs(LDBIcon:GetButtonList()) do
        local button = LDBIcon:GetMinimapButton(v);

        button.isSkinned = false;
        button.isDraggable = false;

        if addButton(button) then 
            print("SUCCESS| Button: "..button:GetName().." successfully grabbed.")
        else
            print("ERROR| Button: "..button:GetName().." couldn't be grabbed!.")
        end
	end
end