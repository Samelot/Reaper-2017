



function PasteTakeEnvelope()
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

part = r.GetExtState("me2beats_copy-paste", "take_envelopes")
if not (part and part ~= '') then bla() return end

r.Undo_BeginBlock(); r.PreventUIRefresh(111)
items = r.CountSelectedMediaItems(0)
for i = 0, items-1 do
item = r.GetSelectedMediaItem(0,i)
_, chunk = r.GetItemStateChunk(item, '', 0)
take = r.GetActiveTake(item)
take_guid = r.BR_GetMediaItemTakeGUID(take)
if chunk:match(esc(take_guid)..'\n<SOURCE.->\n<TAKEFX\n') then
  before, after = chunk:match('(.*'..esc(take_guid)..'\n<SOURCE.->\n<TAKEFX.-\nWAK %d\n>)(.*)')
else before, after = chunk:match('(.*'..esc(take_guid)..'\n<SOURCE.->\n)(.*)') end
tb = {}
for env_part in after:gmatch('<.-ENV\n.->') do
  if not env_part:match('<(.-)ENV\n.->'):match('\n') then tb[#tb+1] = env_part end
end
after_new = after
for k = 1, #tb do after_new = after_new:gsub(esc(tb[k]), '', 1) end
after_new = after_new:gsub('\n+', '\n')

new_chunk = before..'\n'..part..after_new
r.SetItemStateChunk(item, new_chunk, 1)
end
r.PreventUIRefresh(-111); r.UpdateArrange()
r.Undo_EndBlock("Paste copied envelopes to active takes of sel items", -1)

end






















reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


function setpointselected()


function SetAtTimeSelection(env, k, point_time, value, shape, tension)
  
  if time_selection == true then

    if point_time >= start_time and point_time <= end_time then
      reaper.SetEnvelopePoint(env, k, point_time, valueIn, shape, tension, true, true)
    else
      reaper.SetEnvelopePoint(env, k, point_time, valueIn, shape, tension, false, true)
    end
  
  else
    reaper.SetEnvelopePoint(env, k, point_time, valueIn, shape, tension, true, true)
  end
  
end

function Action(env)
  
  -- GET THE ENVELOPE
  retval, envelopeName = reaper.GetEnvelopeName(env, "envelopeName")
  br_env = reaper.BR_EnvAlloc(env, false)

  active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, type, faderScaling = reaper.BR_EnvGetProperties(br_env, true, true, true, true, 0, 0, 0, 0, 0, 0, true)

  -- IF ENVELOPE IS A CANDIDATE
  if visible == true then

    -- LOOP THROUGH POINTS
    env_points_count = reaper.CountEnvelopePoints(env)

    if env_points_count > 0 then
      for k = 0, env_points_count-1 do 
        retval, point_time, valueOut, shapeOutOptional, tensionOutOptional, selectedOutOptional = reaper.GetEnvelopePoint(env, k)
        
        -- START ACTION

        -- END ACTION
        
        SetAtTimeSelection(env, k, point_time, valueOut, shapeInOptional, tensionInOptional)

      end
    end
    
    reaper.BR_EnvFree(br_env, 0)
    reaper.Envelope_SortPoints(env)
  
  end

end

function main() -- local (i, j, item, take, track)



  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

  if start_time ~= end_time then
    time_selection = true
  end
    
  -- LOOP TRHOUGH SELECTED TRACKS
  env = reaper.GetSelectedEnvelope(0)

  if env == nil then

    selected_tracks_count = reaper.CountSelectedTracks(0)
    for i = 0, selected_tracks_count-1  do
      
      -- GET THE TRACK
      track = reaper.GetSelectedTrack(0, i) -- Get selected track i

      -- LOOP THROUGH ENVELOPES
      env_count = reaper.CountTrackEnvelopes(track)
      for j = 0, env_count-1 do

        -- GET THE ENVELOPE
        env = reaper.GetTrackEnvelope(track, j)

        Action(env)

      end -- ENDLOOP through envelopes

    end -- ENDLOOP through selected tracks

  else

    Action(env)
  
  end -- endif sel envelope



end -- end main()

--msg_start() -- Display characters in the console to show you the begining of the script execution.

--[[ reaper.PreventUIRefresh(1) ]]-- Prevent UI refreshing. Uncomment it only if the script works.

main() -- Execute your main function

--[[ reaper.PreventUIRefresh(-1) ]] -- Restore UI Refresh. Uncomment it only if the script works.

reaper.UpdateArrange() -- Update the arrangement (often needed)

end






function savetracks()

sel_tracks_str = ''
for i = 0, reaper.CountSelectedTracks()-1 do
  sel_tracks_str = sel_tracks_str..reaper.GetTrackGUID(reaper.GetSelectedTrack(0,i))
end

reaper.DeleteExtState('save-restore', 'sel_tracks', 0)
reaper.SetExtState('save-restore', 'sel_tracks', sel_tracks_str, 0)


end


function addrestoretracks()

local function nothing() end
local function donothing() reaper.defer(nothing) end

local sel_tracks_str = reaper.GetExtState('save-restore', 'sel_tracks')
if not sel_tracks_str or sel_tracks_str == '' then donothing() return end


for guid in sel_tracks_str:gmatch'{.-}' do
  local tr = reaper.BR_GetMediaTrackByGUID(0, guid)
  if tr then reaper.SetTrackSelected(tr,1) end
end

end


function savetracks1()

sel_tracks_str1 = ''
for i = 0, reaper.CountSelectedTracks()-1 do
  sel_tracks_str1 = sel_tracks_str1..reaper.GetTrackGUID(reaper.GetSelectedTrack(0,i))
end

reaper.DeleteExtState('save-restore1', 'sel_tracks1', 0)
reaper.SetExtState('save-restore1', 'sel_tracks1', sel_tracks_str1, 0)


end


function addrestoretracks1()

local function nothing() end
local function donothing() reaper.defer(nothing) end

local sel_tracks_str1 = reaper.GetExtState('save-restore1', 'sel_tracks1')
if not sel_tracks_str1 or sel_tracks_str1 == '' then donothing() return end


for guid1 in sel_tracks_str1:gmatch'{.-}' do
  local tr1 = reaper.BR_GetMediaTrackByGUID(0, guid1)
  if tr1 then reaper.SetTrackSelected(tr1,0) end
end

end







function deleteEmptyItems() 
    reaper.Main_OnCommand(40296, 0)
   
    
    
    reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)
    
    
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

part = reaper.GetExtState("me2beats_copy-paste", "take_envelopes")


if (part and part ~= '') then  PasteTakeEnvelope()



else



reaper.Main_OnCommand(40058, 0) -- paste


focus = reaper.GetCursorContext()

if focus == 1 or 2 then

deleteEmptyItems()

reaper.Main_OnCommand(40297, 0)---unselect all tracks

addrestoretracks()

addrestoretracks1()


reaper.Main_OnCommandEx(40914, -1, 0)

setpointselected()

reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)

reaper.Main_OnCommand(40290, 0) --set time
reaper.Main_OnCommand(40930, 0) --trim

else

reaper.Main_OnCommand(40058, 0)  ---paste


end

end 





reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Paste', -1)  

