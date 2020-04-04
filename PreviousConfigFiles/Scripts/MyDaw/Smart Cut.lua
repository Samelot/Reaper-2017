


function DeleteAllEnvelopePointsOnSelectedTracks()--------------------------DeleteAllEnvelopePointsOnSelectedTracks()  START


time = {}
valueSource = {}
shape = {}
tension = {}
selectedOut = {}

function main() -- local (i, j, item, take, track)

  -- GET LOOP
  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  -- IF LOOP ?
  if start_time ~= end_time then
    time_selection = true
  end

  -- LOOP TRHOUGH SELECTED TRACKS
  selected_tracks_count = reaper.CountSelectedTracks(0)
  for j = 0, selected_tracks_count-1  do
    
    -- GET THE TRACK
    track = reaper.GetSelectedTrack(0, j) -- Get selected track i

    env_count = reaper.CountTrackEnvelopes(track)
    
    for m = 0, env_count-1 do

      -- GET THE ENVELOPE
      env = reaper.GetTrackEnvelope(track, m)
      --retval, env_name_dest = reaper.GetEnvelopeName(env, "")

      -- IF VISIBLE AND ARMED
      br_env = reaper.BR_EnvAlloc(env, false)
      active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
      
      if visible == true then

        
        
        -- GET LAST POINT TIME OF DEST TRACKS AND DELETE ALL
        env_points_count = reaper.CountEnvelopePoints(env)

        -- LOOP POINTS AND INSERT
        for p = 0, env_points_count-1 do
          
          retval, time, valueSource, shape, tension, selectedOut = reaper.GetEnvelopePoint(env, env_points_count-1-p)
          --position, value, shape, selected, bezier = reaper.BR_EnvGetPoint(br_env, p, 0, 0, 0, true, 0)
          
          -- TAKE SELECTED
          if selectedOut == true then
            --reaper.ShowConsoleMsg(tostring(env_points_count-1-p))
            reaper.BR_EnvDeletePoint(br_env, (env_points_count-1-p))
          end
        end -- END LOOP THROUGH SAVED POINTS

        -- PRESERVE EDGES INSERTION
        if time_selection == true and preserve_edges == true then
          
          reaper.DeleteEnvelopePointRange(env, start_time-0.000000001, start_time+0.000000001)
          reaper.DeleteEnvelopePointRange(env, end_time-0.000000001, end_time+0.000000001)
          
          reaper.InsertEnvelopePoint(env, start_time, valueOut3, 0, 0, true, true) -- INSERT startLoop point
          reaper.InsertEnvelopePoint(env, end_time, valueOut4, 0, 0, true, true) -- INSERT startLoop point
        
        end

        reaper.BR_EnvFree(br_env, 1)
        reaper.Envelope_SortPoints(env)

      end -- ENDIF envelope passed

    end -- ENDLOOP selected tracks envelope
  
  end -- ENDLOOP selected tracks

end -- end main()



reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
main() -- Execute your main function
reaper.Undo_EndBlock("Delete selected points on selected tracks visible armed envelope", 0) -- End of the undo block. Leave it at the bottom of your main function.

reaper.UpdateArrange() -- Update the arrangement (often needed)


end------------------------------------DeleteAllEnvelopePointsOnSelectedTracks()  END









function selectrightEnv() -----------------------------selectrightEnv()--START





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


end---------------------------------------------------------------------selectrightEnv()--END






function selectrightwts()---------------------------------------selectrightwts()   START






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










reaper.Main_OnCommandEx(40914, -1, 0)  --set track last touced


reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'),0 )


end--------------------------------------------------------------------------selectrightwts()   END











function DeleteEnvelopesOfItems()--------------------------------DeleteEnvelopesOfItems()  START



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
    
    
    
     track = reaper.GetMediaItem_Track(item)
   --Here we select envelope points
   
   env_count = reaper.CountTrackEnvelopes(track)
   
   for m = 0, env_count-1 do
   
        -- GET THE ENVELOPE
        env = reaper.GetTrackEnvelope(track, m)
        
        br_env = reaper.BR_EnvAlloc(env, false)
              active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
              
              if visible == true  then
        
                
                
                -- GET LAST POINT TIME OF DEST TRACKS AND DELETE ALL
                env_points_count = reaper.CountEnvelopePoints(env)
        
        reaper.DeleteEnvelopePointRange(env, itemStart-0.05, itemEnd+0.05)
     
               
                end -- END LOOP THROUGH SAVED POINTS
   
   

