focus = reaper.GetCursorContext()
vol_focus=0

local function get_parents(vwin)
if vwin then
parent = reaper.JS_Window_GetParent(vwin)
if parent then
parentofparent = reaper.JS_Window_GetParent(parent)
if parentofparent then return parent, parentofparent 
else return parent, nil end
end
end
end



local function get_if_tcp(vwin)
local iftrack = reaper.JS_Window_FindChildByID(vwin, 1088)
local par, parpar = get_parents(vwin)
local _, MainHwnd = get_parents(par)

if iftrack and (MainHwnd == reaper.GetMainHwnd()) then vwintrack = reaper.JS_Window_GetLongPtr( vwin, "USERDATA") return true, vwintrack 
  
else return false, nil
end
end






focus_on_volume = reaper.GetExtState( "MyDaw", "focus_on_volume")
if (focus_on_volume and focus_on_volume ~= '') then
vadress = tonumber(focus_on_volume)
vtrack_window = reaper.JS_Window_HandleFromAddress(vadress)
 _, vtr =  get_if_tcp(vtrack_window)
vol_focus = 1
end


if vol_focus == 1 and focus == 0  then

prevdig = 49


reaper.DeleteExtState( "MyDaw", "previousdig", false )
reaper.SetExtState( "MyDaw", "previousdig", prevdig, false )

local info = debug.getinfo(1,'S');
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "SetVolume.lua")




else








end
