startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?

if focus == 0 then 

reaper.Main_OnCommand(40035, 0) ---Select all depend on focus



elseif focus == 1 then 

reaper.Main_OnCommand(40296, 0)  ---Select all tracks
reaper.Main_OnCommand(40182, 0) ----Select all items
reaper.Main_OnCommand(41173, 0) 


elseif focus == 2 then 

reaper.Main_OnCommand(40035, 0) ---Select all depend on focus
reaper.Main_OnCommand(41173, 0) 


end
