function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end



focus = reaper.GetCursorContext()
vol_focus=0



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






local function add_env_to_track(track, valueIn)
envstate = tonumber(reaper.GetExtState("MyDaw", "ShowEnvelopes"))

if (envstate == 1) then

reaper.PreventUIRefresh(1)
    env = reaper.GetTrackEnvelopeByName(track,"Volume")
    if env==nil then 
      reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0) 
      reaper.SetOnlyTrackSelected(track)  -----set as last touched     
      reaper.Main_OnCommand(40914, 0)
      reaper.Main_OnCommand(40052, 0) 
      
      env = reaper.GetTrackEnvelopeByName(track,"Volume") end
      
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
  
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0)   -----restore tracks selection 
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
 

end
end  ---------------------------End Function









function nudge(how_much, vtr)
-----------------you always can change this--
local nudge = -1
local vlimit = -150
-- in db
---------------------------------------------
function minvol()
      vol_min = 1.9952623149689
      for i = 0, reaper.CountSelectedTracks()- 1 do
        local tr = reaper.GetSelectedTrack(0,i)
        local vol = reaper.GetMediaTrackInfo_Value(tr, 'D_VOL')
        vol_min = math.min(vol_min, vol )
      end
return DB(vol_min)
end

-----------------------
function VOL(db) return 10^(0.05*db) end
function DB(vol) return 20*math.log(vol, 10) end
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
if how_much == "lot" then
----------------
if minvol()-1 < vlimit then nudge=(vlimit-minvol())  end 
if minvol() <= vlimit then return end

local vol = reaper.GetMediaTrackInfo_Value(vtr, 'D_VOL')
add_env_to_track(vtr, VOL(DB(vol)+nudge))


 
local tracks = reaper.CountSelectedTracks()
if tracks == 0 then return end
for i = 0, tracks-1 do
  local tr = reaper.GetSelectedTrack(0,i)
  local vol = reaper.GetMediaTrackInfo_Value(tr, 'D_VOL')
if DB(vol) > vlimit then  reaper.SetMediaTrackInfo_Value(tr, 'D_VOL',VOL(DB(vol)+nudge)) end
end
elseif how_much == "one" then
vol = reaper.GetMediaTrackInfo_Value(vtr, 'D_VOL')
if DB(vol) > vlimit then reaper.SetMediaTrackInfo_Value(vtr, 'D_VOL',VOL(DB(vol)+nudge))  add_env_to_track(vtr, VOL(DB(vol)+nudge)) end

end
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Nudge volume down 1 db', -1)
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




focus_on_volume = reaper.GetExtState( "MyDaw", "focus_on_volume")
if (focus_on_volume and focus_on_volume ~= '') then
vadress = tonumber(focus_on_volume)
vtrack_window = reaper.JS_Window_HandleFromAddress(vadress)
 _, vtr =  get_if_tcp(vtrack_window)
vol_focus = 1
end




if vol_focus == 1 and focus == 0  then
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_UNSELCHILDREN'), 0)
if  reaper.IsTrackSelected(vtr) and reaper.CountSelectedTracks(0)> 1 then nudge("lot" ,vtr) else nudge("one" ,vtr) end


else

if focus == 0 then
reaper.Main_OnCommand(40285, 0) ---Track: Go to next track
elseif focus == 1 then

reaper.Main_OnCommand(41924,0)------Item: Nudge items volume -1dB


elseif focus == 2 then

env = reaper.GetSelectedEnvelope()
if env then 
points = reaper.CountEnvelopePoints(env)
if  points then 

for i = 0, points-1 do
  _, time, value, _, _, sel = reaper.GetEnvelopePoint(env,i)
  if sel then 

retval, buf = reaper.GetEnvelopeName( env, 0)

if buf == "Pitch" then

reaper.SetEnvelopePoint( env, 0, 0, (value-1), 0, 0, sel, 0 )

else

reaper.Main_OnCommand(41181,0) ----Envelopes: Move selected points down a little bit

end

_, time, value, _, _, sel = reaper.GetEnvelopePoint(env,i)

reaper.UpdateArrange()

x, y = reaper.GetMousePosition()
reaper.TrackCtl_SetToolTip( value, x+15, y, false )

break end


end
end
end
end
end

