function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
  
end




----------------------------------------FUNCTIONS-----START----------------------------------------------------------

--------------------------------------------NEW_BLOCK-------------------------------------------------------------------

crash = function (errObject)

  local byLine = "([^\r\n]*)\r?\n?"
  local trimPath = "[\\/]([^\\/]-:%d+:.+)$"
  local err = errObject   and string.match(errObject, trimPath)
                          or  "Couldn't get error message."

  local trace = debug.traceback()
  local stack = {}
  for line in string.gmatch(trace, byLine) do
    local str = string.match(line, trimPath) or line
    stack[#stack + 1] = str
  end

  local name = ({reaper.get_action_context()})[2]:match("([^/\\_]+)$")


  
  
  
  
  local ret = reaper.ShowMessageBox(
      name.." has crashed!\n\n"..
      "Would you like to have a crash report printed "..
      "to the Reaper console?",
      "Oops",
      4
    )

  if ret == 6 then
	
  
local info = debug.getinfo(1,'S');
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "Interface Override.lua")	
  


    reaper.ShowConsoleMsg(
      "Error: "..err.."\n\n"..
      "Stack traceback:\n\t"..table.concat(stack, "\n\t", 2).."\n\n"..
      "Reaper:       \t"..reaper.GetAppVersion().."\n"..
      "Platform:     \t"..reaper.GetOS()
    )
 
 else 
  
  local info = debug.getinfo(1,'S');
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "Interface Override.lua")	




 end

  

  
  end











local function get_nearest_item(x,y,mouse_tr, y_start)

c_item = nil

local function to_pixel(val)
  local pixel = math.floor(val * reaper.GetHZoomLevel())
  return pixel
end




local function project_info()
  local track_window = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)		
  local Arr_start_time, _ = reaper.GetSet_ArrangeView2(0, false, 0, 0) -- GET ARRANGE VIEW
  local Arr_pixel = to_pixel(Arr_start_time)-- ARRANGE VIEW POSITION CONVERT TO PIXELS
  local _, x_view_start, _, _, _ = reaper.JS_Window_GetRect(track_window) -- GET TRACK WINDOW X-Y COORDINATES
  return Arr_pixel, x_view_start
end


local Arr_pixel,x_view_start = project_info()


function get_next_get_previous_item(c_item,track)

local  itemhere  = reaper.ValidatePtr2( 0, c_item , "MediaItem*")


if c_item  and track and itemhere then
	

selItemPos = reaper.GetMediaItemInfo_Value(c_item, 'D_POSITION')

		count_items_tracks = reaper.GetTrackNumMediaItems(track)

	if count_items_tracks > 1	 then
		for i = 0, count_items_tracks-1 do
	    nxt_item = reaper.GetTrackMediaItem(track, i)-- Get selected item i
		if nxt_item then
		nxt_item_pos = reaper.GetMediaItemInfo_Value(nxt_item, "D_POSITION")
		
		if nxt_item_pos > selItemPos then
				    next_item_start = nxt_item_pos
					break
				end
			 end
		   end       
		for i = count_items_tracks,0, -1  do
		    prv_item = reaper.GetTrackMediaItem(track, i)
			local itemhere2  = reaper.ValidatePtr2( 0, prv_item , "MediaItem*")
			if prv_item and itemhere2 then
			prv_item_pos = reaper.GetMediaItemInfo_Value(prv_item, "D_POSITION")
			  retval, stringNeedBig = reaper.GetSetMediaItemTakeInfo_String( reaper.GetActiveTake(prv_item), "P_NAME", 0, 0 )
			if prv_item_pos < selItemPos then
					   prev_item_end = prv_item_pos + reaper.GetMediaItemInfo_Value(prv_item, "D_LENGTH")
						break
				  end
			    end
			 end

end
end			 


c_item =nil

track=nil

if 	prev_item_end then prev_item_end=(to_pixel(prev_item_end)+(x_view_start-Arr_pixel))
else  prev_item_end = 0 end  


if next_item_start then next_item_start=(to_pixel(next_item_start)+(x_view_start-Arr_pixel))
else  next_item_start=1204 end 	 
			 

			 
return prev_item_end, next_item_start

end 









	


local mouse_x, mouse_y = reaper.GetMousePosition()



if  mouse_tr then


local items = reaper.CountTrackMediaItems(mouse_tr)

