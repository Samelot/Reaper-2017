focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?


if focus == 0 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40696, 0)  

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Rename', -1)

elseif  focus == 1 then

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_RENMTAKE'),0 ) 

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Rename', -1)
elseif  focus == 2 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(42091, 0) 

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Rename', -1)
end
