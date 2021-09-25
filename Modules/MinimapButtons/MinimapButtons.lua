local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')
local LDBIcon = E.Libs.LDI
local Sticky = E.Libs.SimpleSticky
local _G = _G
local pairs = pairs
local assert = assert
local unpack = unpack
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown

local countButtons = 0

--[[
	TODO: 
		- Create a function that finds the first empty SLot
		- Store the grabbed Buttons in the first empty Slot that'll be found in the Bag
		- Work on the Bag Grid Layout
		- Install other AddOns for grab all Kind of AddOnButtons
		- Make Special Buttons like Garnison/Covenant and Mail workable as well
		- Work on the QuickAccessBar
		- Recreate a Toggle for the button Bag
		- Create a Config for Inserting into ElvUI_Options
]]
-- [[ Private MouseHandler Methods ]]

	local sleep, timeSinceLastUpdate = 0.005,0
	local function OnUpdate(self, elapsed)
		timeSinceLastUpdate = timeSinceLastUpdate + elapsed; 	

		if (timeSinceLastUpdate > sleep) then
			--
			-- Insert your OnUpdate code here
			--

			timeSinceLastUpdate = 0;
		end
	end
	local function OnReceiveDrag(self)
		local infoType, info1 = GetCursorInfo()

		if self:IsMouseOver(true) then 
			print(tostring(info1))
		end
	end	
	local function OnDragStart(self)
	end
	local function OnDragStop(self)
	end
	local function OnEvent(self, event, ...)			
		if not MB.db then return end
		if not MB.GrabbedMinimapButtons then return end

		if event == "PLAYER_ENTERING_WORLD" then
			--[[ TODO:
				-- Load the last arranged ButtonList from DB
				-- sort the minimap buttons accordingly
			]] 
			if V.kyaui.minimapButtons.bars.buttonGrid.Slots then
				for k,v in pairs(V.kyaui.minimapButtons.bars.buttonGrid.Slots) do
					print(string.format("Index: %d - Value.SlotID: %d - Value.SlotName: %s", i, v.SlotID,v.SlotName))
				end
			end
			-- get all grabbed minimap buttons
			local grabbedButtons = MB.GrabbedMinimapButtons;
			-- create a new and empty List
			local newGrabbedButtons = {}

			MB.inThisWorld = true;
			print("entering this crazy world")
		elseif event =="PLAYER_LEAVING_WORLD" then
			--[[ TODO:
				-- Get the new arranged ButtonList
				-- Save it to the DB
					-- Create a Data set:
					local set = {
						SlotID = IndexOfTheSlots,
						SLotName = NameOfTheSlot,
						IsEmpty = True/False,
						MinimapButton = NameOfTheButton,
					}
					-- Save it to the Profile DB
			]] 
			

			MB.inThisWorld = false;
			print("leaving this crazy world")
		end
	end
	local function OnClick(self,button)
	end
	local function OnEnter(self)
	end
	local function OnLeave(self)
	end

-- [[ Private Core Functions]]

-- [[ Private Create Methods ]]

	------------------- Experimantal ----------------------