if  items > 0 then
---[[
for i = 0, items - 1 do
local item = reaper.GetTrackMediaItem(mouse_tr,i)
it_x = (to_pixel(reaper.GetMediaItemInfo_Value(item, 'D_POSITION'))+(x_view_start-Arr_pixel))
it_y = (to_pixel(reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')+reaper.GetMediaItemInfo_Value(item, 'D_POSITION'))+(x_view_start-Arr_pixel))
item_y = reaper.GetMediaItemInfo_Value( item , "I_LASTY")
item_h = reaper.GetMediaItemInfo_Value( item , "I_LASTH")

if (it_x-6 < mouse_x and  it_y+6 > mouse_x) and mouse_y > (y_start+item_y) and mouse_y < (y_start+item_y+item_h)  then
    
	item_c = item

  
item_c_half = (y_start+item_y+(item_h/2))
l_edge_start =  it_x-6 
l_edge_end   =  it_x+9 
r_edge_start = it_y-8
r_edge_end   = 	it_y+6 
break
end
-----------------------------------------------------END_OF_FIRST IF
end


if item_c_half and l_edge_start and l_edge_end  and r_edge_start and r_edge_end  then


if  (l_edge_start < mouse_x and l_edge_end > mouse_x) and (mouse_y > item_c_half) or 
	(r_edge_start < mouse_x and r_edge_end > mouse_x) and (mouse_y > item_c_half) or 
	(l_edge_start < mouse_x and it_x > mouse_x) and (mouse_y < item_c_half) or  
	(it_y < mouse_x and r_edge_end > mouse_x) and (mouse_y < item_c_half)
	then
	is_over_edge=true

else 

	
is_over_edge=false	

end  



if it_x < mouse_x and it_y < mouse_x  and  mouse_y > item_c_half then
activate_drag = true 
else
activate_drag = false
end 





end 








--]]
if item_c then


prev_item_end, next_item_start = get_next_get_previous_item(item_c ,mouse_tr)
	
	
if l_edge_end < mouse_x and  r_edge_start < mouse_x  and  mouse_y < item_c_half then
dragzone = true 
else
dragzone = false
end 




if  next_item_start-it_y > 12 and it_x-prev_item_end > 12  then




if  mouse_x > it_x  and mouse_x  < it_y  and  mouse_y < item_c_half then------------------------------------
activate_drag = false
else
activate_drag = true
end 	


elseif next_item_start-it_y > 12 and it_x-prev_item_end < 12  then ---------------------------------------


if  mouse_x > l_edge_start  and mouse_x  < it_y  and  mouse_y < item_c_half then
activate_drag = false
else
activate_drag = true
end 	


elseif  next_item_start-it_y < 12 and it_x-prev_item_end > 12  then-------------------------------------------

if  mouse_x > it_x  and mouse_x  < r_edge_end  and  mouse_y < item_c_half then
activate_drag = false
else
activate_drag = true
end 	



else---------------------------------------------------------------




if  mouse_x > l_edge_start and mouse_x  < r_edge_end   and  mouse_y < item_c_half then
activate_drag = false
else
activate_drag = true
end 	

end ----------------------------------------------------------------






	if  mouse_x > l_edge_start and mouse_x  < it_x+1 and it_x-prev_item_end > 12  or  mouse_x > it_y-1 and mouse_x < r_edge_end and next_item_start-it_y > 12 then
out_edge = true
else
out_edge = false
end 	
	

	
	if  (mouse_x >  it_x and mouse_x  < l_edge_end  or  mouse_x > r_edge_start and mouse_x < it_y) and  mouse_y > item_c_half  then
bot_out_edge = true
else
bot_out_edge = false
end 		
	


return is_over_edge, item_y, item_h, dragzone, activate_drag, item_c, out_edge, bot_out_edge  



end
end
end



end

--------------------------------------------------------------------------------EMBASS FUNCTION








-- track panels and envelope panels parent window



function get_track_from_y(y) --> Track, segment
  local arrange_window = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)
if arrange_window == nil then  return end 
local _, _, arr_top = reaper.JS_Window_GetRect(arrange_window)
local window = reaper.JS_Window_GetRelated(arrange_window, "NEXT")
while window do
    local _, _, top = reaper.JS_Window_GetRect(window)
    if top == arr_top then trackview_window  = reaper.JS_Window_GetRelated(window, "CHILD") end
    window = reaper.JS_Window_GetRelated(window, "NEXT")
  end
    -- loop over track and envelope windows 
  local window = reaper.JS_Window_GetRelated(trackview_window, "CHILD")
  while window do
    if reaper.JS_Window_IsVisible(window) then
      -- windows visible in arrange view only
      local _, _, top, _, bottom = reaper.JS_Window_GetRect(window)
      if top <= y and bottom > y then
        local pointer = reaper.JS_Window_GetLongPtr(window, "USERDATA")
        if reaper.ValidatePtr(pointer, "MediaTrack*") then
        return pointer, top --> Track, segment
        
        end
      end
    end
    window = reaper.JS_Window_GetRelated(window, "NEXT") --> window or nil
   end
 end








----------------------------------------ENVELOPE-----FUNCTIONS----
local function act_deact_env(act)
  if menvelope then
  
  local br_env_m = reaper.BR_EnvAlloc( menvelope, 0 )
      local active_m, visible_m, armed_m, inLane_m, laneHeight_m, defaultShape_m, _, _, _, _, faderScaling_m = reaper.BR_EnvGetProperties( br_env_m)
       reaper.BR_EnvSetProperties( br_env_m, 
                                        act, 
                                        visible_m, 
                                        armed_m, 
                                        inLane_m, 
                                        laneHeight_m, 
                                        defaultShape_m, 
                                        faderScaling_m ) 
    reaper.BR_EnvFree( br_env_m , true ) 
end
end

local function envelope_control()
local num_tracks = reaper.CountTracks(0)
    if num_tracks == 0 then return end
 
for i = 0, num_tracks - 1 do
	local tr = reaper.GetTrack(0, i)
local count_env = reaper.CountTrackEnvelopes(tr)
 
 for e = 0, count_env -1 do 

 menvelope = reaper.GetTrackEnvelope(tr,e )
  
  if menvelope then
  if reaper.CountEnvelopePoints( menvelope) > 1 then 
  act_deact_env(true)
else
  act_deact_env(false)
end
end
		

end		
end
end

----------------------------------------------------------------------------------------------------------------------------------------

local function XRClean(track)
function Action(delenv)
  retval, xml_env = reaper.GetEnvelopeStateChunk(env, "", false)
  xml_env = xml_env:gsub("\n", "¤¤")
  retval, xml_env = reaper.SetEnvelopeStateChunk(env, xml_env, false)
return xml_env
end
env_count = reaper.CountTrackEnvelopes(track)
for j = 0, env_count-1 do

          -- GET THE ENVELOPE
env = reaper.GetTrackEnvelope(track, j)
      
if env ~= nil then
br_env_del = reaper.BR_EnvAlloc(env, false)
      
active, visible, _, _, _, _, _, _, _, type, faderScaling = reaper.BR_EnvGetProperties(br_env_del, true, true, true, true, 0, 0, 0, 0, 0, 0, true)

 if visible == false and active == false then
          retval, xml_track = reaper.GetTrackStateChunk(track, "", false)
          xml_track = xml_track:gsub("\n", "¤¤")
          xml_env =  Action(delenv)
end
reaper.BR_EnvFree(br_env_del, 0)
end 
end
end 



local function add_env_to_track(track, fxnumber, paramnumber, name, sendidx, valueIn)
 reaper.PreventUIRefresh(1)
reaper.SetOnlyTrackSelected(track) 		
reaper.Main_OnCommand(40914, 0) -----set as last touched
if track == nil then track = reaper.GetLastTouchedTrack() end
       if name=='FX' then
    env = reaper.GetFXEnvelope( track, fxnumber, paramnumber, 1)
    elseif name=='Volume' then  
    env = reaper.GetTrackEnvelopeByName(track,name)
    if env==nil then 
			
			reaper.Main_OnCommand(40052, 0) 
			
			env = reaper.GetTrackEnvelopeByName(track,name) end
			
   if reaper.CountEnvelopePoints(env) < 1 then  reaper.Main_OnCommand(40052, 0)  end
     retval, xml = reaper.GetEnvelopeStateChunk(env, "", false )
   
   if string.match(xml, "VOLTYPE") then  
  ------------------------------------------------------------DELETE---VOLUME
  
  brvol = reaper.BR_EnvAlloc( env, 0 )
   reaper.BR_EnvSetProperties( brvol, 
                                        0, 
                                        0, 
                                        0, 
                                        0, 
                                        0, 
                                        0, 
                                        0) 
    reaper.BR_EnvFree( brvol, true ) 
  XRClean(track)
  reaper.Main_OnCommand(40052, 0)
  
  
  
  
  end 


   
    elseif  name=='Pan' then
        env = reaper.GetTrackEnvelopeByName(track,name)
        if env==nil then 
			reaper.Main_OnCommand(40053, 0)
			env = reaper.GetTrackEnvelopeByName(track,name) end
        if reaper.CountEnvelopePoints(env) < 1 then  reaper.Main_OnCommand(40053, 0)   end
        
    elseif name=='Send' then
    function get_send_envelope()
	local brgetenv = reaper.BR_GetMediaTrackSendInfo_Envelope( track, 0, sendidx, 0 )
    for i = 0, reaper.CountTrackEnvelopes(track) - 1 do
        local get_env_send = reaper.GetTrackEnvelope( track, i )
    retval, buf = reaper.GetEnvelopeName( get_env_send, 0 )
    if brgetenv==get_env_send then  env = get_env_send  break 
    end
    end
    return env
    end
    
    
    function show_send_envelope()
   chunk=
    [[
    <AUXVOLENV
    ACT 0 -1
    VIS 1 0 1
    LANEHEIGHT 0 0
    ARM 1
    DEFSHAPE 0 -1 -1
    VOLTYPE 1
    PT 0 1 0
    >
    ]]
    reaper.SetEnvelopeStateChunk( reaper.BR_GetMediaTrackSendInfo_Envelope( track, 0, sendidx, 0 ),chunk, true )
    
    function MyDawRedrawHack()
    reaper.PreventUIRefresh(1)
    reaper.Main_OnCommand(40406, 0)
    reaper.Main_OnCommand(40052, 0) --40406
    reaper.PreventUIRefresh(-1)
    end
    MyDawRedrawHack()
    
    end
    
    
    
    env = get_send_envelope()
    if  env==nil then show_send_envelope() env = get_send_envelope()  end
     brenv = reaper.BR_GetMediaTrackSendInfo_Envelope( track, 0, sendidx, 0 )
     if brenv ~= env then show_send_envelope() env = get_send_envelope()  end 
     if reaper.CountEnvelopePoints(env)< 1 then show_send_envelope() env = get_send_envelope() end
     
    local  brsendenv = reaper.BR_EnvAlloc( env, 0 )
 local active_pre, visible_pre, armed_pre, inLane_pre, laneHeight_pre, defaultShape_pre, _, _, _, _, faderScaling_pre = reaper.BR_EnvGetProperties( brsendenv  )
   reaper.BR_EnvSetProperties( brsendenv, 
                                     active_pre, 
                                     1, 
                                     armed_pre, 
                                     inLane_pre, 
                                     laneHeight_pre, 
                                     defaultShape_pre, 
                                     faderScaling_pre ) 
 reaper.BR_EnvFree( brsendenv, true ) 

valueIn = math.floor(valueIn*1000/2)     
     
            
      
     
    
    end
   



        if  env then
      
      
      
      
      
      local br_env_show = reaper.BR_EnvAlloc( env, 0 )
      local active_cur, visible_cur, armed_cur, inLane_cur, laneHeight_cur, defaultShape_cur, _, _, _, _, faderScaling_cur = reaper.BR_EnvGetProperties( br_env_show)
       reaper.BR_EnvSetProperties( br_env_show, 
                                        active_cur, 
                                        1, 
                                        armed_cur, 
                                        inLane_cur, 
                                        laneHeight_cur, 
                                        defaultShape_cur, 
                                        faderScaling_cur ) 
    reaper.BR_EnvFree( br_env_show , true ) 
  
      
  
  
  if reaper.CountEnvelopePoints(env) == 1 then
for ip=0, reaper.CountEnvelopePoints(env)-1 do
    
   reaper.SetEnvelopePoint( env, ip, -1, valueIn, -1, -1, -1, -1 )
reaper.Envelope_SortPoints(env)  
reaper.UpdateArrange()
  
end
   end
      
---------------------------------------------------------------HIDE_PREV_ENVELOPE--------------------------   --[[
      
       for i = 0, reaper.CountTrackEnvelopes(track) - 1 do
       local get_env_pre = reaper.GetTrackEnvelope( track, i )
       if get_env_pre then
     local get_br_env_pre = reaper.BR_EnvAlloc( get_env_pre, 0 )
       local active_pre, visible_pre, armed_pre, inLane_pre, laneHeight_pre, defaultShape_pre, _, _, _, _, faderScaling_pre = reaper.BR_EnvGetProperties( get_br_env_pre )
     
     


       if (get_env_pre ~= env) and inLane_pre==false  then 
       
       
       
       countpoints = reaper.CountEnvelopePoints(get_env_pre)
       if countpoints > 1  then
      reaper.BR_EnvSetProperties( get_br_env_pre, 
                                        active_pre, 
                                        0, 
                                        armed_pre, 
                                        inLane_pre, 
                                        laneHeight_pre, 
                                        defaultShape_pre, 
                                        faderScaling_pre ) 
    reaper.BR_EnvFree( get_br_env_pre, true ) 
     else
     
      reaper.BR_EnvSetProperties( get_br_env_pre, 
                                         0, 
                                         0, 
                                         0, 
                                         0, 
                                         0, 
                                         0, 
                                         0 ) 
     reaper.BR_EnvFree( get_br_env_pre, true ) 
  ---------------------------------------------------------------DELETE_HIDED_ENVELOPES----------------     
      
      
       XRClean(track)
     
     end
     
    
     end       
     end 
  end   
------End Hide
     


end
 
 for i = 0, reaper.CountTrackEnvelopes(track) - 1 do
          local bp_env = reaper.GetTrackEnvelope( track, i )
          local bp_br_env = reaper.BR_EnvAlloc( bp_env, 0 )
   local active_pre, visible_pre, armed_pre, inLane_pre, laneHeight_pre, defaultShape_pre, _, _, _, _, faderScaling_pre = reaper.BR_EnvGetProperties( bp_br_env )
   countpoints = reaper.CountEnvelopePoints(bp_env) 
   if (visible_pre==true) and countpoints <= 1  then
   
   reaper.BR_EnvSetProperties( bp_br_env, 
                                           0, 
                                           visible_pre, 
                                           armed_pre, 
                                           inLane_pre, 
                                           laneHeight_pre, 
                                           defaultShape_pre, 
                                           faderScaling_pre ) 
                                           
    reaper.BR_EnvFree( bp_br_env, true ) 
    
    end
    
    end

 
  
 
 reaper.PreventUIRefresh(-1)
 
end  ---------------------------End Function

----------------------------------------SMART---GRID-----FUNCTION


local function GetMidiZoom()
    
    function esc(str) str = str:gsub('%-', '%%-') return str end
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    local guid = reaper.BR_GetMediaItemTakeGUID(take)
    local item = reaper.GetMediaItemTake_Item(take)
    local tr = reaper.GetMediaItem_Track(item)
    
    if not tr then return end
      -- Try standart function -----
    local ret, track_chunk = reaper.GetTrackStateChunk(tr, "", false) -- isundo = false
    if not ret and not track_chunk and  #track_chunk > 4194303 then  
      -- If chunk_size >= max_size, use wdl fast string --
    local fast_str = reaper.SNM_CreateFastString("")
    if reaper.SNM_GetSetObjectState(tr, fast_str, false, false) then
        track_chunk = reaper.SNM_GetFastString(fast_str)
    end
    reaper.SNM_DeleteFastString(fast_str)
    end  
    local view = track_chunk:match(esc(guid)..'.-CFGEDITVIEW(.-)\n')
    
    function mysplit(inputstr, sep)
      if sep == nil then
        sep = "%s"
      end
      local t={} ; i=1
      for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
      end
      return t
    end
    
    for is = 1, 2, 1 do   
          if is == 2 then
            result = mysplit(view, "%s")
            out  = result[is]
          end
          end
return out
    
   end


local function GetMidiGrid()
local ME = reaper.MIDIEditor_GetActive()
  if not ME then return end
  local take = reaper.MIDIEditor_GetTake(ME)
local  snap_enabled = reaper.MIDIEditor_GetSetting_int(ME, "snap_enabled")
local _, arrange_division, _, _ = reaper.GetSetProjectGrid(0, 0)
local SyncArrangeMidi = 41022
local SyncArrangeMidi_State = reaper.GetToggleCommandStateEx(32060,SyncArrangeMidi)
if (SyncArrangeMidi_State == 0) then reaper.MIDIEditor_OnCommand(ME, SyncArrangeMidi) end
local _, midi_division, _, _ = reaper.GetSetProjectGrid(0, 0)
reaper.MIDIEditor_OnCommand(ME, SyncArrangeMidi)
reaper.SetProjectGrid(0, arrange_division)
return midi_division
end

local function SetMidiGrid()

default_index = 1

Straight = { 
              {name = "gridvis1_1024",
                beginning = 2000000,
                ending = 9170,
                divider=1024, 
               },
              {name = "gridvis1_512",
                beginning = 9170,
                ending = 8371,
                divider=512,  
               },               
              {name = "gridvis1_256",
                beginning = 8371,
                ending = 2306,
                divider=256,  
               },
              {name = "gridvis1_128",
                beginning = 2306,
                ending = 1042,
                divider=128,  
               },
              {name = "gridvis1_64",
                beginning = 1042,
                ending = 529,
                divider=64,  
               },
              {name = "gridvis1_32",
                beginning = 529 ,
                ending = 268,
                divider=32,  
               },
              {name = "gridvis1_16",
                beginning = 218,
                ending = 136,
                divider=16,  
               },
              {name = "gridvis1_8",
                beginning = 136,
                ending = 64,
                divider=8,  
               },
              {name = "gridvis1_4",
                beginning = 64,
                ending = 32,
                divider=4,  
               },
              {name = "gridvis1_2",
                beginning = 32,
                ending = 16,
                divider=2,  
               },
               
              {name = "gridvis1_1",
                beginning = 16,
                ending = 8,
                divider=1,  
               },
              {name = "gridvis2_1",
                beginning = 8,
                ending = 4,
                divider=0.5,  
               },
              {name = "gridvis4_1",
                beginning = 4,
                ending = 2,
                divider=0.25,  
               },
              {name = "gridvis8_1",
                beginning = 2,
                ending = 0,
                divider=0.125,  
               },
}

local zoom =  tonumber(GetMidiZoom())

if zoom > 1 then

tk = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())

_,_,_,_,_, msg_event = reaper.MIDI_GetTextSysexEvt( tk, 0, 0, 0, 0, 1, 0 )


if string.match(msg_event, "MGrid") then


extracted = string.match(msg_event, "=(.*)")

reaper.SetExtState( "item", "temp", extracted, 0 )

default_index  = reaper.GetExtState( "item", "temp" )

reaper.DeleteExtState("item", "temp", 0 )

default_index = tonumber(default_index)

if default_index == nil then default_index = 1  end  

end




    for i = #Straight, 1, -1 do

local name = Straight[i].name
local beginning = Straight[i].beginning
local ending = Straight[i].ending
local divider = Straight[i].divider


if (zoom < beginning) and (zoom > ending) then curdivider = divider   end
 end
if curdivider then 
reaper.SetMIDIEditorGrid( 0, (default_index/curdivider) )
end
end
return -- default_index/curdivider
end


local function writegrid()
  
  Straight = { 
              {name = "gridvis1_1024",
                beginning = 2000000,
                ending = 9170,
                divider=1024, 
               },
              {name = "gridvis1_512",
                beginning = 9170,
                ending = 8371,
                divider=512,  
               },               
              {name = "gridvis1_256",
                beginning = 8371,
                ending = 2306,
                divider=256,  
               },
              {name = "gridvis1_128",
                beginning = 2306,
                ending = 1042,
                divider=128,  
               },
              {name = "gridvis1_64",
                beginning = 1042,
                ending = 529,
                divider=64,  
               },
              {name = "gridvis1_32",
                beginning = 529 ,
                ending = 268,
                divider=32,  
               },
              {name = "gridvis1_16",
                beginning = 218,
                ending = 136,
                divider=16,  
               },
              {name = "gridvis1_8",
                beginning = 136,
                ending = 64,
                divider=8,  
               },
              {name = "gridvis1_4",
                beginning = 64,
                ending = 32,
                divider=4,  
               },
              {name = "gridvis1_2",
                beginning = 32,
                ending = 16,
                divider=2,  
               },
               
              {name = "gridvis1_1",
                beginning = 16,
                ending = 8,
                divider=1,  
               },
              {name = "gridvis2_1",
                beginning = 8,
                ending = 4,
                divider=0.5,  
               },
              {name = "gridvis4_1",
                beginning = 4,
                ending = 2,
                divider=0.25,  
               },
              {name = "gridvis8_1",
                beginning = 2,
                ending = 0,
                divider=0.125,  
               },
}


local zoom =  tonumber(GetMidiZoom())

if zoom > 1 then

 for i = #Straight, 1, -1 do

local name = Straight[i].name
local beginning = Straight[i].beginning
local ending = Straight[i].ending
local divider = Straight[i].divider


if (zoom < beginning) and (zoom > ending) then  curdivider = divider   end
 end




gridset= GetMidiGrid()*curdivider


if sgrid ~= gridset then


tk = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
insert=tostring("MGrid="..gridset) 
_,_,_,_,_, msg_event = reaper.MIDI_GetTextSysexEvt( tk, 0, 0, 0, 0, 1, 0 )
if string.match(msg_event, "MGrid") then
reaper.MIDI_DeleteTextSysexEvt( tk, 0 )
end
reaper.MIDI_InsertTextSysexEvt( tk, true, 0, 0, 1, insert )
end
end
end


----------------------------------------END---SMART---GRID-----FUNCTION


----WINDOW----FUCTION


local function intercept(action, gwin, message)

  if action == 0 then
    
    if reaper.JS_WindowMessage_Intercept(gwin, message, false)==0 then
    reaper.JS_WindowMessage_PassThrough(gwin, message, false)
    else
    reaper.JS_WindowMessage_Intercept(gwin, message, false)
    end
  
    reaper.JS_WindowMessage_PassThrough(gwin, message, false)
  elseif action == 1 then
  reaper.JS_WindowMessage_PassThrough(gwin, message, true)
  
  end



end


local function get_if_transport(hwnd)
local status = reaper.JS_Window_FindChildByID(hwnd, 1010)
if status then
local parent = reaper.JS_Window_GetParent(hwnd)
if parent then
local retval, list = reaper.JS_Window_ListAllChild(parent)
if status and retval == 3  then return true 
end
end
else return false
end
end



local function get_transport_buttons(x,y,hwnd)
if get_if_transport(hwnd) == true then 
local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(hwnd)
local r_button_width = 28
local r_button_height = 25
local width = right-left 
local height=bottom-top
local left_edge = (left+(width/2)+4)
local top_edge = top+8
local right_edge = (left_edge+r_button_width)
local bottom_edge = (top_edge+r_button_height)
local play_factor = 3 
if width < 266 then play_factor = 2  end
if  (x > left_edge) and (x < right_edge) and (y > top_edge) and (y < bottom_edge) then
return  "rec", left_edge
elseif (x > (left_edge-(r_button_width+1))) and (x < (right_edge-(r_button_width+1))) and (y > top_edge) and (y < bottom_edge) then
return  "stop" 
elseif (x > (left_edge-(r_button_width+1)*play_factor)) and (x < (right_edge-(r_button_width)*play_factor)-2) and (y > top_edge) and (y < bottom_edge) then
return  "play" 
end
end
end



local function get_win_id(hwnd)
if hwnd then
local id =  reaper.JS_Window_GetLongPtr( hwnd, "ID" )
if id then
local address  = reaper.JS_Window_AddressFromHandle(id)
return address
end
end
end


local function get_parents(hwnd)
if hwnd then
parent = reaper.JS_Window_GetParent(hwnd)
if parent then
parentofparent = reaper.JS_Window_GetParent(parent)
if parentofparent then return parent, parentofparent 
else return parent, nil end
end
end
end


local function get_if_tcp(hwnd)
if not hwnd then return end
local pointer = reaper.JS_Window_GetLongPtr(hwnd, "USERDATA")
        if reaper.ValidatePtr(pointer, "MediaTrack*") then
local iftrack = reaper.JS_Window_FindChildByID(hwnd, 1088)
thisistrack=0
 if reaper.CountTracks(0) > 0 then
 for i = 0, reaper.CountTracks(0)-1 do
	local tr = reaper.GetTrack( 0, i )
	if reaper.JS_Window_GetLongPtr(hwnd, "USER") == tr then thisistrack=1 break
end
end
end

local par, parpar = get_parents(hwnd)
local dummy, MainHwnd = get_parents(par)

if iftrack and thisistrack==1 and (MainHwnd == reaper.GetMainHwnd()) then  hwndtrack = reaper.JS_Window_GetLongPtr( hwnd, "USERDATA") return true, hwndtrack 

else return false, nil
end
end
end

----WINDOW----FUCTION--- end


local function save_track_states()

    local num_tracks = reaper.CountTracks(0)
    if num_tracks == 0 then return end
 
track_states = {}
    for i = 0, num_tracks - 1 do

        local tr = reaper.GetTrack(0, i)
        local idx = math.floor(reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER"))
        local trGUID = reaper.GetTrackGUID(tr)
        local tsolo=reaper.GetMediaTrackInfo_Value(tr, "I_SOLO" )
        local trecarm=reaper.GetMediaTrackInfo_Value(tr, "I_RECARM" )
        local retval, tlay = reaper.GetSetMediaTrackInfo_String( tr, "P_TCP_LAYOUT", 0, 0 ) 
        
         track_states[i] = {tr = tr, idx = idx, trGUID = trGUID, tsolo=tsolo, trecarm=trecarm, tlay=tlay  }
end
end



local function restore_track_states(track)

    for i = #track_states, 0, -1 do

        local trGUID = track_states[#track_states - i].trGUID
idx = track_states[#track_states - i].idx
tsolo = track_states[#track_states - i].tsolo
trecarm = track_states[#track_states - i].trecarm
tlay = track_states[#track_states - i].tlay

if track then
local currient_guid= reaper.GetTrackGUID(track)       
if trGUID== tostring(currient_guid) then
break       
end
end
end
return idx, tsolo, trecarm, tlay
end


   

local function play_from()



local startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) 

local Scroll_State = reaper.GetToggleCommandState(40036)




function NoScroll()
 
  reaper.PreventUIRefresh(1)
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)
  reaper.Main_OnCommand(41173, 0)
  reaper.Main_OnCommand(1007, 0)
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0)  
  reaper.PreventUIRefresh(-1)
end


  
local function Scroll()  

 reaper.PreventUIRefresh(1)
  reaper.Main_OnCommand(41173, 0)
  reaper.Main_OnCommand(1007, 0)
  reaper.PreventUIRefresh(-1)

end



if endOut  == 0 then


 if Scroll_State == 0 then        
    NoScroll()  
  else                            
     Scroll() 
  end


 else
  reaper.Main_OnCommand(40630, 0)-----Cursos to TS
  reaper.Main_OnCommand(1007, 0)-----Play


end
end



local function smart_rec()
function lanesoff()

function nothing() end
function exit() reaper.defer(nothing) end

Lanes_State = reaper.GetToggleCommandState(41329)

if Lanes_State == 0 then

reaper.Main_OnCommand(41329, 0) ---SEPARETE LANES OFF BUG

else exit() end 

end


lanesoff()



function guideson()


name1 = 'Guide'
name2 = 'guide'
name3 = 'GUIDE'
name4 = 'Reference'
name5 = 'reference'
name6 = 'REFERENCE'
name7 = 'Ref'
name8 = 'ref'
name9 = 'REF'

local function nothing() end; local function noaction() reaper.defer(nothing) end

local tracks = reaper.CountTracks()

if not tracks == 0 then noaction() return end


for i = 0, tracks-1 do
  local tr = reaper.GetTrack(0, i)
  local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
  local param = 'B_MUTE'
  local param1 = 'I_SOLO'  
  if tr_name  == name1 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name2 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name3 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name4 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name5 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name6 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name7 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name8 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
  elseif tr_name  == name9 then  reaper.SetMediaTrackInfo_Value( tr, param, 0 )
 end

for i = 0, tracks-1 do
  local tr = reaper.GetTrack(0, i)
local param1 = 'I_SOLO'
reaper.SetMediaTrackInfo_Value( tr, param1, 0 )
reaper.TrackList_AdjustWindows( false )
end

end

end


reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(41745, 0) --Metronome on

guideson()





reaper.Main_OnCommand(1013, 0) ---Record


record = 1
reaper.SetExtState('SmartRecord', 'Recording', record, 0)


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Recording', -1)  
end	


local function smart_stop()


function lanesoff()

function nothing() end
function exit() reaper.defer(nothing) end

Lanes_State = reaper.GetToggleCommandState(41329)

if Lanes_State == 1 then

reaper.Main_OnCommand(41330, 0) ---SEPARETE LANES OFF BUG

else exit() end 

end





function mutepreviousitems() 


local function nothing() end; local function noaction() reaper.defer(nothing) end
local tracks = reaper.CountTracks()
if not tracks == 0 then noaction() return end
for i = 0, tracks-1 do
  local tr = reaper.GetTrack(0, i)
  local tr_recarm = reaper.GetMediaTrackInfo_Value(tr, 'I_RECARM')
    if tr_recarm  == 1 then  
 for i = 0, reaper.GetTrackNumMediaItems(tr)-1 do
             local item = reaper.GetTrackMediaItem(tr, i) 
             
             isselected = reaper.GetMediaItemInfo_Value(item, "B_UISEL")
             
             
             if isselected == 1 then
             local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
             local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
             reaper.GetSet_LoopTimeRange2(0, true, 0, itemStart, itemEnd, 0)
                 
             end


 for i = 0, reaper.GetTrackNumMediaItems(tr)-1 do
             
            
             local item = reaper.GetTrackMediaItem(tr, i) 
             
             isselected = reaper.GetMediaItemInfo_Value(item, "B_UISEL")
             
             
             if isselected == 0 then
             
             
             
            start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false) -- Get start and end time selection value in seconds
             
            if start_time ~= end_time then -- if there is a time selection
                
               
                    item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                    item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
             
                    item_end = item_pos + item_len -- Calculate the item end position
             
                    if (item_pos >= start_time and item_pos <= end_time) or (item_end >= start_time and item_end <= end_time) or (item_pos <= start_time and item_end >= end_time) then -- check if item is in time selection
                            
                        reaper.SetMediaItemInfo_Value(item, "B_MUTE", 1) -- Set new value
                            
                    end -- end if item is in time selection
                    
                end
         
            
 reaper.TrackList_AdjustWindows(0)            
 reaper.UpdateArrange()            
             
                   
                 
end  
             
             
end           

                      
 
end

end


 
 
end   --------------end 

reaper.Main_OnCommand(40635, 0) ---------remove Time selection      


 
end   --------------end 


Record_State = reaper.GetExtState('SmartRecord', 'Recording') 

function NoUndoPoint() end 

function guidesoff()

name1 = 'Guide'
name2 = 'guide'
name3 = 'GUIDE'
name4 = 'Reference'
name5 = 'reference'
name6 = 'REFERENCE'
name7 = 'Ref'
name8 = 'ref'
name9 = 'REF'


local function nothing() end; local function noaction() reaper.defer(nothing) end

local tracks = reaper.CountTracks()

if not tracks == 0 then noaction() return end


for i = 0, tracks-1 do
  local tr = reaper.GetTrack(0, i)
  local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
  local param = 'B_MUTE'
  local param1 = 'I_SOLO'  
  if tr_name  == name1 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name2 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name3 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name4 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name5 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name6 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name7 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name8 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name9 then  reaper.SetMediaTrackInfo_Value( tr, param, 1  )
 end


end

end






RegularRecord = reaper.GetToggleCommandState(1013)


if Record_State == '1'or RegularRecord == 1 then 


if (reaper.GetToggleCommandState(1007)==1)  then  reaper.Main_OnCommand(1016 , 0) else reaper.Main_OnCommand(40042 , 0) end


guidesoff() 
reaper.Main_OnCommand(41746, 0) --Disable metronome
mutepreviousitems()
local recordz = 0
reaper.DeleteExtState('SmartRecord', 'Recording', 0)
reaper.SetExtState('SmartRecord', 'Recording', recordz, 0)

else

if (reaper.GetToggleCommandState(1007)==1) then  reaper.Main_OnCommand(1016 , 0) else reaper.Main_OnCommand(40042 , 0) end

end 


reaper.defer(NoUndoPoint)


lanesoff()

end-----function end
	

local function folderstates(track, state, ctrl)
 if track then
	
if ctrl == 0 then 

 if state == 1 or state == 0   then
	reaper.SetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT", 2 ) 
else
  reaper.SetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT", 0 )
  end ------if end

else
  reaper.SetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT", 1 ) 
  
end
end
end------function folderstates end

local function solo_rec_exlusive(under_track, on_off, is_ctrl,solo_rec )
  
  if on_off > 0 then  tswitch = 0 else tswitch = 2 end
 
  
reaper.SetMediaTrackInfo_Value(under_track, solo_rec, tswitch)

local issel =  reaper.GetMediaTrackInfo_Value( under_track, "I_SELECTED")-------------------------

  if is_ctrl == 0 then
  
  local counttracks = reaper.CountTracks(0)
    
  for i = 1, counttracks do
    local track = reaper.GetTrack(0,i-1)
      if track and track ~= under_track then
       
     local if_other_solo =  reaper.GetMediaTrackInfo_Value( track, solo_rec )
     

	if  issel > 0 then
	
	local   if_other_sel =  reaper.GetMediaTrackInfo_Value( track, "I_SELECTED") 

	if if_other_sel > 0 then reaper.SetMediaTrackInfo_Value(track, solo_rec, tswitch)  
else 	
	   if if_other_solo > 0 then
     reaper.SetMediaTrackInfo_Value(track, solo_rec, 0)  
   end
	
	end  
	
	else

	
     if if_other_solo > 0 then
     reaper.SetMediaTrackInfo_Value(track, solo_rec, 0)  
   end
   
 end  
   
   end-----------------if end
   end-------------for end

end

end-----------------function soloexlusive end


function tcp_buttons(track, x, y)


if track  then

local track_window = reaper.JS_Window_FromPoint( x, y )
local istrack,_ = get_if_tcp(track_window)
if istrack == true then
local volmeter = reaper.JS_Window_FindChildByID(track_window, 1088)
local retval, left, top, right, bottom = reaper.JS_Window_GetClientRect( track_window )
local _, volleft, _, _, _ = reaper.JS_Window_GetClientRect(volmeter)
local tr_height =  bottom - top 
------------------Solo Block----------------------------------------------------------------------------
---Solo button coordinates and size
 ----indent from the left edge of the track meter!!!!(we count from the right corner, because the button is glued to the right edge)
local button_width = 21
local top_button_edge_crdnts = 4
local button_height = 17
----------------------------------------------------
local right_border = volleft-4
local left_border = (right_border-button_width)
local top_border = top + top_button_edge_crdnts 
local bottom_border =  top_border + button_height 
if (tr_height>=26) and (x > left_border) and (x < right_border) and (y > top_border) and (y < bottom_border) and track ~= reaper.GetMasterTrack(0) then



return "solo"



end

------------------Solo Block End---------------------------------------------------------------------------

-------------------Folder Block----------------------------------------

---Folder button coordinates and size---------------------
local f_left_button_edge_crdnts = 4+(reaper.GetTrackDepth(track)*folder_indent)  ----indent from the left edge of the track!!!!
local f_button_width = 21
local f_top_button_edge_crdnts = 4
local f_button_height = 17
----------------------------------------------------
local f_left_border = left+f_left_button_edge_crdnts
local f_right_border = f_left_border + f_button_width
local f_top_border = top + f_top_button_edge_crdnts 
local f_bottom_border =  f_top_border + f_button_height 


if (tr_height>=26) and (x > f_left_border) and (x < f_right_border) and (y > f_top_border) and (y < f_bottom_border) 
and  reaper.GetMediaTrackInfo_Value( track, "I_FOLDERDEPTH" ) > 0 and track ~= reaper.GetMasterTrack(0) then


return  "folder"

end


------------------Recarm Block----------------------------------------------------------------------------
---Solo button coordinates and size
 ----indent from the right edge of the track!!!!(we count from the right corner, because the button is glued to the right edge)local button_width = 20
local top_button_edge_crdnts = 25
local button_height = 17
----------------------------------------------------

local right_border = volleft-4
local left_border = right_border-f_button_width
local top_border = top + top_button_edge_crdnts 
local bottom_border =  top_border + button_height 
if (tr_height>68) and (x > left_border) and (x < right_border) and (y > top_border) and (y < bottom_border) and track ~= reaper.GetMasterTrack(0) then

local _, lay = reaper.GetSetMediaTrackInfo_String( track, "P_TCP_LAYOUT" , 0, 0 )

if lay=="" and lay ~="Return" then

return "recarm"

end

end

------------------Recarm Block End---------------------------------------------------------------------------
----------------------------------------------------VolumeBlock

---[[
------------------Volume Block----------------------------------------------------------------------------
---Volume  button coordinates and size

track_width = (right - left)-(reaper.GetTrackDepth(track)*folder_indent) 
track_height = (bottom - top) 


if track_width >368 and track_height < 44 then
v_left_button_edge_crdnts  = 166
v_top_button_edge_crdnts = 4
elseif track_width <= 368 and track_height < 44 then
v_left_button_edge_crdnts = 105
v_top_button_edge_crdnts = 4
elseif track_width <= 368 and track_height >= 44 then
v_left_button_edge_crdnts = 44
v_top_button_edge_crdnts = 25
elseif track_width > 368 and track_height >= 44 then
v_left_button_edge_crdnts = 44
v_top_button_edge_crdnts = 25
end

local v_button_width = 57
local v_button_height = 17
----------------------------------------------------
v_left_button_edge_crdnts=v_left_button_edge_crdnts+(reaper.GetTrackDepth(track)*folder_indent)

local v_left_border = left+v_left_button_edge_crdnts
local v_right_border = v_left_border + v_button_width 
local v_top_border = top + v_top_button_edge_crdnts 
local v_bottom_border =  v_top_border + v_button_height 


if (tr_height>=26) and (x > v_left_border) and (x < v_right_border) and (y > v_top_border) and (y < v_bottom_border)  then




return "volume"

  

end

-----------------------------------------IO-BUTTON---------------
if track_width > 305 then

if track_width > 305 and track_height >= 44 then
io_left_button_edge_crdnts  = 147
io_top_button_edge_crdnts = 25
elseif track_width > 305 and track_height < 44 then
io_left_button_edge_crdnts = 147
io_top_button_edge_crdnts = 4
end

local io_button_width = 59
local io_button_height = 17
----------------------------------------------------



local io_left_border = right-io_left_button_edge_crdnts
local io_right_border = io_left_border + io_button_width 
local io_top_border = top + io_top_button_edge_crdnts 
local io_bottom_border =  io_top_border + io_button_height 


if (x > io_left_border) and (x < io_right_border) and (y > io_top_border) and (y < io_bottom_border)  then




return "io"

  
end
end


end




end


end 
----- END TCP _FUNCTION







----------------------------------------FUNCTIONS-----END----------------------------------------------------------

folder_indent=8
diff=0
diffvert=0
ifzoom=1
dgzclick=1
miditsremove=0
lock_ts=1
volset=1 

function main()
xpcall( function()
--------------------------------------------------------------START--OF--CONSTANT---REALTIME-----PROCESS







  
mouse_state = reaper.JS_Mouse_GetState(255)


---[[ Disable



 ---------------------------------------------------DRAG-ZOOM -------MUTE



 
 
 
local x,y = reaper.GetMousePosition()



local frompoint = reaper.JS_Window_FromPoint(x,y)

if frompoint then

local rettrack, track = get_if_tcp(frompoint)


if rettrack==true then 
  
  if tcp_buttons(track, x, y) == "solo" or tcp_buttons(track, x, y) == "recarm" or tcp_buttons(track, x, y) == "folder"  then 
 tsolo=reaper.GetMediaTrackInfo_Value(track, "I_SOLO" )
 recarm=reaper.GetMediaTrackInfo_Value(track, "I_RECARM" )
  intercept(0, frompoint,"WM_LBUTTONDOWN")
  intercept(0, frompoint,"WM_LBUTTONDBLCLK")
   else  
  intercept(1, frompoint,"WM_LBUTTONDOWN")
  intercept(1, frompoint, "WM_LBUTTONDBLCLK")

  end

end


if get_if_transport(frompoint)==true then
		
if get_transport_buttons(x,y,frompoint) =="rec" or get_transport_buttons(x,y,frompoint) =="stop" or get_transport_buttons(x,y,frompoint) =="play" then
  intercept(0, frompoint,"WM_LBUTTONDOWN")
  intercept(0, frompoint,"WM_LBUTTONDBLCLK")
  
  else  
  intercept(1, frompoint,"WM_LBUTTONDOWN")
  intercept(1, frompoint, "WM_LBUTTONDBLCLK")
 


end
end	


---------------------------------------------------------------------------ITEMS_OVER_CONTROL


mx, my = reaper.GetMousePosition()

 if last_x ~= nil or last_y~= nil then      
      if last_x ~= mx or last_y ~= my   then
 ------------------------------------------------------------------------CHECK_CHANGES-----------------------   


---------------------------------------------------------CHECK---CHANGES
      end
else mouse_activity=0
end
    
   last_x = mx
   last_y = my


local overtr, y_start = get_track_from_y(y)

local arrange_window = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)

if overtr and arrange_window==frompoint then 

ov_it, item_y, item_h, _, activate_drag, close_item, _ , _ = get_nearest_item(x,y,overtr, y_start)






 if last_close_item ~= nil then      
      if last_close_item  ~= close_item   then
 ------------------------------------------------------------------------CHECK_CHANGES-----------------------    
running = true
 
---------------------------------------------------------CHECK---CHANGES
else 

running = false

 end
 end
    
    last_close_item  = close_item 










if mouse_state ==0 and running == false then 

if  activate_drag == true then



if drag_edge == nil then 

reaper.Main_OnCommand(39064, 0) -----item
reaper.Main_OnCommand(39096, 0) ----fade
drag_edge=0 end
if ov_it==true then
reaper.JS_Mouse_SetCursor(reaper.JS_Mouse_LoadCursor(32512)) 
reaper.JS_WindowMessage_Intercept(arrange_window, "WM_SETCURSOR", false)
end
else


if drag_edge == 0 then 
reaper.Main_OnCommand(39065, 0) -----item 
reaper.Main_OnCommand(39097, 0) ------fade
drag_edge=nil end
reaper.JS_WindowMessage_ReleaseWindow( arrange_window)



end

end

end
   

   
   
   
 ---------------------------------------------------------------------------ITEMS_OVER_CONTROL---END



midieditor_hwnd=reaper.MIDIEditor_GetActive()

-------IF  MIDIEDITOR 

if midieditor_hwnd then
zmouse_x,zmouse_y= reaper.GetMousePosition()

mover = reaper.JS_Window_GetTitle( frompoint, 0 )  
  
if (frompoint==reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003)) then  retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(frompoint) end
if (frompoint==reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003)) and x< left+42  then---------------------------------------START
intercept(0, reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003),"WM_LBUTTONDOWN" )

reaper.JS_Mouse_SetCursor(reaper.JS_Mouse_LoadCursor(429)) 
reaper.JS_WindowMessage_Intercept(reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003), "WM_SETCURSOR", false)


 muteoff=1 
if dgzclick==1 then ifzoom=0 dgzclick=0 end
else
if dzmousedown ~=1 and muteoff==1 then intercept(1, reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003),"WM_LBUTTONDOWN")
	 reaper.JS_WindowMessage_Release( reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003), "WM_SETCURSOR")
	
	
	muteoff=0  end
end  
  
  
  
-----------------------------GET------CHANGE---GRID-----
  
retval, med_left, med_top, med_right, med_bottom = reaper.JS_Window_GetClientRect(midieditor_hwnd)
if get_win_id(frompoint)==1001 and parpar == midi or get_win_id(frompoint)==1137 and par==midi 
or get_win_id(frompoint)==1138 and par==midi or get_win_id(frompoint)==1224 and par==midi 
and x > med_left and  x < med_right and y > med_bottom - 22 and y < med_bottom  then




     if l_checkbox ~= nil then 
     if l_checkbox ~= mover
      then
       writegrid()
     end
    end
   l_checkbox = mover


--------------------------------------------GET------CHANGE---GRID- END


end


end  ----

-------IF  MIDIEDITOR END

end
---------------
------end realtime frompoint












---------------------------------------------------------MIDI_EDITOR_SECTION-----------------------------------------------------------------------------




if mouse_state == 1 or mouse_state == 5 or mouse_state == 9   then ------------------------------start of realtime pooling  
  


  
  


  dx, dy = reaper.GetMousePosition()
 

 if d_last_x ~= nil or d_last_y~= nil then      
      if d_last_x ~= dx or d_last_y ~= dy   then
 ------------------------------------------------------------------------CHECK_CHANGES-----------------------   

if mouse_mov_lbuttondown==nil then  mouse_mov_lbuttondown=0 end





---------------------------------------------------------CHECK---CHANGES
      end

end
    
   d_last_x = dx
   d_last_y = dy
  

  
  
  
  
  
  ---------------------------------------------TCP------BUTTONS

if frompoint and click_once == nil then
	
	

local rettrack, track = get_if_tcp(frompoint)

if rettrack==true  then 
	
	
	
  
  if tcp_buttons(track, x, y) == "solo"  then 
  
  solo_exlusive = 1
  tsolo=reaper.GetMediaTrackInfo_Value(track, "I_SOLO" )
   click_once=1   
  elseif tcp_buttons(track, x, y) == "recarm"  then 
  
  rec_exlusive = 1
  recarm=reaper.GetMediaTrackInfo_Value(track, "I_RECARM")
  click_once=1   
  elseif tcp_buttons(track, x, y) == "folder"  then 
  
  fold_unfold = 1
  click_once=1   
  foldstate=reaper.GetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT")
  
    elseif tcp_buttons(track, x, y) == "volume"  then 
  vol_foc = 1
  click_once=1   
    
  end

end  
     

if get_if_transport(frompoint)==true then
		
if get_transport_buttons(x,y,frompoint) =="rec" then
	rec = 1
click_once=1   
	elseif  get_transport_buttons(x,y,frompoint) =="stop" then
    stop = 1
click_once=1   
elseif  get_transport_buttons(x,y,frompoint) =="play" then
   play = 1  
click_once=1   
end
end	
	 
	
	 
end  
  


  
  
  
  

-----------------------------------------ENVELOPES SECTION-----

envstate = tonumber(reaper.GetExtState("MyDaw", "ShowEnvelopes"))



if (envstate == 1) then





rettrack, track = get_if_tcp(frompoint)

if track then last_tr = track else last_tr = reaper.GetLastTouchedTrack() end 
 


  
if last_tr  then

tvolume = reaper.GetMediaTrackInfo_Value( last_tr , "D_VOL")
tpanorama = reaper.GetMediaTrackInfo_Value( last_tr , "D_PAN")
for numb_send = 0, reaper.GetTrackNumSends( last_tr, 0) - 1 do
var1 = "sendvol"
var2 = "last_sendvol"
var3 = tostring(numb_send)
_G[var1..var3] = reaper.GetTrackSendInfo_Value( last_tr, 0, numb_send, "D_VOL" )

if ltr==last_tr and _G[var3..var3] ~= nil then if _G[var3..var3] ~= _G[var1..var3] then
nm='Send'
add_env_to_track(last_tr, fxnumber, paramnumber, nm, numb_send,_G[var1..var3] )    end end 
_G[var3..var3] = _G[var1..var3]
end 
 
if ltr ~= nil and ltr==last_tr  then  


if  tvol ~= tvolume then nm='Volume'
  
reaper.defer(add_env_to_track(last_tr, 0, 0, nm, 0,tvolume ))



      
elseif tpan ~= tpanorama  then   nm='Pan'
add_env_to_track(last_tr, 0, 0, nm, 0,tpanorama )


        
end
end


   ltr = last_tr
   tvol = tvolume
   tpan = tpanorama
   




end
--------------------------------------------------------------------


 
     istrack, tracknumber, fxnumber, paramnumber = reaper.GetLastTouchedFX()
   
     if istrack then
    
    lttrack = reaper.GetTrack(0, tracknumber-1) 
    if lttrack == nil then lttrack = reaper.GetMasterTrack(0) end
  local val, _,_ = reaper.TrackFX_GetParam(lttrack, fxnumber, paramnumber ) 
    if last_val ~= nil then 
     if last_val ~= val
      
        then
        nm="FX"
        add_env_to_track(lttrack, fxnumber, paramnumber, nm, 0,val )
        
    
       
          
      end
    end
   last_val = val
end  
  
end  



  
 --------------------------------------------DRAG--ZOOM-----ACTION 
if midieditor_hwnd then

rval, mvleft, mvtop, mvright, mvbottom = reaper.JS_Window_GetRect(frompoint)

---[[

---------------------------------------------SMARTGRID---ZOOM---INIT


if (frompoint==reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1001)) 
  and zmouse_y <(mvtop+46) and zmouse_y> mvtop  then smartgrid=1   end

  
-----------------------------------------------------MIDI EDITOR_ TIME _SELECTION REMOVE  
  
if (frompoint==reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1001)) 
and zmouse_y >(mvtop+64) and zmouse_y < (mvbottom-17) and zmouse_x > mvleft and zmouse_x < (mvright-17) then  

  if lock_ts==1 then startpos_x = zmouse_x  startpos_y = zmouse_x  lock_ts=0   end miditsremove=1 end

--]]  
------------------------------------------------------------------------------------  
  


