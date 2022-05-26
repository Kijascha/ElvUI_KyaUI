local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:AddDragabilityToRegisteredButtons()

    table.foreach(MB.DragAndDrop.RegisteredMinimapButtons, function(ButtonName,Button)

        Button.isDragging = false;
        Button.isDroppable = false;
        Button.isReadyToDrop = false;

        Button:SetMovable(true)
        Button:RegisterForDrag("LeftButton")        
        Button:HookScript("OnUpdate", function(self) end)
        Button:SetScript("OnDragStart", function(self) 
            if not MB.Bars.ButtonGrid then return end
            MB.DragAndDrop:DragStart(self, MB.Bars.AllowedFrames);
            self.isDragging = true;
    
            MB.DragAndDrop:ShrinkAndResize(self, self.isDragging);
        end)
        Button:SetScript("OnDragStop", function(self) 
            local success, slot = MB.DragAndDrop:Drop(self);
    
            self.isDragging = false;
            
            MB.DragAndDrop:ShrinkAndResize(self, self.isDragging);
    
            local prevParent = self:GetParent();
            --print(prevParent:GetName())
            if success  and slot.isEmpty then
                
                prevParent.isEmpty = true;
                prevParent.MinimapButton = nil;
                slot.isEmpty = false;
                slot.MinimapButton = self;
                slot.MinimapButton.Name = self:GetName();
    
                MB.DragAndDrop:AttachToSlot(self, slot);
            elseif (self:GetParent() ~= E.UIParent or self:GetParent() ~= UIParent) then
                if prevParent.GetParent and prevParent:GetParent():GetName() == "KyaUI_QuickAccessBar" then
                    
                    prevParent.isEmpty = true;
                    prevParent.MinimapButton = nil;
                    local newSlot = MB.DragAndDrop:FindFirstEmptySlot(MB.Bars.ButtonGrid)
                    
                    newSlot.isEmpty = false;
                    newSlot.MinimapButton = self;
                    newSlot.MinimapButton.Name = self:GetName();
    
                    MB.DragAndDrop:AttachToSlot(self, newSlot);
                else
                    MB.DragAndDrop:AttachToSlot(self, self:GetParent());
                end
            end
            if not V.kyaui.minimapButtons then return end
    
            MB.Bars.DB:SaveLayout(MB.Bars.ButtonGrid:GetName(), MB.Bars.ButtonGrid.Buttons)
            MB.Bars.DB:SaveLayout(MB.Bars.QuickAccessBar:GetName(), MB.Bars.QuickAccessBar.Buttons)
       end)

    end)
end