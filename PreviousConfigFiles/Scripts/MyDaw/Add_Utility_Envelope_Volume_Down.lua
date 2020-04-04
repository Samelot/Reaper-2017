function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end


tips= {}

local function to_pixel(val)
  local pixel = math.floor(val * reaper.GetHZoomLevel())
  return pixel
end


local track_window = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)    
local Arr_start_time, _ = reaper.GetSet_ArrangeView2(0, false, 0, 0) -- GET ARRANGE VIEW
local Arr_pixel = to_pixel(Arr_start_time)-- ARRANGE VIEW POSITION CONVERT TO PIXELS
local _, x_view_start, top_of_arr, _, _ = reaper.JS_Window_GetRect(track_window) -- GET TRACK WINDOW X-Y COORDINATES


local function get_track_y_range(cur_tr)
 
 local retval, found = reaper.JS_Window_ListAllChild(reaper.GetMainHwnd())
     for adr in found:gmatch("%w+") do
       local handl = reaper.JS_Window_HandleFromAddress(tonumber(adr))
       if reaper.JS_Window_GetLongPtr(handl, "USER") == cur_tr 
    and reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(reaper.JS_Window_GetParent(handl)))== reaper.GetMainHwnd()
    then 
 retval, left, top, right, bottom = reaper.JS_Window_GetRect(handl)
 end
 end       
  return top, bottom-- RETURN TRACKS Y START & END
end







function show_tooltips(message,X_Place,Y_Place,seltr)


GUID = reaper.GetTrackGUID(seltr)

GUID = tostring(GUID)



	
function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

X_Place=round(X_Place) 
Y_Place=round(Y_Place) 


Width, _ = reaper.JS_LICE_MeasureText(message)


track_window = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)
fontFace = "Arial"
textHeight = 14
X_pos=0
Y_pos=0
Height= 20
Text_X=X_pos+(Width/4)
Text_Y=Y_pos+(Height/5)





function updateLICE()            
            reaper.JS_LICE_Clear(_G[GUID], 0)
            reaper.JS_LICE_FillRect( _G[GUID], X_pos+2, Y_pos+2, Width-3, Height-3, 0xFFffffe1, 1, 0)
            reaper.JS_LICE_DrawText(_G[GUID], LICE_Font, message, 100, Text_X, Text_Y, Width, Height)
            reaper.JS_LICE_RoundRect( _G[GUID], X_pos+1, Y_pos+1, Width-2, Height-2, 0, 0xFF121212, 1, "ADD", 1 )
            reaper.JS_Window_InvalidateRect(track_window , X_pos, Y_pos, Width, Height, false)
end

    _G[GUID] = reaper.JS_LICE_CreateBitmap(true, Width, Height)
    if not _G[GUID] then reaper.MB("Could not create a LICE bitmap.", "ERROR", 0) return(false) end
    LICE_Font = reaper.JS_LICE_CreateFont()
    if not LICE_Font then reaper.MB("Could not create a LICE font.", "ERROR", 0) return(false) end
    ::setFontSize:: do
        GDI_Font  = reaper.JS_GDI_CreateFont(textHeight, 400, 0, false, false, false, fontFace)
        if not GDI_Font then reaper.MB("Could not create a GDI font.", "ERROR", 0) return(false) end
        local options = (windowsOS and ME_TryAntiAlias) and "BLUR" or ""
        reaper.JS_LICE_SetFontFromGDI(LICE_Font, GDI_Font, options)
    end
    reaper.JS_LICE_SetFontBkColor(LICE_Font, 0) -- Transparent
    ME_TextColor = 0xFF121212
    reaper.JS_LICE_SetFontColor(LICE_Font, ME_TextColor)
    
    reaper.JS_Composite(track_window, X_Place,Y_Place, Width, Height, _G[GUID], X_pos, Y_pos, Width, Height) reaper.JS_Window_InvalidateRect(track_window, X_pos, Y_pos, Width, Height, false)   
    
    updateLICE()
    
  


end


---[[

function  destroy()  

       if GDI_Font then reaper.JS_GDI_DeleteObject(GDI_Font) end
       if _G[GUID]then 
           if track_window then reaper.JS_Composite_Unlink(track_window, _G[GUID]) 
		   reaper.JS_Window_InvalidateRect(track_window, 0, 0, Width, Height, false) 
		   end
           reaper.JS_LICE_DestroyBitmap(_G[GUID])
       end
reaper.UpdateArrange()
end
--]]