------------------------------------------------------DRAGZOOMM  ----------------------------------------------------------------------------------------


  
if (frompoint==reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003)) then  retval, left, top, right, bottom = reaper.JS_Window_GetClientRect(frompoint)x,y = reaper.GetMousePosition() end
if (frompoint==reaper.JS_Window_FindChildByID( reaper.MIDIEditor_GetActive(), 1003)) and x< left+42 and upzoom==1 or upzoom==nil then dzoomon = 1 upzoom=0  else upzoom=0 end



if dzoomon ==1 then

if not stoped then stoped = 0 end 
if not stopedvert  then stopedvert = 0 end 
if not diff then diff = 0 end
if not diffvert then diffvert = 0 end
state =  reaper.JS_Mouse_GetState(1) 

if state > 0 and ifzoom==0 then
dzmousedown=1
if dragzoom==nil then zx,zy = reaper.GetMousePosition() end
x1,y1 = reaper.GetMousePosition()
dragzoom=1
diff = (x1-zx)*0.01
diffvert = (y1-zy)*0.01

if  math.abs(diff) > math.abs(diffvert) then



if diff ~= stoped then
       midieditor = reaper.MIDIEditor_GetActive()
    if diff < stoped then
    if speed_h==1 then  reaper.MIDIEditor_OnCommand( midieditor,40112) speed_h=0 else speed_h=1 end
  else
  if speed_h==1 then reaper.MIDIEditor_OnCommand( midieditor,40111) speed_h=0 else speed_h=1 end

    end
  stoped = diff