end
end
reaper.UpdateArrange()
end -------------------------------------------------------------------------------DeleteEnvelopesOfItems()  END





function DeleteEnv()------------------------------------DeleteEnv()-----START


-- INIT
time = {}
valueSource = {}
shape = {}
tension = {}
selectedOut = {}

function main() -- local (i, j, item, take, track)

  -- GET LOOP
  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  -- IF LOOP ?
  if start_time ~= end_time then
    time_selection = true
  end

  -- LOOP TRHOUGH SELECTED TRACKS
  selected_tracks_count = reaper.CountSelectedTracks(0)
  for j = 0, selected_tracks_count-1  do
    
    -- GET THE TRACK
    track = reaper.GetSelectedTrack(0, j) -- Get selected track i

    env_count = reaper.CountTrackEnvelopes(track)
    
    for m = 0, env_count-1 do

      -- GET THE ENVELOPE
      env = reaper.GetTrackEnvelope(track, m)
      --retval, env_name_dest = reaper.GetEnvelopeName(env, "")

      -- IF VISIBLE AND ARMED
      br_env = reaper.BR_EnvAlloc(env, false)
      active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)
      
      if visible == true  then

        
        
        -- GET LAST POINT TIME OF DEST TRACKS AND DELETE ALL
        env_points_count = reaper.CountEnvelopePoints(env)

        -- LOOP POINTS AND INSERT
        for p = 0, env_points_count-1 do
          
          retval, time, valueSource, shape, tension, selectedOut = reaper.GetEnvelopePoint(env, env_points_count-1-p)
          --position, value, shape, selected, bezier = reaper.BR_EnvGetPoint(br_env, p, 0, 0, 0, true, 0)
          
          -- TAKE SELECTED
          if selectedOut == true then
            --reaper.ShowConsoleMsg(tostring(env_points_count-1-p))
            reaper.BR_EnvDeletePoint(br_env, (env_points_count-1-p))
          end
        end -- END LOOP THROUGH SAVED POINTS


        reaper.BR_EnvFree(br_env, 1)
        reaper.Envelope_SortPoints(env)

      end -- ENDIF envelope passed

    end -- ENDLOOP selected tracks envelope
  
  end -- ENDLOOP selected tracks

end -- end main()

--msg_start() -- Display characters in the console to show you the begining of the script execution.

reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
main() -- Execute your main function
reaper.Undo_EndBlock("Delete selected points on selected tracks visible armed envelope", 0) -- End of the undo block. Leave it at the bottom of your main function.

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

  

end -- end main()




main() -- Execute your main function



reaper.UpdateArrange() -- Update the arrangement (often needed)
end


end----------------------------------------------------------------------DeleteEnv()-----END




function setpointselected()--------------------------------setpointselected() START


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

end------------------------------------------------------------------------------------setpointselected() END



function selectright()----------------------------------------------selectright() START





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


end-------------------------------------------------------------------------------------------selectright() END





function selectrightwts()--------------------------------selectrightwts() START






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


end----------------------------------------------------------------selectrightwts() END






function JsDuplicate()

function cycle()
-----------------------------------------------------------------------------------------------
-- This script manages to duplicate envelope points even when no items are above these points,
--    by inserting temporary empty item across the time selection in all selected tracks.
-- Then, if "Option: Move envelope points with items" is active, REAPER's native item-duplication
--    Actions such as "Item: Copy selected area of items" will copy all envelope points in time selection.
-- This loop also selects all items that overlap time selection, since the Action
--    "Item: Copy selected area of items" only works on selected items.
function insertEmptyItems()
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
        reaper.ULT_SetMediaItemNote(newItem, "AREA SELECT           ")
        reaper.SetMediaItemSelected(newItem, true)
    end
end