-- [[ public Update Methods ]]
	function MB:UpdateMinimapButtons()
		if not MB.db then return end -- Do nothing if db not initialized

		if not MB.ToggleBarsButton then return end
		-- DO UPDATE STUFF
	end
	function MB:UpdateBar(bar)
		if not bar then return end -- Do nothing if bar is nil or nopt initialized
		if not MB.db then return end -- Do nothing if db is not initialized
		if not MB.db.enabled then return end -- Do nothing if module is not enabled
		if not MB.inThisWorld then return end

		

		-- DO UPDATE STUFF
		if bar:GetName() == "KyaUI_ButtonGrid" then 
			if bar.Buttons then

				local gridLayout = MB.db.bars.buttonGrid.gridLayout;
				local slotCount = gridLayout.columns * gridLayout.rows;

				local buttonGrid = MB.db.bars.buttonGrid;
				local buttonsPerRow = buttonGrid.gridLayout.columns;				
				local buttonSpacing = buttonGrid.buttonSpacing;
				local borderSpacing = 2*buttonGrid.borderSpacing;
				local borderWidth = 2*buttonGrid.borderWidth;
				local buttonSize = buttonGrid.buttonSize;

				local width = slotCount*buttonSize + (slotCount-1) * buttonSpacing + borderSpacing + borderWidth;
				local height = buttonSize + borderSpacing + borderWidth;	
				
				for i=1, slotCount do
					MB.Core:CreateSlot(bar, i, buttonName);
					local position = buttonGrid.borderSpacing + buttonGrid.borderWidth + (i-1) * buttonSpacing + (i-1)*buttonSize;
					bar.Buttons[i]:SetPoint('LEFT',bar, position,0)	
					
					bar.Buttons[i]:Show();
				end						
				
				if MB.db.bars.buttonGrid.buttons then
					for k, v in pairs(MB.db.bars.buttonGrid.buttons) do
						local slot = MB.Bars["KyaUI_ButtonGrid"].Buttons[k];
						if slot:GetName() == v.SlotName then
							print(tostring(v.SlotID).." - "..tostring(v.IsEmpty));

							if v.MinimapButton then
								for kG,vG in pairs(MB.GrabbedMinimapButtons) do
									local grabbedButton = vG;
									
									if not grabbedButton.isSkinned then
										MB.Core:SkinGrabbedMinimapButton(grabbedButton);
										grabbedButton.isSkinned = true;
									end
									if not grabbedButton.isDraggable then
										MB.Core:MakeGrabbedMinimapButtonsDraggable(grabbedButton, Update)
										grabbedButton.isDraggable = true;
									end
									MB.DragAndDrop:AttachToSlot(grabbedButton, slot)
								end
							end
						end
					end	
				else					
					local index = 1					
					for k,v in pairs(MB.GrabbedMinimapButtons) do
						local grabbedButton = v;

						MB.Core:SetParentForGrabbedMinimapButton(grabbedButton, bar.Buttons[index]);

						if not grabbedButton.isSkinned then
							MB.Core:SkinGrabbedMinimapButton(grabbedButton);
							grabbedButton.isSkinned = true;
						end
						if not grabbedButton.isDraggable then
							MB.Core:MakeGrabbedMinimapButtonsDraggable(grabbedButton, Update)
							grabbedButton.isDraggable = true;
						end

						-- Set to nil / true when dropping the Button on an other Slot
						bar.Buttons[index].MinimapButton = grabbedButton;
						bar.Buttons[index].isEmpty = false;
						index = index + 1;
					end
				end	

				bar:SetWidth(width);
				bar:SetHeight(height);
				
				
				if MB.db.enabled then 
					bar:Show();
				else
					bar:Hide();
				end
			end
		end
	end

-- [[ public Toggle Method ]]
	function MB:Toggle()
		if not MB.db then return end

		if MB.db.enabled then
			MB:UpdateMinimapButtons()
			if MB.Bars then
				for key,bar in pairs(MB.Bars) do
					bar:RegisterEvent("PLAYER_ENTERING_WORLD")
					bar:RegisterEvent("PLAYER_LEAVING_WORLD")
					bar:SetScript("OnEvent", function(self, event, ...)
						OnEvent(self,event,...);
						MB:UpdateBar(self)
					end)
					if bar.mover then
						MB:UpdateBar(bar)
						E:EnableMover(bar.mover:GetName())
					end
				end
			end
		else
			MB:UpdateMinimapButtons()
			
			if MB.Bars then
				for key,bar in pairs(MB.Bars) do
					bar:UnregisterEvent("PLAYER_ENTERING_WORLD")
					bar:UnregisterEvent("PLAYER_LEAVING_WORLD")
					bar:SetScript("OnEvent", nil)
					if bar.mover then
						MB:UpdateBar(bar)
						E:DisableMover(bar.mover:GetName())
					end
				end
			end
		end
	end

-- [[ Public Constructor ]]
	function MB:Initialize()
		-- set ProfileDB
		MB.db = E.db.kyaui.minimapButtons
		if not MB.db.bars.buttonGrid.buttons then MB.db.bars.buttonGrid.buttons = {} end
		MB.loadedButtonsFromDB = false
		if not MB.Core and not MB.Bars then return end

		MB.Core:CreateQuickAccessBar()
		MB.Core:CreateButtonGrid()
	
		MB.Core:GrabMinimapButtons()
		
		MB:Toggle()
		
		MB.Initialized = true
	end

-- [[ Register Module ]]
	KYA:RegisterModule(MB:GetName())