end

else
if diffvert ~= stopedvert then
       midieditor = reaper.MIDIEditor_GetActive()
    if diffvert < stopedvert  then
  if speed_h==1 then  reaper.MIDIEditor_OnCommand( midieditor,40139) speed_h=0 else speed_h=1 end 
  
  else
    if speed_h==1 then  reaper.MIDIEditor_OnCommand( midieditor,40138) speed_h=0 else speed_h=1 end 
  
    end  
stopedvert = diffvert
end
end
end
end
 
 
end
 
 
 
 
 
 






if  smartgrid==1 then
SetMidiGrid()
end

--]]

 
 
 -------------------------------------------------------!!!!!!!!!!!!!!!!-PROTECTION-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if leftmousedown == nil then
window, segment, details = reaper.BR_GetMouseCursorContext()
leftmouseup = 1
leftmousedown = 0
end---------------------------------- 

if  window ~= "arrange" then
arrange_click = 1
end
  
if window =="arrange" and segment == "track" and  (details == "env_segment" or details == "env_point" or details == "item_stretch_marker") and arrange_click == nil    then
arrange_click =1  
end
 
if mouse_state==1 then  ---------------------------------------------------MOUSE LEFT CLICK--------------------------------


-------------------------------------------------------------------------------HOLD---MOUSE-----BUTTON


