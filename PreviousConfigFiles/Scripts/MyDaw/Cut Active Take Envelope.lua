

function TakeEnvelopeCopy()
local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end
function esc (str)
str = str:gsub('%(', '%%(')
str = str:gsub('%)', '%%)')
str = str:gsub('%.', '%%.')
str = str:gsub('%+', '%%+')
str = str:gsub('%-', '%%-')
str = str:gsub('%$', '%%$')
str = str:gsub('%[', '%%[')
str = str:gsub('%]', '%%]')
str = str:gsub('%*', '%%*')
str = str:gsub('%?', '%%?')
str = str:gsub('%^', '%%^')
str = str:gsub('/', '%%/')
return str end

local r = reaper
local item = r.GetSelectedMediaItem(0,0)
if not item then return end
local _, chunk = r.GetItemStateChunk(item, '', 0)

local take = r.GetActiveTake(item)
if not take then return end

local take_guid = r.BR_GetMediaItemTakeGUID(take)

local part = chunk:match(esc(take_guid)..'\n<SOURCE.->\n(.->)\nTAKE') or
chunk:match(esc(take_guid)..'\n<SOURCE.->\n(.->)\n>')

if not part then return end
if not part:match('^<.-ENV\n') then return end

r.DeleteExtState("me2beats_copy-paste", "take_envelopes",0)
r.SetExtState("me2beats_copy-paste", "take_envelopes", part, 0)

end


function TakeEnvelopeDelete()


selItemCount = reaper.CountSelectedMediaItems(pProj)
i = 0
while i < selItemCount do
    pItem = reaper.GetSelectedMediaItem(pProj, i)
    pTake = reaper.GetMediaItemTake(pItem, 0)
    
    itemchunk = "";
    envchunk = ""
    result, itemchunk = reaper.GetItemStateChunk(pItem, itemchunk, 1)
        
    envCount = reaper.CountTakeEnvelopes(pTake)
    e = 0
    while e < envCount do
        pEnv = reaper.GetTakeEnvelope(pTake, e)          

        result, envchunk = reaper.GetEnvelopeStateChunk(pEnv, envchunk, 1)
        
        x, y = string.find(itemchunk, envchunk, 0, 0)
        
        if x and y then
            itemchunk = string.sub(itemchunk, 0, x - 1) .. string.sub(itemchunk, y , 0)
        end
        
        --reaper.ShowConsoleMsg(itemchunk)
            
        e = e + 1
    end
    
    reaper.SetItemStateChunk(pItem, itemchunk, 1);
        
    reaper.UpdateItemInProject(pItem)
    
    i = i + 1
end


reaper.UpdateArrange()
reaper.UpdateTimeline()

reaper.PreventUIRefresh(-1)

end

startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?

if focus == 1 then

reaper.PreventUIRefresh(1)

reaper.Undo_BeginBlock()

TakeEnvelopeDelete()
TakeEnvelopeCopy()

reaper.Undo_EndBlock("Cut Active Take Envelopes", -1)

reaper.PreventUIRefresh(1)

reaper.Undo_BeginBlock()


elseif focus == 2 then

reaper.Undo_EndBlock("Cut Envelope Points", -1)

reaper.Main_OnCommand(40336, 0)  ----cut points no ts

elseif focus == 2 and endOut > 0 then 

reaper.PreventUIRefresh(1)

reaper.Undo_BeginBlock()


reaper.Main_OnCommand(40325, 0)  ---cut with TS


reaper.Undo_EndBlock("Cut Envelope", -1)


end

