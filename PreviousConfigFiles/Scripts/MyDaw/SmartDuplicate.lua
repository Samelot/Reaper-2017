MoveWithMI = 40070

MoveWithMI_State = reaper.GetToggleCommandState(MoveWithMI)





function DupEnv()

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40324, 0)  --Copy points within time selection
reaper.Main_OnCommand(40631, 0)  ---Go to end time selection
reaper.Main_OnCommand(40058, 0)  ---Paste
timeSelectionStart1, timeSelectionEnd1 = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)
local cursorpos = reaper.GetCursorPosition()


reaper.GetSet_LoopTimeRange(1, 0, timeSelectionEnd1, cursorpos, 0)


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate Envelope', -1)


end










function setpointselected()


function SetAtTimeSelection(env, k, point_time, value, shape, tension)
  
  if time_selection == true then

    if point_time >= start_time and point_time <= end_time then
      reaper.SetEnvelopePoint(env, k, point_time, valueIn, shape, tension, true, true)
    else
      reaper.SetEnvelopePoint(env, k, point_time, valueIn, shape, tension, false, true)
    end
  
  else
    reaper.SetEnvelopePoint(env, k, point_time, valueIn, shape, tension, true, true)
  end
  
end

function Action(env)
  
  -- GET THE ENVELOPE
  retval, envelopeName = reaper.GetEnvelopeName(env, "envelopeName")
  br_env = reaper.BR_EnvAlloc(env, false)

  active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)

  -- IF ENVELOPE IS A CANDIDATE
  if visible == true then

    -- LOOP THROUGH POINTS
    env_points_count = reaper.CountEnvelopePoints(env)

    if env_points_count > 0 then
      for k = 0, env_points_count-1 do 
        retval, point_time, valueOut, shapeOutOptional, tensionOutOptional, selectedOutOptional = reaper.GetEnvelopePoint(env, k)
        
        -- START ACTION

        -- END ACTION
        
        SetAtTimeSelection(env, k, point_time, valueOut, shapeInOptional, tensionInOptional)

      end
    end
    
    reaper.BR_EnvFree(br_env, 0)
    reaper.Envelope_SortPoints(env)
  
  end

end

function main() -- local (i, j, item, take, track)

  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

  if start_time ~= end_time then
    time_selection = true
  end
    
  -- LOOP TRHOUGH SELECTED TRACKS
  env = reaper.GetSelectedEnvelope(0)

  if env == nil then

    selected_tracks_count = reaper.CountSelectedTracks(0)
    for i = 0, selected_tracks_count-1  do
      
      -- GET THE TRACK
      track = reaper.GetSelectedTrack(0, i) -- Get selected track i

      -- LOOP THROUGH ENVELOPES
      env_count = reaper.CountTrackEnvelopes(track)
      for j = 0, env_count-1 do

        -- GET THE ENVELOPE
        env = reaper.GetTrackEnvelope(track, j)

        Action(env)

      end -- ENDLOOP through envelopes

    end -- ENDLOOP through selected tracks

  else

    Action(env)
  
  end -- endif sel envelope

  reaper.Undo_EndBlock("Select envelope points in visible armed envelope of selected tracks", 0) -- End of the undo block. Leave it at the bottom of your main function.

end -- end main()

--msg_start() -- Display characters in the console to show you the begining of the script execution.

--[[ reaper.PreventUIRefresh(1) ]]-- Prevent UI refreshing. Uncomment it only if the script works.

main() -- Execute your main function

--[[ reaper.PreventUIRefresh(-1) ]] -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)

end




function selectright()


timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)
if timeSelectionStart >= timeSelectionEnd then
    return
end

function UnselectAllTracks()
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  reaper.SetTrackSelected(first_track, false)
end



UnselectAllTracks()





