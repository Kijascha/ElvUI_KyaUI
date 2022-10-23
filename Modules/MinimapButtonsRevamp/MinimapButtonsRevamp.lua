local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');
local LDB = E.Libs.LDB
local LDI = E.Libs.LDI

function MBR:Initialize()
    -- set DeveloperMode
    self.DeveloperMode = false;

    MBR.DraggableButtons = {}
    
    if LDB then
        local minimapButton = LDB:NewDataObject("KyaUI_TestButton", {
            type = "launcher",
			text = "KyaUI_TestButton",
            icon = 133640,
            OnClick = function(_, button)
                if button == "LeftButton" then print("Hello, World!") end
            end,
            OnTooltipShow = function(tt)
                tt:AddLine("KyaUI_TestButton")
                tt:AddLine("|cffffff00Click|r to print 'Hello, World!'")
            end,
        })
        if LDI then
            LDI:Register("KyaUI_TestButton", minimapButton) -- PC_MinimapPos is a SavedVariable which is set to 90 as default
        end
    end

    MBR.QuickAccessBar = self:CreateQuickAccessBar()
    MBR.QuickAccessBar:Show();

    local button = self:CreateToggleButton("TestToggleButton", 1)
    button:Show();

    E:CreateMover(MBR.QuickAccessBar, "KyaUI_"..MBR.QuickAccessBar:GetName().."Mover", "KyaUI_"..MBR.QuickAccessBar:GetName(), nil, nil, nil, "ALL,MINIMAP,KYAUI", nil, "kyaui,mbrQuickAccessBar")
    E:EnableMover(MBR.QuickAccessBar.mover:GetName())
    --local button1 = MBR:CreateToggleButton("TestToggleButton1");
    --button1:Show();
    self.Initialized = true
end

-- [[ Register Module ]]
KYA:RegisterModule(MBR:GetName())