--------------------------------------CURSOR_OVVERRIDE-------------------------------------------


if edge_click == nil and window =="arrange" and segment == "track" then

local overtr, y_start = get_track_from_y(y)	
x,y = reaper.GetMousePosition()
is_over_edge, _, _, _, _, _ ,out_edge, bot_edge = get_nearest_item(x,y,overtr, y_start)

if out_edge==true then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40513 , 0) -----move cursor to mouse cursor   
reaper.Main_OnCommand(40289 , 0) --unselect all items 
reaper.Main_OnCommand(40635 , 0) ----remove time selection
reaper.Main_OnCommand(41110 , 0) ---select track under mouse 
reaper.PreventUIRefresh(-1)
end
if bot_edge == true then
_, _, details = reaper.BR_GetMouseCursorContext()	
if not (details == "env_segment" or details == "env_point" or details == "item_stretch_marker") then
reaper.PreventUIRefresh(1)	
reaper.Main_OnCommand(40513 , 0) -----move cursor to mouse cursor             
reaper.Main_OnCommand(40289 , 0) --unselect all items 
reaper.Main_OnCommand(40635 , 0) ----remove time selection
        
        _, _, _ = reaper.BR_GetMouseCursorContext()
                    item = reaper.BR_GetMouseCursorContext_Item()
                    if item ~= nil then
        
        
        
          lastitem = reaper.BR_GetMediaItemGUID(item)
        
             
         
   
             
             reaper.DeleteExtState('MyDaw', 'Click On Bottom Half', 0)
             reaper.SetExtState('MyDaw', 'Click On Bottom Half', lastitem, 0)