-------------------------------------------ADD SELCETED ITEMS---------------------------

  -- LOOP THROUGH SELECTED ITEMS
  selected_items_count = reaper.CountSelectedMediaItems(0)
  
  -- INITIALIZE loop through selected items
  -- Select tracks with selected items

 
  for i = 0, selected_items_count - 1  do
    -- GET ITEMS
    item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
    
    local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    
    

    -- GET ITEM PARENT TRACK AND SELECT Ióòâåðóò
    if itemStart < timeSelectionEnd and itemEnd > timeSelectionStart then    
    
    
     track = reaper.GetMediaItem_Track(item)
    reaper.SetTrackSelected(track, true)
    
    end
        
  end -- ENDLOOP through selected tracks






-------------------------------ADD_SLECETED_ENVELOPES--------------------------

function addtrackwsp()

function AddPoints(env)
  
    timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)
    if timeSelectionStart >= timeSelectionEnd then
        return
    end
 
 
 

 
    
    
    --GET THE ENVELOPE
  br_env = reaper.BR_EnvAlloc(env, false)

  active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)



    env_points_count = reaper.CountEnvelopePoints(env)

   
      
      for k = 0, env_points_count - 1 do
        
        -- GET POINT INFOS
        retval, pos, valueOut, shape, tension, selected = reaper.GetEnvelopePoint(env, k)
        
        if selected and pos < timeSelectionEnd and pos > timeSelectionStart then
        
        etrack = reaper.Envelope_GetParentTrack(env)

                reaper.SetTrackSelected(etrack, true)
--msg(pos)







end

end     

end 

-- LOOP TRHOUGH SELECTED TRACKS

local tracks = reaper.CountTracks()

for i = 0, tracks-1 do

  local track = reaper.GetTrack(0,i)  
      


      -- LOOP THROUGH ENVELOPES
      env_count = reaper.CountTrackEnvelopes(track)
      for j = 0, env_count-1 do

        -- GET THE ENVELOPE
        env = reaper.GetTrackEnvelope(track, j) 
 




AddPoints(env)             

end

end

end


addtrackwsp()
--------------------------------------------ADD_ENVELOPES_END----------------------




reaper.Main_OnCommandEx(40914, -1, 0)  --set track last touced


reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'),0 )


end


function selectrightwts()




timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)
if timeSelectionStart >= timeSelectionEnd then
    return
end

function UnselectAllTracks()
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  reaper.SetTrackSelected(first_track, false)
end



UnselectAllTracks()





-------------------------------------------ADD SELCETED ITEMS---------------------------

  -- LOOP THROUGH SELECTED ITEMS
  selected_items_count = reaper.CountSelectedMediaItems(0)
  
  -- INITIALIZE loop through selected items
  -- Select tracks with selected items

 
  for i = 0, selected_items_count - 1  do
    -- GET ITEMS
    item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i
    
    local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    
    

    -- GET ITEM PARENT TRACK AND SELECT Ióòâåðóò
    if itemStart < timeSelectionEnd and itemEnd > timeSelectionStart then    
    
    
     track = reaper.GetMediaItem_Track(item)
    reaper.SetTrackSelected(track, true)
    
    end
        
  end -- ENDLOOP through selected tracks





reaper.Main_OnCommandEx(40914, -1, 0)  --set track last touced


reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'),0 )


end








function JsDuplicate()

function noUndo()
end
reaper.defer(noUndo)

-- Is a usable time selection available?
timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)
if timeSelectionStart >= timeSelectionEnd then
    return
end

-- Are any tracks selected?
numSelTracks = reaper.CountSelectedTracks(0)
if numSelTracks == 0 then 
    return
end

-- Is SWS installed?
if not reaper.APIExists("ULT_SetMediaItemNote") then
    reaper.ShowMessageBox("This script requires the SWS/S&M extension.\n\nThe SWS/S&M extension can be downloaded from www.sws-extension.org.", "ERROR", 0)
    return false 
end

-- Checks done, so start undo block.
   


