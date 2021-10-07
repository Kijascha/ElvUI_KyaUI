local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.Bars then return end

MB.Bars.ButtonGrid = nil

function MB.Bars:CreateButtonGrid()
    if not MB.db then return end
    if not MB.db.bars.buttonGrid then return end

    local barName = "ButtonGrid";
    local parent = E.UIParent;
    local point = MB.db.bars.buttonGrid.defaultPoint;
    
    MB.Bars.ButtonGrid = MB.Bars:CreateBar(barName, parent)
    local bar = MB.Bars.ButtonGrid
    if bar then
        bar:SetPoint(
            point.Point or "CENTER",
            point.Anchor or parent,
            point.RelativePoint or "CENTER",
            point.XOffSet or 0,
            point.YOffSet or 0);	
            
        E:CreateMover(bar, "KyaUI_"..barName.."Mover", "KyaUI_"..barName, nil, nil, nil, "ALL,MINIMAP,KYAUI", nil, "kyaui,buttonGrid")
        return true;
    end
    return false;
end