end 
reaper.PreventUIRefresh(-1)
else 
arrange_window = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)	
reaper.JS_WindowMessage_ReleaseWindow(arrange_window)

end 

end 
	


          
edge_click  = 0
end





if window =="arrange" and segment == "track" and details == "empty" and arrange_click  == nil or window =="arrange" and segment == "empty" and arrange_click  == nil and mouse_state ~=16 then
reaper.Main_OnCommand(40513 , 0) -----move cursor to mouse cursor             
arrange_click = 1
end






if window =="arrange" and segment == "track" and details == "item" and arrange_click  == nil  and mouse_state ~=16 then
  
  
local track = reaper.BR_GetMouseCursorContext_Track()
local x, y = reaper.GetMousePosition()
  


  
local overtr, y_start = get_track_from_y(y)

if overtr and y_start then  is_over_edge, item_y, item_h, _ , _ ,_ , _, _ = get_nearest_item(x,y,overtr, y_start) end

  
  



if y_start and item_y and  item_h  then

half_line = (y_start+item_y)+(item_h /2)

if  y >  half_line then
reaper.Main_OnCommand(40513 , 0) -----move cursor to mouse cursor          
arrange_click =1
else
  reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)  
reaper.Main_OnCommand(40529, 0)    -----Item: Select item under mouse cursor
reaper.Main_OnCommand(41173, 0)   ---set to start of items 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0) 
reaper.PreventUIRefresh(-1)
arrange_click =1
end  
end
-------------------------hjkl


