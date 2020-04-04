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

local r = reaper; local function nothing() end; local function noaction() reaper.defer(nothing) end

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
