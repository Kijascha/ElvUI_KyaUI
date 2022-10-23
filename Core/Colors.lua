local KYA, E, L, V, P, G = unpack(select(2, ...));

local predefinedColors = {
  Black             = { r = 0,    g = 0,    b = 0 },
  White             = { r = 255,  g = 255,  b = 255 },
  Aqua              = { r = 0,    g = 255,  b = 255 },
  Coral             = { r = 255,  g = 127,  b = 80 },
  LightCoral        = { r = 240,  g = 128,  b = 128 },
  DeepSkyBlue       = { r = 0,    g = 191,  b = 255 },
  DeepPink          = { r = 255,  g = 20,   b = 147 },
  LightGreen        = { r = 144,  g = 238,  b = 144 },
  LightBlue         = { r = 173,  g = 216,  b = 230 },
  LightSkyBlue      = { r = 135,  g = 206,  b = 250 },
  LightSeaGreen     = { r = 32,   g = 178,  b = 170 },
  Green             = { r = 0,    g = 128,  b = 0 },
  Gray              = { r = 128,  g = 128,  b = 128 },
  DimGray           = { r = 105,  g = 105,  b = 105 },
  Red               = { r = 255,  g = 0,    b = 0 },
  DarkRed           = { r = 139,  g = 0,    b = 0 },
  Blue              = { r = 0,    g = 0,    b = 255 },
  Purple            = { r = 128,  g = 0,    b = 128 },
  Lime              = { r = 128,  g = 128,  b = 128 },
  Teal              = { r = 0,    g = 128,  b = 128 },
  Orange            = { r = 255,  g = 99,  b = 71 },
  OrangeRed         = { r = 255,  g = 69,   b = 0 },
  Tomato            = { r = 255,  g = 165,  b = 0 },
  Cyan              = { r = 0,    g = 255,  b = 255 },
  Orchid            = { r = 218,  g = 112,  b = 214 },
  GoldenRod         = { r = 218,  g = 165,  b = 32 },
  Crimson           = { r = 220,  g = 20,   b = 60 },
  Indigo            = { r = 75,   g = 0,    b = 130 },
  Azure             = { r = 240,  g = 255,  b = 255 },
  AliceBlue         = { r = 240,  g = 248,  b = 255 },
  GreenYellow       = { r = 173,  g = 255,  b = 47 },
  DarkSeaGreen      = { r = 143,  g = 188,  b = 143 },
  DarkOrchid        = { r = 153,  g = 50,   b = 204 },
  DarkMagenta       = { r = 139,  g = 0,    b = 139 },
  DarkTurquoise     = { r = 0,    g = 206,  b = 209 },
  MediumSeaGreen    = { r = 60,   g = 179,  b = 113 },
  MediumTurquoise   = { r = 72,   g = 209,  b = 204 },
  MediumSpringGreen = { r = 0,    g = 250,  b = 154 },
}

-- Class Color stuff
local classColors = {}
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	classColors[class] = {}
	classColors[class].r = value.r
	classColors[class].g = value.g
	classColors[class].b = value.b
	classColors[class].colorStr = value.colorStr
end
local playerClassColor = {
  r = classColors[E.myclass].r, 
  g = classColors[E.myclass].g,
  b = classColors[E.myclass].b
}

Color = {}; -- define object
--[[ Static Tables ]]
Color.PredefinedColors = predefinedColors;
Color.ClassColors = classColors;
Color.PlayerClassColor = playerClassColor;

function Color:new()  -- create a new instance of the object
  local self = {}; 
  
  self.a = nil
  self.r = nil
  self.g = nil
  self.b = nil

  --[[ public Object Methods ]]
  self.isArgbValueValid = function(self,value)
    local int = math.type(1)
    local float = math.type(1.0)

    if (math.type(value) == float) and ((value >= 0) and (value <= 1)) then return true;
    elseif (math.type(value) == int) and ((value >= 0) and (value <= 255)) then return true; end
    return false;
  end
  self.ToHex = function(self, useHashtag, useAlpha)
    if not (self.r and self.g and self.b) then return end;
    if useAlpha and not self.a then return end
    
    local hexString = "";
    if useHashtag then hexString = hexString .. "#"; end
    
    if useAlpha then
      local a = string.format("%x",math.floor(self.a * 255));
      hexString = hexString .. a;
    end
  
    local r = string.format("%x",math.floor(self.r * 255))  
    local g = string.format("%x",math.floor(self.g * 255))
    local b = string.format("%x",math.floor(self.b * 255))
  
    hexString = hexString .. r .. g .. b
    return hexString
  end

  return self; 
end
 --[[ public Static Methods ]]
function Color:FromArgb(a,r,g,b)  -- create a new instance of the object with custom parameters
    self = Color:FromRgb(r,g,b)
    if self and self:isArgbValueValid(a) then
      self.a = a;
      return self;
    end
    return nil;
end
function Color:FromRgb(r,g,b)  -- create a new instance of the object with custom parameters
  self = Color:new();
  if self:isArgbValueValid(r) and self:isArgbValueValid(g) and self:isArgbValueValid(b) then
    self.r = r;
    self.g = g;
    self.b = b; 
    return self;  
  end
  return nil;
end
function Color:FromHex(hex) -- create a new instance of the object with custom parameters
  local hex = hex:gsub("#","")
  if hex:len() == 4 then
    return self:FromArgb((tonumber("0x"..hex:sub(1,1))*17)/255, (tonumber("0x"..hex:sub(2,2))*17)/255, (tonumber("0x"..hex:sub(3,3))*17)/255, (tonumber("0x"..hex:sub(4,4))*17)/255);
  elseif hex:len() == 8 then
    return self:FromArgb(tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255, tonumber("0x"..hex:sub(7,8))/255);
  elseif hex:len() == 3 then
    return self:FromRgb((tonumber("0x"..hex:sub(1,1))*17)/255, (tonumber("0x"..hex:sub(2,2))*17)/255, (tonumber("0x"..hex:sub(3,3))*17)/255);
  else
    return self:FromRgb(tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255);
  end
end

function Colorize(textString, HexColorString)
    local colorStart = "|c"
    local colorHex = HexColorString
    local colorEnd = "|r"

    return colorStart..colorHex..textString..colorEnd;
end