end

------------------------------------------------------------------SMART---GRID_CUSTOM_SWITCH


--]]




----------------------------------------------------------------------------HOLD-- LEFT ---MOUSE-----BUTTON-------end






elseif mouse_state==5 then  ------------------------------------CLICK---WITH CONTROL

local window, segment, details = reaper.BR_GetMouseCursorContext()

 if window =="arrange" and segment == "track" and details == "item" and arrange_click  == nil  then
    
local track = reaper.BR_GetMouseCursorContext_Track()
local x, y = reaper.GetMousePosition()
  
local overtr, y_start = get_track_from_y(y)

if overtr and y_start then  is_over_edge, item_y, item_h, _, _,_ ,_ ,_  = get_nearest_item(x,y,overtr, y_start) end

  
  if y_start and item_y and  item_h  then

half_line = (y_start+item_y)+(item_h /2)

if  y >  half_line then
reaper.Main_OnCommand(40513 , 0) -----move cursor to mouse cursor             
arrange_click =1

else
  
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)
reaper.Main_OnCommand(41173, 0)   ---set to start of items 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0) 
reaper.PreventUIRefresh(-1)
arrange_click =1
end  
  

end
  
end  
  
  


elseif mouse_state==9 then

local window, segment, details = reaper.BR_GetMouseCursorContext()
if window =="arrange" and segment == "track" and details == "item" and arrange_click  == nil  then
local track = reaper.BR_GetMouseCursorContext_Track()
local x, y = reaper.GetMousePosition()
local overtr, y_start = get_track_from_y(y)
if overtr and y_start then  is_over_edge, item_y, item_h, _ , _ , _ , _, _ = get_nearest_item(x,y,overtr, y_start) end

  
  if y_start and item_y and  item_h  and half_line then

