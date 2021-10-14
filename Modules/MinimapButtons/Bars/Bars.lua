local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

MB.Bars = {}

--[[---------------------------------------
            Private Functions
-------------------------------------------]]
local function barExists(Bar)
    if not bar then return false end
    if not bar.GetName then return false end

    for barName, bar in pairs(MB.Bars) do
        print(barName);
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
local function getBarByName(name)
    if name then
        return MB.Bars[name];
    end
    return nil;
end
local function countBars()
    return #MB.Bars;
end
local function addBar(barTable, bar)
    if not barExists(bar) then
        barTable = bar;
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
            Public Methods
-------------------------------------------]]

function MB.Bars:CreateBar(Name, Parent)
    if not MB.db then return end
    if not MB.db.enabled then return end
    if not MB.db.bars then return end

    local point = MB.db.bars.defaultPoint;
	local bar = CreateFrame("Frame","KyaUI_"..Name, Parent, "BackdropTemplate")
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

    return bar 
end

function MB.Bars:GetBarByName(Name)
    return getBarByName(Name);
end
function MB.Bars:ClearSlots(bar)
    local slots = bar.Buttons;

    for i=1, #slots do
        slots[i].isEmpty = true;
        slots[i].MinimapButton = nil;
    end
end