function AddEnvelope(seltr,utility_index, act)

       env = reaper.GetFXEnvelope( seltr, utility_index, 7, act )
   if  env then 
      
        local BR_env = reaper.BR_EnvAlloc( env, false )
        local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties( BR_env )
        reaper.BR_EnvSetProperties( BR_env, active, true, armed, inLane, laneHeight, defaultShape, faderScaling )
        reaper.BR_EnvFree( BR_env, true )
      end
end


function AddVolume(seltr)

utility = reaper.TrackFX_AddByName( seltr, "Volume Utility", false, 0 )


if utility == -1 then ----------------------------------------------------------IF NOT ADD
utility_index = reaper.TrackFX_GetByName( seltr, "Volume Utility", 1 )
reaper.TrackFX_AddByName( seltr, "Volume Utility", false, 1 )   
    
utility_index = reaper.TrackFX_GetByName( seltr, "Volume Utility", 1 )


-----------------------------------------------------------
if seltr==reaper.GetMasterTrack(0)   then

while utility_index  > 0  do

reaper.SNM_MoveOrRemoveTrackFX( seltr, utility_index , -1 )
utility_index = reaper.TrackFX_GetByName( seltr, "Volume Utility", 1 )

end
end
-----------------------------------------------------------

AddEnvelope(seltr,utility_index,true)




elseif utility > -1 then ----------------------------------------------------------IF ALREADY ADD 
utility_index = reaper.TrackFX_GetByName( seltr, "Volume Utility", 1 )
env = reaper.GetFXEnvelope( seltr, utility_index, 7, false )
if  env then 
      
        local BR_env = reaper.BR_EnvAlloc( env, false )
        local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties( BR_env )
if visible==false then
        reaper.BR_EnvSetProperties( BR_env, true, true, true, inLane, laneHeight, defaultShape, faderScaling )
        reaper.BR_EnvFree( BR_env, true )
end

else 
AddEnvelope(seltr,utility_index,true)

end
end
return env
end





function GetDeleteTimeLoopPoints(envelope, env_point_count, start_time, end_time)
  local set_first_start = 0
  local set_first_end = 0
  for i = 0, env_point_count do
    retval, time, valueOut, shape, tension, selectedOut = reaper.GetEnvelopePoint(envelope,i)

    if start_time == time and set_first_start == 0 then
      set_first_start = 1
      first_start_idx = i
      first_start_val = valueOut
    end
    if end_time == time and set_first_end == 0 then
      set_first_end = 1
      first_end_idx = i
      first_end_val = valueOut
    end
    if set_first_end == 1 and set_first_start == 1 then
      break
    end
  end

  local set_last_start = 0
  local set_last_end = 0
  for i = 0, env_point_count do
    retval, time, valueOut, shape, tension, selectedOut = reaper.GetEnvelopePoint(envelope,env_point_count-1-i)

    if start_time == time and set_last_start == 0 then
      set_last_start = 1
      last_start_idx = env_point_count-1-i
      last_start_val = valueOut
    end
    if end_time == time and set_last_end == 0 then
      set_last_end = 1
      last_end_idx = env_point_count-1-i
      last_end_val = valueOut
    end
    if set_last_start == 1 and set_last_end == 1 then
      break
    end
  end

  if first_start_val == nil then
    retval_start_time, first_start_val, dVdS_start_time, ddVdS_start_time, dddVdS_start_time = reaper.Envelope_Evaluate(envelope, start_time, 0, 0)
  end
  if last_end_val == nil then
    retval_end_time, last_end_val, dVdS_end_time, ddVdS_end_time, dddVdS_end_time = reaper.Envelope_Evaluate(envelope, end_time, 0, 0)
  end

  if last_start_val == nil then
    last_start_val = first_start_val
  end
  if first_end_val == nil then
    first_end_val = last_end_val
  end

  reaper.DeleteEnvelopePointRange(envelope, start_time-0.000000001, end_time+0.000000001)

  return first_start_val, last_start_val, first_end_val, last_end_val

end

function AddPoints(env,seltr)
  br_env = reaper.BR_EnvAlloc(env, false)
  active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)

if visible == true and armed == true then
   env_points_count = reaper.CountEnvelopePoints(env)
if env_points_count > 0 then
      for k = 0, env_points_count+1 do
        reaper.SetEnvelopePoint(env, k, timeInOptional, valueInOptional, shapeInOptional, tensionInOptional, false, true)
      end
    end

first_start_val, last_start_val, first_end_val, last_end_val = GetDeleteTimeLoopPoints(env, env_points_count, start_time, end_time)



