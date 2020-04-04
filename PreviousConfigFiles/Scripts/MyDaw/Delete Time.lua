

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
reaper.Main_OnCommand(40201, 0) ---Time selection: Remove contents of time selection (moving later items)
reaper.Main_OnCommand(40635, 0) ---remove time selection
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Delete Time', -1)

elseif endOut > 0 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40630, 0)   --Set cursor to start
reaper.Main_OnCommand(40296, 0) ---Select all tracks
reaper.Main_OnCommand(40717, 0) ---Select all items
reaper.Main_OnCommand(40201, 0) ---Time selection: Remove contents of time selection (moving later items)
reaper.Main_OnCommand(40635, 0) ---remove time selection
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Delete Time', -1)

end