---------------------------
function deleteEmptyItems() 
    for t = 0, reaper.CountTracks(0)-1 do
        local track = reaper.GetTrack(0, t)
        local tItems = {}
        for i = 0, reaper.GetTrackNumMediaItems(track)-1 do
            local item = reaper.GetTrackMediaItem(track, i)
            if reaper.ULT_GetMediaItemNote(item) == "AREA SELECT           " then
                tItems[#tItems+1] = item
            end
        end
        for _, item in ipairs(tItems) do
            reaper.DeleteTrackMediaItem(track, item)
        end
    end
end


---------------------------------------------------
---------------------------------------------------
-- Check cycle and either add or remove empty items
if reaper.GetExtState("js_Area copy", "Cycle") == "Has inserted" then

    reaper.Undo_BeginBlock2(0)
    reaper.PreventUIRefresh(1)  
    deleteEmptyItems()
    reaper.SetExtState("js_Area copy", "Cycle", "Has deleted", true)
    undoString = "Delete temporary empty items"

else -- reaper.GetExtState("js_Area copy", "Cycle") == "Has deleted"

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
    -- Checks done, so start undo block.
    reaper.Undo_BeginBlock2(0)
    reaper.PreventUIRefresh(1)  
    insertEmptyItems()
    reaper.SetExtState("js_Area copy", "Cycle", "Has inserted", true)
    undoString = "Insert temporary empty items"
end

reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock2(0, undoString, -1)


end

cycle()

reaper.Main_OnCommand(41383, 0)  ---copy


cycle()


end


reaper.DeleteExtState("me2beats_copy-paste", "take_envelopes",0)
startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?
selected_items_count = reaper.CountSelectedMediaItems(0)

if focus == 0 then


reaper.Main_OnCommand(41384, 0)  ---cut

elseif endOut > 0 and focus == 1 and selected_items_count > 0   then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


selectright()
setpointselected()

JsDuplicate()


MoveWithMI = 40070

MoveWithMI_State = reaper.GetToggleCommandState(MoveWithMI)

if (MoveWithMI_State == 1) then

DeleteEnvelopesOfItems()

end







reaper.Main_OnCommand(40697, 0) ----Delete items

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1)   


elseif endOut == 0 and focus == 1 and selected_items_count > 0 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40290, 0) ----- set time selections ti items

selectrightwts()

JsDuplicate()

MoveWithMI = 40070

MoveWithMI_State = reaper.GetToggleCommandState(MoveWithMI)

if (MoveWithMI_State == 1) then

DeleteEnvelopesOfItems()

end

reaper.Main_OnCommand(40697, 0) ----Delete items


reaper.Main_OnCommand(40635, 0)  ---remove time selections from items



reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1) 



elseif endOut > 0 and focus == 2 and selected_items_count > 0 then 

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

selectright()
setpointselected()

JsDuplicate()

DeleteEnv()  ---delete all envelopes in time

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1) 

elseif endOut > 0 and focus == 2 and selected_items_count == 0 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40325, 0)  ---cut points with time

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1) 


elseif endOut == 0 and focus == 2 and selected_items_count > 0 then

MoveWithMI = 40070

MoveWithMI_State = reaper.GetToggleCommandState(MoveWithMI)

if (MoveWithMI_State == 1) then



reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_SAVE_CURSOR_POS_SLOT_1'),0 )

reaper.Main_OnCommand(40290, 0)  ---set time selections to items
selectright()
setpointselected()

JsDuplicate()

DeleteAllEnvelopePointsOnSelectedTracks()

reaper.Main_OnCommand(40635, 0)  ---remove time selections to items

reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_RESTORE_CURSOR_POS_SLOT_1'),0 )

reaper.Main_OnCommand(40006, 0) ------remove items


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1) 

elseif (MoveWithMI_State == 0) then



reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_SAVE_CURSOR_POS_SLOT_1'),0 )

reaper.Main_OnCommand(40290, 0)  ---set time selections to items
selectright()
setpointselected()

JsDuplicate()

reaper.Main_OnCommand(40635, 0)  ---remove time selections to items

reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_RESTORE_CURSOR_POS_SLOT_1'),0 )

reaper.Main_OnCommand(40006, 0) ------remove items
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1) 


end




end