if last_start_val <= -10  then return 
else
move=-1
end 



    reaper.InsertEnvelopePoint(env, start_time, first_start_val, 0, 0, true, true) -- INSERT startLoop point

   reaper.InsertEnvelopePoint(env, start_time, last_start_val+move, 0, 0, true, true)
   reaper.InsertEnvelopePoint(env, end_time, first_end_val+move, 0, 0, true, true)

    reaper.InsertEnvelopePoint(env, end_time, last_end_val, 0, 0, true, true) -- INSERT EndLoop point
    reaper.BR_EnvFree(br_env, 0)
    reaper.Envelope_SortPoints(env)
  end



y_start, y_end = get_track_y_range(seltr) 
txt_width, _ = reaper.JS_LICE_MeasureText(last_start_val+move)
pos_x = (to_pixel((start_time+((end_time-start_time)/2)))-Arr_pixel)
pos_x=pos_x-(txt_width/2)
pos_y = y_start + ((y_end - y_start)/2)- 7 -top_of_arr
show_tooltips(last_start_val+move,pos_x, pos_y, seltr )

 








 
  
  
  
  end
-----------------------------------ene add points

reaper.PreventUIRefresh(1) 
reaper.Undo_BeginBlock() 

if  reaper.CountSelectedMediaItems(0)>0 then reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELTRKWITEM'), 0) end
start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
if start_time ~= end_time then

reaper.SelectAllMediaItems( 0, false)
if  reaper.CountSelectedTracks(0)==0 and  reaper.IsTrackSelected(reaper.GetMasterTrack(0))==false then return end  

for i = 0, reaper.CountSelectedTracks2(0,true) do
        local seltr = reaper.GetSelectedTrack2(0,i-1,true)
        if seltr then 


    start_time = math.floor(start_time * 100000000+0.5)/100000000
    end_time = math.floor(end_time * 100000000+0.5)/100000000

 GUID = reaper.GetTrackGUID(seltr)

GUID = tostring(GUID) 
 
 tips[i] = GUID

 
  
  env = AddVolume(seltr)
   AddPoints(env,seltr)

end  
end
  
  
  
else ----------------------------------------------------------------------------------------------------------------------------

if  reaper.CountSelectedTracks(0)==0 then return end 


for i = 0, reaper.CountSelectedTracks2(0,false) do
        local seltr = reaper.GetSelectedTrack2(0,i-1,false)
        if seltr then 
 if  reaper.CountTrackMediaItems(seltr) > 0 then
     
  ------for start   
     
     for i = 0, reaper.CountTrackMediaItems(seltr) do
    local  it = reaper.GetTrackMediaItem( seltr, i-1)
        if it then
        if reaper.IsMediaItemSelected(it) then 
       start_time = reaper.GetMediaItemInfo_Value(it, 'D_POSITION') 
       
       break end
    --------for end

end
end
      
        
        for i = reaper.CountTrackMediaItems(seltr)-1, 0, -1 do
              it = reaper.GetTrackMediaItem(seltr,i)
                if it then
                if reaper.IsMediaItemSelected(it) then 
                end_time = (reaper.GetMediaItemInfo_Value(it, 'D_POSITION')+reaper.GetMediaItemInfo_Value(it, 'D_LENGTH'))  
                break end

end
end
end
    
start_time = math.floor(start_time * 100000000+0.5)/100000000
end_time = math.floor(end_time * 100000000+0.5)/100000000
 
GUID = reaper.GetTrackGUID(seltr)

GUID = tostring(GUID) 
 
 tips[i] = GUID

env = AddVolume(seltr)
AddPoints(env,seltr)


end 
end



end-- ENDIF time selection

reaper.Undo_EndBlock("Add Volume Utility", -1) 
reaper.PreventUIRefresh(-1) 

reaper.UpdateArrange() 


t0 = os.clock()
function run()
	if last_start_val <= -10  then return end
  t = os.clock()
  if t - t0 < 0.5 then reaper.defer(run) else 

if  tips then 

  if GDI_Font then reaper.JS_GDI_DeleteObject(GDI_Font) end
 for i = 1 ,#tips  do
    local bm = tips[i]
	gstring=tostring(bm)
	
	reaper.JS_Composite_Unlink(track_window,_G[gstring])
    reaper.JS_LICE_DestroyBitmap(_G[gstring])
  
  end 
  if reaper.ValidatePtr(track_window, "HWND") then 
    reaper.JS_Window_InvalidateRect(track_window, 0, 0, Width, Height, true) 
  end	
end

end
end

run()




