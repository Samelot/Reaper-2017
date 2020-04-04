function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end


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

----WINDOW----FUCTION--- end

function get_focus_position(vtrack_window, vtr)
folder_indent = 8
local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(vtrack_window)
local vtrack_height =  (bottom - top) 
local vtrack_width = (right - left) 
local track_height = (bottom - top) 
if vtrack_width >368 and track_height < 44 then
v_ui_left_button_edge_crdnts  = 166
v_ui_top_button_edge_crdnts = 4
elseif vtrack_width <= 368 and track_height < 44 then
v_ui_left_button_edge_crdnts = 105
v_ui_top_button_edge_crdnts = 4
elseif vtrack_width <= 368 and track_height >= 44 then
v_ui_left_button_edge_crdnts = 44
v_ui_top_button_edge_crdnts = 25
elseif vtrack_width > 368 and track_height >= 44 then
v_ui_left_button_edge_crdnts = 44
v_ui_top_button_edge_crdnts = 25
end
v_ui_left_button_edge_crdnts=v_ui_left_button_edge_crdnts+(reaper.GetTrackDepth(vtr)*folder_indent)
local v_button_width = 57
local v_button_height = 17
----------------------------------------------------
local v_left_border = left+v_ui_left_button_edge_crdnts
local v_right_border = v_left_border + v_button_width
local v_top_border = top + v_ui_top_button_edge_crdnts 
local v_bottom_border =  v_top_border + v_button_height 
return v_ui_left_button_edge_crdnts, v_ui_top_button_edge_crdnts, v_button_width, v_button_height 
end

TrackGuid = reaper.GetExtState( "MyDaw", "focus_on_volume", false )
if TrackGuid and TrackGuid~= "" then

vadress = tonumber(TrackGuid)
vtrack_window = reaper.JS_Window_HandleFromAddress(vadress)
 _, vtr =  get_if_tcp(vtrack_window)
is_trackidx  =  reaper.GetMediaTrackInfo_Value( vtr, "IP_TRACKNUMBER")
v_ui_left_button_edge_crdnts, v_ui_top_button_edge_crdnts, v_button_width, v_button_height = get_focus_position(vtrack_window,vtr)
voltrack = reaper.JS_GDI_GetWindowDC(vtrack_window)





end


function loop_focus()

TrackGuid = reaper.GetExtState( "MyDaw", "focus_on_volume", false )
if TrackGuid and TrackGuid~= "" and vtrack_window and vtr  then
local _, left, top, right, bottom = reaper.JS_Window_GetClientRect(vtrack_window)
local vtrack_height =  (bottom - top) 
local vtrack_width = (right - left) 
getistrack =  reaper.GetTrack( 0, is_trackidx )	

local r_click = reaper.JS_Mouse_GetState(15)

if getistrack and r_click > 0 then vdepth = reaper.GetTrackDepth(vtr) end






if tcp_vdepth ~= nil then
if  tcp_height ~= vtrack_height  or tcp_width ~= vtrack_width  or tcp_vdepth ~= vdepth   then  get_focus_position(vtrack_window, vtr) end
end

tcp_height = vtrack_height
tcp_width = vtrack_width
tcp_vdepth = vdepth


reaper.JS_GDI_Line( voltrack, v_ui_left_button_edge_crdnts, v_ui_top_button_edge_crdnts,v_ui_left_button_edge_crdnts+v_button_width, v_ui_top_button_edge_crdnts )
reaper.JS_GDI_Line( voltrack, v_ui_left_button_edge_crdnts, (v_ui_top_button_edge_crdnts+v_button_height) ,v_ui_left_button_edge_crdnts+v_button_width, (v_ui_top_button_edge_crdnts+v_button_height))
reaper.JS_GDI_Line( voltrack, v_ui_left_button_edge_crdnts, v_ui_top_button_edge_crdnts,v_ui_left_button_edge_crdnts, (v_ui_top_button_edge_crdnts+v_button_height) )
reaper.JS_GDI_Line( voltrack,v_ui_left_button_edge_crdnts+v_button_width, v_ui_top_button_edge_crdnts,v_ui_left_button_edge_crdnts+v_button_width, (v_ui_top_button_edge_crdnts+v_button_height) )
reaper.defer(loop_focus)
end
end

loop_focus()

--reaper.JS_GDI_ReleaseDC( track_window, voltrack )







