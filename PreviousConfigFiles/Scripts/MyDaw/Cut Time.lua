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
    reaper.SelectAllMediaItems(0, false)
    for t = 0, numSelTracks-1 do -- numSelTracks has been defined above
        local track = reaper.GetSelectedTrack(0, t)
        for i = 0, reaper.GetTrackNumMediaItems(track)-1 do
            local item = reaper.GetTrackMediaItem(track, i)
            local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
            if itemStart < timeSelectionEnd and itemEnd > timeSelectionStart then
                reaper.SetMediaItemSelected(item, true)
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
reaper.Main_OnCommand(40718, 0)  -- select all items on selected tracks
reaper.Main_OnCommand(40307, 0) --- cut area of items
cycle()


end



function nothing() end
function noaction() reaper.defer(nothing) end





startOut1, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
selected_items_count = reaper.CountSelectedMediaItems(0)





if endOut == 0 and selected_items_count > 0 then


reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40290, 0) ---Set time selection on items
reaper.Main_OnCommand(40630, 0)   --Set cursor to start
reaper.Main_OnCommand(40296, 0) ---Select all tracks
JsDuplicate()
reaper.Main_OnCommand(40201, 0) ---Time selection: Remove contents of time selection (moving later items)
reaper.Main_OnCommand(40635, 0) ---remove time selection
reaper.Main_OnCommand(40769, 0)  ---Unselect all
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut Time', -1)



elseif endOut > 0 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40630, 0)   --Set cursor to start
reaper.Main_OnCommand(40296, 0) ---Select all tracks
JsDuplicate()
reaper.Main_OnCommand(40201, 0) ---Time selection: Remove contents of time selection (moving later items)
reaper.Main_OnCommand(40635, 0) ---remove time selection
reaper.Main_OnCommand(40769, 0)  ---Unselect all
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut Time', -1)


elseif    endOut == 0 and selected_items_count == 0  then 
noaction()




end





