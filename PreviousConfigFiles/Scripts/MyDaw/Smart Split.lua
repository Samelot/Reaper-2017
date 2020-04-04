startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"


local function noaction() r.defer(nothing) end


function justsplititems()

function getitems()


lastitem = reaper.GetExtState('MyDaw', 'Click On Bottom Half')
if not lastitem  or lastitem  == '' then noaction() return end

item =  reaper.BR_GetMediaItemByGUID( 0, lastitem )

if item then

reaper.SetMediaItemSelected(item, true)

end

reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SMARTSPLIT'), 0)

end

local items = reaper.CountSelectedMediaItems()
if items == 0 then getitems()
else
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SMARTSPLIT'), 0)

end
end


if endOut == 0 then 

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


justsplititems()

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Split', -1)  

else

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40061, 0) -- Split items at time selection

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Split', -1)  

end

