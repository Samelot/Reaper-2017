-----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



local midieditor =  reaper.MIDIEditor_GetActive()
    if not midieditor then return end
local function nothing() end
local function nonotes() 
reaper.defer(nothing) end

local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
if not take then nonotes() return end
local _,notes = reaper.MIDI_CountEvts(take)
local window, segment, details = reaper.BR_GetMouseCursorContext()
local _,_,noteRow = reaper.BR_GetMouseCursorContext_MIDI()

if noteRow == -1 then nonotes() return end

local mouse_time = reaper.BR_GetMouseCursorContext_Position()
local mouse_ppq_pos = reaper.MIDI_GetPPQPosFromProjTime(take, mouse_time)


reaper.Undo_BeginBlock() reaper.PreventUIRefresh(1)

for i = 0, notes - 1 do
  local _, sel, muted, start_note, end_note, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
  if start_note < mouse_ppq_pos and end_note > mouse_ppq_pos and noteRow == pitch then
    note = i
    break
  end
end

if not note then nonotes() return end
reaper.MIDIEditor_LastFocused_OnCommand(40214, 0)
reaper.MIDI_SetNote(take, note, 1, nil, nil, nil, nil, nil, nil)
reaper.MIDIEditor_OnCommand(midieditor, 40745)

reaper.PreventUIRefresh(-1) reaper.Undo_EndBlock('Select only note under mouse', -1)


    no_undo()