--reaper.SelectAllMediaItems(0, false)
for t = 0, numSelTracks-1 do -- numSelTracks has been defined above
    local track = reaper.GetSelectedTrack(0, t)
    for i = 0, reaper.GetTrackNumMediaItems(track)-1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if itemStart < timeSelectionEnd and itemEnd > timeSelectionStart then
            --reaper.SetMediaItemSelected(item, true)
        end
    end
    local newItem = reaper.AddMediaItemToTrack(track)
    reaper.SetMediaItemInfo_Value(newItem, "D_POSITION", timeSelectionStart)
    reaper.SetMediaItemInfo_Value(newItem, "D_LENGTH", timeSelectionEnd - timeSelectionStart)
    -- Will it look better if the items are given a distinctive color?
    --reaper.SetMediaItemInfo_Value(newItem, "I_CUSTOMCOLOR", reaper.ColorToNative(0,0,0)|0x01000000)
    -- Give temporary items a distinctive note, so that can be found later again.
    reaper.ULT_SetMediaItemNote(newItem, "Area select (temporary)")
    reaper.SetMediaItemSelected(newItem, true)
end


--------------------------------------------------------------------------
-- Use REAPER's native Actions to duplicate the item slices and automation
-- First, try to find state of "Option: Move envelope points with items" by checking toolbar button
local prevToggleState_MoveEnvPointWithItems = reaper.GetToggleCommandStateEx(0, 40070) -- 0 = Main section; 40070 = Options: Envelope points move with media items
reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_MVPWIDON"), -1, 0) -- SWS: Set move envelope points with items on
reaper.Main_OnCommandEx(40060, -1, 0) -- Item: Copy selected area of items
reaper.Main_OnCommandEx(40914, -1, 0) -- Track: Set first selected track as last touched track
reaper.Main_OnCommandEx(40058, -1, 0) -- Item: Paste items/tracks
-- Reset state of "Move envelope points with items"
if prevToggleState_MoveEnvPointWithItems == 0 then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_MVPWIDOFF"), -1, 0) -- SWS: Set move envelope points with items off
end

reaper.Main_OnCommand(40290, 0)---  set time selection to items



-------------------------
-- Delete temporary items
for t = 0, reaper.CountSelectedTracks(0)-1 do
    local track = reaper.GetSelectedTrack(0, t)
    local tItems = {}
    for i = 0, reaper.GetTrackNumMediaItems(track)-1 do
        local item = reaper.GetTrackMediaItem(track, i)
        if reaper.ULT_GetMediaItemNote(item) == "Area select (temporary)" then
            tItems[#tItems+1] = item
        end
    end
    for _, item in ipairs(tItems) do
        reaper.DeleteTrackMediaItem(track, item)
    end
end





end












reaper.DeleteExtState("me2beats_copy-paste", "take_envelopes",0)
local startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?
selected_items_count = reaper.CountSelectedMediaItems(0)




if focus == 0 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40062, 0)  
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate', -1)

elseif endOut == 0 and focus == 1 and (MoveWithMI_State == 1) then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40290, 0) ---set time selections to items

selectrightwts()

timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)

reaper.SetEditCurPos(timeSelectionEnd,1,0)

setpointselected()
JsDuplicate()

setpointselected()


--reaper.Main_OnCommand(41295, 0)  -- Duplicate items
reaper.Main_OnCommand(40930, 0) --trim

reaper.Main_OnCommand(40635, 0)  --remove time


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate', -1)  

elseif endOut > 0 and focus == 1 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


selectright()

timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)

reaper.SetEditCurPos(timeSelectionEnd,1,0)

setpointselected()
JsDuplicate()

setpointselected()
--reaper.Main_OnCommand(41296, 0)  --duplicate area of items



reaper.Main_OnCommand(40930, 0) --trim

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate', -1)  



elseif focus == 2 and selected_items_count > 0 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

timeSelectionStart, timeSelectionEnd = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)

reaper.SetEditCurPos(timeSelectionEnd,1,0)

setpointselected()
selectright()
JsDuplicate()
setpointselected()


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate', -1)

elseif endOut > 0  and focus == 1 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


reaper.Main_OnCommand(41296, 0) 

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate', -1)

elseif endOut > 0  and focus == 2 and selected_items_count == 0  then

DupEnv()


elseif endOut == 0 and focus == 1 and (MoveWithMI_State == 0) then

reaper.Main_OnCommand(41295, 0) --Duplicate

end

