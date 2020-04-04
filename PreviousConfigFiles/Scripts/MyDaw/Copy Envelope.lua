


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

startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
focus = reaper.GetCursorContext() --  Даем переменную значения где сейчас фокус?
selected_items_count = reaper.CountSelectedMediaItems(0)


if focus == 1 and selected_items_count > 0  then


TakeEnvelopeCopy()

elseif  endOut == 0 and focus == 2 and selected_items_count == 0  then

reaper.DeleteExtState("me2beats_copy-paste", "take_envelopes",0)
reaper.Main_OnCommand(40335, 0) ---copy selected poits


elseif  endOut > 0 and focus == 2 and selected_items_count == 0  then
reaper.DeleteExtState("me2beats_copy-paste", "take_envelopes",0)
reaper.Main_OnCommand(40324, 0) ---copy points within

end
