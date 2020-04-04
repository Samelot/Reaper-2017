startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"


local function noaction() r.defer(nothing) end


function justinserttoitems()

function getitems()


lastitem = reaper.GetExtState('MyDaw', 'Click On Bottom Half')
if not lastitem  or lastitem  == '' then noaction() return end

item =  reaper.BR_GetMediaItemByGUID( 0, lastitem )


reaper.SetMediaItemSelected(item, true)

reaper.Main_OnCommand(41842, 0)   -----add strech

end

local items = reaper.CountSelectedMediaItems()
if items == 0 then getitems()
else
reaper.Main_OnCommand(41842, 0)   -----add strech

end
end


if endOut == 0 then 

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


justinserttoitems()

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Insert Marker', -1)  

else

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(41843, 0) ----add strech a time

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Insert Marker', -1)  

end

