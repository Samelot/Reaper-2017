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









startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
selected_items_count = reaper.CountSelectedMediaItems(0)
function nothing() end
function noaction() reaper.defer(nothing) end


if endOut == 0 and selected_items_count == 0  then noaction()

elseif  endOut == 0 and selected_items_count > 0 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40290, 0) ---Set time selection on items
reaper.Main_OnCommand(40630, 0)   --Set cursor to start
reaper.Main_OnCommand(40296, 0) ---Select all tracks
reaper.Main_OnCommand(40311, 0) ---Set ripple edit for all tracks
JsDuplicate()
reaper.Main_OnCommand(40309, 0)---Set ripple edit off

local pos_a, pos_b = reaper.GetSet_LoopTimeRange( false, false, 0, 0, false )

if not (pos_a and pos_b) then return end

pos_a = pos_b + (pos_b - pos_a)

reaper.GetSet_LoopTimeRange( true, false, pos_b, pos_a, false )

reaper.Main_OnCommand(40717, 0) ---Select all items in time
reaper.Main_OnCommand(40630, 0)  --- Goto start time selection

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate Time', -1)

elseif endOut > 0 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40630, 0)   --Set cursor to start
reaper.Main_OnCommand(40296, 0) ---Select all tracks
reaper.Main_OnCommand(40311, 0) ---Set ripple edit for all tracks
JsDuplicate()
reaper.Main_OnCommand(40309, 0)---Set ripple edit off

local pos_a, pos_b = reaper.GetSet_LoopTimeRange( false, false, 0, 0, false )

if not (pos_a and pos_b) then return end

pos_a = pos_b + (pos_b - pos_a)

reaper.GetSet_LoopTimeRange( true, false, pos_b, pos_a, false )

reaper.Main_OnCommand(40717, 0) ---Select all items in time
reaper.Main_OnCommand(40630, 0)  --- Goto start time selection

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate Time', -1)

end


