local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');

local function SetFrameLevel(button) 
    button:SetFrameLevel(25);
    button:SetFrameStrata("DIALOG");
end
local function SetAttributes(button, slotId)
    button:SetAttribute("kyaui_slotId", slotId);
    button:SetAttribute("kyaui_isPickedUp", false);    
    button:SetAttribute("kyaui_slotType", MBR.Constants.MINIMAP_BUTTON_SLOT);
end
local function CreateIcon(button, TextureID)
    local icon = button:CreateTexture();    
    icon:Point("CENTER", button, "CENTER", 0, 0)
    icon:SetTexture(TextureID);
    icon:SetTexCoord(.08,.92,.08,.92);
    icon:Size(button:GetWidth() * .9 , button:GetHeight() * .9);
    return icon
end

local function IsOverFrame(button, frameList)
    
    for _,slot in ipairs(frameList) do 
        if slot then
            print(slot:GetName())
            --[[
                TODO:
                    - Implement a check rountine if frame is over one of th frames in the frameList 75% coverage
            ]]
            local scX,scY = slot:GetCenter();
            local bcX,bcY = button:GetCenter();
            
            local bL, bR, bT, bB = button:GetLeft(), button:GetRight(), button:GetTop(), button:GetBottom();
            local sL, sR, sT, sB = slot:GetLeft(), slot:GetRight(), slot:GetTop(), slot:GetBottom();

            local snap = false

            if bcX > sL and bcX < sR and bcY > sB and bcY < sT then
                
                if not slot:HasButton() then
                    snap = true;
                end
            end
            
            
            if snap then
                local prevParent =  button:GetParent();
                if prevParent ~= slot and prevParent ~= E.UIParent then
                    prevParent.Button = nil
                end
                button:SetParent(slot);
                button:ClearAllPoints();                
                button:Point("CENTER", slot, "CENTER", 0, 0);

                slot.Button = button;
                return true;
            else
                local prevParent =  button:GetParent();

                if prevParent ~= E.UIParent then
                   -- button:SetParent(prevParent);
                   -- button:ClearAllPoints();                
                    --button:Point("CENTER", prevParent, "CENTER", 0, 0);
                end
            end
        end
    end
end

local function ApplyEffectiveScaling(button, x, y, scalingType)
    local es = button:GetEffectiveScale()

    if scalingType == 1 then
        x,y = x*es,y*es
    elseif scalingType == 2 then
        x,y = x/es, y/es
    elseif scalingType == 3 then
        x,y = E:Scale(x), E:Scale(y)
    end
    return x,y 
end
local function PickupLibDBIcon(libDBSlot)

    
    --[[
        TODO:
        - Get the frame under the whole cursor
    ]]
    local button = nil
    print("AllowedButtons: "..tostring(MBR.DraggableButtons))
    if MBR.DraggableButtons then
        print("[DEBUG] MBR.DraggableButtons: "..type(MBR.DraggableButtons))
        for _, btn in ipairs(MBR.DraggableButtons) do
            if btn then      
                

                local top = btn:GetTop();
                local bottom = btn:GetBottom();
                local left = btn:GetLeft();
                local right = btn:GetRight();

                local isOver = btn:IsMouseOver(top, bottom, left, right);
                
                
                if isOver then
                    button = btn
                end
            end
        end
    end
    if not button then button = _G[GetMouseFocus():GetName()]; end
    
    if button then
        --for k,v in pairs(button) do print(k) end;
        print(button:GetName())
        --[[
            Clear cursor 
        ]]
        ClearCursor();

        if button.Icon then 
            local texture = button.Icon:GetTexture();
            SetCursor(texture);
            button:SetAlpha(0);
        end
        --[[
            TODO:
                - implement a pickup routine
        ]]
        if MBR.QuickAccessBar.Slots then 
            print("MBR.QuickAccessBar.Slots");
            local mb = MBR.QuickAccessBar.Slots[libDBSlot]

            if mb then
                print("[DEBUG] PickUpLibDBIcon: "..mb:GetName());
            end
        end
    end
end
local function PickupMinimapButton(button)
    --ClearCursor();
    local texture = button.Icon:GetTexture();
    SetCursor(133640);
    button:SetAlpha(0);
    button:StartMoving()
end
--[[ STICKYFRAMES END ]]
local function onUpdate(self, elapsed)
end
local function onDragStart(self)
    PickupLibDBIcon(1)
    self:StartMoving()
    self.isDragged = true;
end
local function onDragStop(self)
    
    if self.isDragged then
        self:StopMovingOrSizing();
        SetCursor(nil);
        self:SetAlpha(1);
        IsOverFrame(self, MBR.QuickAccessBar.Slots)
        self.isDragged = false;
    end
end
local function onMouseUp(self, button)
    
end
local function onEnter(self)
	local classColor = E:ClassColor(E.myclass, true)
    self:SetBackdropBorderColor(classColor.r,classColor.g,classColor.b,1);
end
local function onLeave(self)
    self:SetBackdropBorderColor(0,0,0,1);
    self.isOver = false;
end
function MBR:CreateToggleButton(buttonName, slotId)
    local button = CreateFrame("BUTTON","TestToggleButton", E.UIParent, "SecureActionButtonTemplate");
    button:Size(36,36);
    button:Point("CENTER",E.UIParent,"CENTER", 0,0);    
    button:SetTemplate("Transparent");

    button.Icon = CreateIcon(button, 133640);
    SetFrameLevel(button);
    SetAttributes(button, slotId)

    button.isDragged = false;
    button:EnableMouse(true);
    button:RegisterForDrag("LeftButton");
    button:SetMovable(true);
    button:SetUserPlaced(true);

    button.isOver = false;

    -- set eventhandler functions
    button:SetScript("OnUpdate",    onUpdate);
    button:SetScript("OnDragStart", onDragStart);
    button:SetScript("OnMouseUp",   onDragStop);
    button:SetScript("OnEnter",     onEnter);
	button:SetScript("OnLeave",     onLeave);

    print("AllowedButtons: "..tostring(self.DraggableButtons))
    if not tContains(self.DraggableButtons, button) then
        tinsert(self.DraggableButtons, button)
    end
    return button;
end