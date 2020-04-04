startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?




if endOut > 0  and focus == 2 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40324, 0)  --Copy points within time selection
reaper.Main_OnCommand(40631, 0)  ---Go to end time selection
reaper.Main_OnCommand(40058, 0)  ---Paste

timeSelectionStart1, timeSelectionEnd1 = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, true)
local cursorpos = reaper.GetCursorPosition()


reaper.GetSet_LoopTimeRange(1, 0, timeSelectionEnd1, cursorpos, 0)


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate Envelope', -1)

end
