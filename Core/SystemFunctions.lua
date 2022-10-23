local KYA, E, L, V, P, G = unpack(select(2, ...));

local sformat = string.format
local print, type = print, type

KYA.DebugTools = {}
KYA.DebugTools.Prefix = {}
KYA.DebugTools.Prefix.Print = "|cffff35da[PRINT]|r "
KYA.DebugTools.Prefix.Error = "|cffff35da[ERROR]|r "
KYA.DebugTools.Prefix.Warning = "|cffff35da[WARNING]|r "
KYA.DebugTools.Prefix.Debug = "|cffff35da[DEBUG]|r "

local function systemPrint(msg,...)
    if not msg then return end
    if not type(msg) == "string" then return end

    local args = ...
    
    if args then
        print(sformat(msg,args));
    end
    return print(msg);
end
function KYA.DebugTools:Print(msg,...)
    systemPrint(KYA.DebugTools.Prefix.Print..msg,...);
end
function KYA.DebugTools:Debug(debugType, msg,...)
    if debugType == "error" then
        systemPrint(KYA.DebugTools.Prefix.Error..msg,...);
    elseif debugType == "warning" then
        systemPrint(KYA.DebugTools.Prefix.Warning..msg,...);
    else
        systemPrint(KYA.DebugTools.Prefix.Debug..msg,...);
    end
end