if  y >  half_line then
reaper.Main_OnCommand(40513 , 0) -----move cursor to mouse cursor             
arrange_click =1
else 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)
reaper.Main_OnCommand(41173, 0)   ---set to start of items 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0) 
reaper.PreventUIRefresh(-1)

arrange_click =1


end  
 
end
 
  
end  
 








end
-----------------------------END----SORT_OF_CLICKS

  
  
  





end-------end of modifiers real-time polling
------------------------------------------------------------real-time polling END



if leftmouseup == 1 and  (mouse_state == 0 or mouse_state == 4 or  mouse_state == 8 or  mouse_state == 16 or  mouse_state == 24 or mouse_state == 12  or mouse_state == 28)  then 



---------------------CLOBAL-MOUSE UP---------------------------------
----------------Track-Tweaks--Block---------------

--------------------------RemoveTimeSelMidiEditor---------

if miditsremove==1 and startpos_x == x and startpos_y == x then     midieditor = reaper.MIDIEditor_GetActive()
reaper.MIDIEditor_OnCommand(midieditor, 40467) miditsremove=0 end
lock_ts=1 

--------------------------------------------------------------------------------------------------------------------------



---------destroy tooltip
x, y = reaper.GetMousePosition()
reaper.TrackCtl_SetToolTip( "", x, y, false )
--------------------------------------------------------

-----------------------------------------TCP------BUTTONS-----MOUSEUP


if frompoint then

local rettrack, track = get_if_tcp(frompoint)



if rettrack==true and window =="tcp" and segment == "track" and mouse_mov_lbuttondown==nil  then 
  

  
  if tcp_buttons(track, x, y) == "solo"  then 
	

	

local  function runsolo()
	tsolo=reaper.GetMediaTrackInfo_Value(track, "I_SOLO" )

  if tsolo==nil then reaper.defer(runsolo) else    if solo_exlusive == 1  then  solo_rec_exlusive(track, tsolo, mouse_state, "I_SOLO")  solo_exlusive = 0 end 
  
  
  end
end

runsolo()


elseif tcp_buttons(track, x, y) == "recarm" then
	
	
local function runrec()
	recarm=reaper.GetMediaTrackInfo_Value(track, "I_RECARM")
	
	

  if recarm==nil then reaper.defer(runrec) else  if rec_exlusive == 1  then  solo_rec_exlusive(track, recarm, mouse_state, "I_RECARM")  rec_exlusive = 0 end 
  
  
  end
end

runrec()
	
elseif tcp_buttons(track, x, y) == "folder" then
	
	
local function runfold()
	foldstate=reaper.GetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT")
	
	
 if foldstate==nil then reaper.defer(runfold) else  if fold_unfold == 1  then  folderstates(track, foldstate, mouse_state)  fold_unfold  = 0 end 
  
  
  end
end

runfold()	
  

 
elseif tcp_buttons(track, x, y) == "io" and (envstate == 1) and  rettrack==true and track  then



reaper.SetOnlyTrackSelected(track) 		
reaper.Main_OnCommand(40914, 0) -----set as last touched



elseif tcp_buttons(track, x, y) == "volume" then
	
	
local function vol_foc()
	
frompoint = reaper.JS_Window_FromPoint(reaper.GetMousePosition())
address = reaper.JS_Window_AddressFromHandle( frompoint )

VolTrGUID = tostring(address)
reaper.DeleteExtState( "MyDaw", "focus_on_volume", false )
reaper.TrackList_AdjustWindows(false)

if reaper.CountSelectedTracks(0)==1 then 
	local some_sel_track =  reaper.GetSelectedTrack( 0, 0)
	
	if some_sel_track ~= track  then reaper.SetOnlyTrackSelected(track)  end
end



reaper.SetExtState( "MyDaw", "focus_on_volume", VolTrGUID, false )	
local info = debug.getinfo(1,'S');
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])
dofile(script_path .. "SetVolFocus.lua")	
	

	
vol_foc  = 0 
  
  
  
end

vol_foc()	




 
  
  end
-----------SOLO
end  
  
  
if get_if_transport(frompoint)==true and window == "transport" then
		
if get_transport_buttons(x,y,frompoint) =="rec" then
	if rec == 1  then  smart_rec()  rec = 0 end
elseif  get_transport_buttons(x,y,frompoint) =="stop" then
    if stop ==1  then  smart_stop()  stop = 0 end
elseif  get_transport_buttons(x,y,frompoint) =="play" then
    if play == 1  then  play_from()  play = 0 end
end
end	  
  
  
  
  
  
  
  
end  

 ---[[ 

local rettrack, track = get_if_tcp(frompoint)


if rettrack==false then reaper.DeleteExtState( "MyDaw", "focus_on_volume", false )
reaper.TrackList_AdjustWindows(false)
elseif rettrack==true then	
if tcp_buttons(track, x, y) ~= "volume" then  reaper.DeleteExtState( "MyDaw", "focus_on_volume", false ) 
reaper.TrackList_AdjustWindows(false)

end end

--]]






edge_click = nil
arrange_click = nil
smartgrid=nil
dragzoom=nil
diff=0
diffvert=0
stoped=0
dgzclick=1
ifzoom=1
dzmousedown=0
dzoomon =0
upzoom=1
click_once = nil
once_up=nil
tsolo=nil
recarm=nil


d_last_x = nil
d_last_y = nil
mouse_mov_lbuttondown=nil 





change = reaper.GetProjectStateChangeCount(0)
 if last_change~= nil then      
      if last_change ~= change  then
 ------------------------------------------------------------------------CHECK_CHANGES-----------------------    
	 
if window =="arrange" and (segment == "track") or (segment == "envelope")  or  (segment == "empty") then
envelope_control()


end	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
---------------------------------------------------------CHECK---CHANGES
      end
    end
    
    last_change = change

------------------------------NEW-----PLACE-end-------------------------------




leftmouseup = nil
leftmousedown = nil

end


reaper.defer(main)

  end, crash)

end



main()













