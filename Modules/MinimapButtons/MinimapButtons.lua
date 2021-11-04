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
local tContains = tContains
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
	local function mergeTables(t1,t2)
		if type(t1) == "table" and type(t2) == "table" then
			local tOut = {}

			local index = 1
			for k,v in pairs(t1) do tOut[index] = v; index = index + 1; end			
			for k,v in pairs(t2) do tOut[index] = v; index = index + 1; end

			return tOut;
		end
		return nil;
	end
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
			MB.Core:GrabMinimapButtons()

			if MB.Bars.ToggleButtonBag then
				MB.Bars.ButtonGrid:Hide();
			end
			MB.inThisWorld = true;
		elseif event =="PLAYER_LEAVING_WORLD" then
			MB.inThisWorld = false;
		end
	end
	local function OnClick(self,button)
	end
	local function OnEnter(self)
	end
	local function OnLeave(self)
	end

-- [[ public Update Methods ]]
	function MB:UpdateBar(bar)
		if not bar then return end -- Do nothing if bar is nil or nopt initialized
		if not MB.db then return end -- Do nothing if db is not initialized
		if not MB.db.enabled then return end -- Do nothing if module is not enabled
		if not MB.inThisWorld then return end

		if not MB.Bars then return end

		-- DO UPDATE STUFF
		if bar:GetName() == "KyaUI_ButtonGrid" then 
			if bar.Buttons then

				local buttonGrid = MB.db.bars.buttonGrid; -- get button grid
				local gridLayout = buttonGrid.gridLayout; -- Get the grid layout
				local columns = gridLayout.columns; -- get number of columns
				local rows = gridLayout.rows; -- get number of rows

				local numberOfSlots = columns * rows;

				local buttonsPerRow = columns;				
				local buttonSpacing = buttonGrid.buttonSpacing;
				local borderSpacing = 2*buttonGrid.borderSpacing;
				local borderWidth = 2*buttonGrid.borderWidth;
				local buttonSize = buttonGrid.buttonSize;	
				
				--[[
					Create slots
				]]
				for i=1, numberOfSlots do
					MB.Core:CreateSlot(bar, i);
					local position = buttonGrid.borderSpacing + buttonGrid.borderWidth + (i-1) * buttonSpacing + (i-1)*buttonSize;
					bar.Buttons[i]:SetPoint('LEFT',bar, position,0)	
					bar.Buttons[i].MinimapButton = nil;
					bar.Buttons[i].isEmpty = true;
					bar.Buttons[i]:Show();
				end	

				MB.Bars:ClearSlots(bar);
				--[[
					Store in AllowedFrames for drag and drop usage
				]]
				for i=1, #bar.Buttons do
					tinsert(MB.Bars.AllowedFrames, bar.Buttons[i])
				end

				--[[ 
					Apply grid layout 
				]]
				local index = 1
				for j=1, rows do
					local posY = buttonGrid.borderSpacing + buttonGrid.borderWidth + (j-1) * buttonSpacing + (j-1)*buttonSize;							
					for i=1, columns do
						local posX = buttonGrid.borderSpacing + buttonGrid.borderWidth + (i-1) * buttonSpacing + (i-1)*buttonSize;
						
						if j > 1 then
							bar.Buttons[index]:SetPoint('TOPLEFT',bar, posX,-posY)
						else
							posY = buttonGrid.borderSpacing + buttonGrid.borderWidth;
							bar.Buttons[index]:SetPoint('TOPLEFT',bar, posX,-posY)
						end
						index = index + 1
					end
				end

				--[[
					Set size
				]]
				local width = columns*buttonSize + (columns-1) * buttonSpacing + borderSpacing + borderWidth;
				local height = rows*buttonSize + (rows-1) * buttonSpacing + borderSpacing + borderWidth;

				bar:SetWidth(width);
				bar:SetHeight(height);				
				
				if MB.db.enabled then
					--[[
						Attach all grabbed Minimap Buttons on the Bar
					]]
					for k,v in pairs(MB.GrabbedMinimapButtons) do
						local grabbedButton = v;
	
						local emptySlot = MB.DragAndDrop:FindFirstEmptySlot(bar);
						MB.DragAndDrop:AttachToSlot(grabbedButton, emptySlot)
	
						-- Set to nil / true when dropping the Button on an other Slot
						emptySlot.MinimapButton = grabbedButton;
						emptySlot.isEmpty = false;
					end
		
					--[[						
						Reposition the grabbed Minimap Buttons according to the last session
					]]
					local savedLayout = MB.Bars.DB:LoadLayout(bar:GetName())
					if savedLayout then
						local tempList = {}
						local index = 1;
						for i,j in pairs(MB.GrabbedMinimapButtons) do							
							local grabbedButton = j;
							for k, v in pairs(savedLayout) do
								if grabbedButton:GetName() == v.MinimapButton then
									local slot = bar.Buttons[v.SlotID]
	
									local prevParent = grabbedButton:GetParent();
											
									if tContains(bar.Buttons, prevParent) then
										prevParent.isEmpty = true;
										prevParent.MinimapButton = nil;
									end

									slot.isEmpty = false;
									slot.MinimapButton = grabbedButton;
									slot.MinimapButton.Name = grabbedButton:GetName();
									MB.DragAndDrop:AttachToSlot(grabbedButton, slot)
								end
							end
						end
					end
					
					--[[
						Save current Minimap Buttons Layout
					]]
					MB.Bars.DB:SaveLayout(bar:GetName(), bar.Buttons);

					bar:Show();
				else
					bar:Hide();
				end
			end
		end

		if bar:GetName() == "KyaUI_QuickAccessBar" then
			if bar.Buttons then
				
				local quickAccessBar = MB.db.bars.quickAccessBar; -- get quick access bar

				local numberOfSlots = quickAccessBar.slots + 1; -- just add an additional Slot for the toggle button
			
				local buttonSpacing = quickAccessBar.buttonSpacing;
				local borderSpacing = 2*quickAccessBar.borderSpacing;
				local borderWidth = 2*quickAccessBar.borderWidth;
				local buttonSize = quickAccessBar.buttonSize;	
				
				--[[
					Create slots
				]]
				for i=1, numberOfSlots do
					MB.Core:CreateSlot(bar, i);
					local position = quickAccessBar.borderSpacing + quickAccessBar.borderWidth + (i-1) * buttonSpacing + (i-1)*buttonSize;
					bar.Buttons[i]:SetPoint('LEFT',bar, position,0)	
					bar.Buttons[i].MinimapButton = nil;
					bar.Buttons[i].isEmpty = true;
					bar.Buttons[i]:Show();

				end

				--[[
						Store in AllowedFrames for drag and drop usage

					if MB.Bars.AllowedFrames then
						print(#MB.Bars.AllowedFrames)
					end
				]]
				for i=1, #bar.Buttons - 1 do
					tinsert(MB.Bars.AllowedFrames, bar.Buttons[i])
				end
				--[[
					Add Toggle Button for the button bag
				]]
				if MB.Bars.ToggleButtonBag then
					MB.DragAndDrop:AttachToSlot(MB.Bars.ToggleButtonBag, bar.Buttons[#bar.Buttons])
				end
				
				--[[
					Set size
				]]
				local width = numberOfSlots*buttonSize + (numberOfSlots-1) * buttonSpacing + borderSpacing + borderWidth;
				local height = buttonSize + borderSpacing + borderWidth;

				bar:SetWidth(width);
				bar:SetHeight(height);
				
		
				--[[						
					Reposition the grabbed Minimap Buttons according to the last session
				]]
				local savedLayout = MB.Bars.DB:LoadLayout(bar:GetName())
				if savedLayout then
					local tempList = {}
					local index = 1;
					for i,j in pairs(MB.GrabbedMinimapButtons) do							
						local grabbedButton = j;
						for k, v in pairs(savedLayout) do
							if grabbedButton:GetName() == v.MinimapButton then
								local slot = bar.Buttons[v.SlotID]
								local prevParent = grabbedButton:GetParent();
											
								prevParent.isEmpty = true;
								prevParent.MinimapButton = nil;

								slot.isEmpty = false;
								slot.MinimapButton = grabbedButton;
								slot.MinimapButton.Name = grabbedButton:GetName();
								MB.DragAndDrop:AttachToSlot(grabbedButton, slot)
							end
						end
					end
				end
				
				--[[
					Save current Minimap Buttons Layout
				]]
				MB.Bars.DB:SaveLayout(bar:GetName(), bar.Buttons);
			end
		end
	end

-- [[ public Toggle Method ]]
	function MB:Toggle()
		if not MB.db then return end

		if MB.db.enabled then
			if MB.Bars then
				for k,v in pairs(MB.Bars) do print(k) end
				for key,bar in pairs(MB.Bars) do
					
					if key == "QuickAccessBar" or key == "ButtonGrid" then
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
			end
		else
			MB:UpdateMinimapButtons()
			
			if MB.Bars then
				for key,bar in pairs(MB.Bars) do
					
					if key == "QuickAccessBar" or key == "ButtonGrid" then
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
	end

-- [[ Public Constructor ]]
	function MB:Initialize()
		-- set ProfileDB
		MB.db = E.db.kyaui.minimapButtons
		if not MB.db.bars.buttonGrid.buttons then MB.db.bars.buttonGrid.buttons = {} end
		MB.loadedButtonsFromDB = false
		if not MB.Core and not MB.Bars then return end

		MB.Bars.AllowedFrames = {}
		if not MB.Bars.QuickAccessBar then MB.Bars:CreateQuickAccessBar() end			
		if not MB.Bars.ButtonGrid then MB.Bars:CreateButtonGrid() end

		MB.Core:CreateToggleButton()
		MB:Toggle()
		
		
		MB.Initialized = true
	end

-- [[ Register Module ]]
	KYA:RegisterModule(MB:GetName())