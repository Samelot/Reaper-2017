local midieditor =  reaper.MIDIEditor_GetActive()
    if not midieditor then return end
    local take =  reaper.MIDIEditor_GetTake( midieditor )
    local item =  reaper.GetMediaItemTake_Item( take )
local startpos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
local leng = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
local cursorpos = reaper.GetCursorPosition()
local edge = cursorpos ~= startpos
local endpos = startpos + leng
local outedge = cursorpos >= startpos

function Time()



CursorToTime = 40276
CursorToTime_State = reaper.GetToggleCommandState(CursorToTime)
wason = 0
if (CursorToTime_State == 1) then
reaper.Main_OnCommand(CursorToTime, 0)
wason= 1
end









_, arrange_division, _, _ = reaper.GetSetProjectGrid(0, 0)
midieditor = reaper.MIDIEditor_GetActive()
reaper.PreventUIRefresh(1)
if midieditor then
  snap_enabled = reaper.MIDIEditor_GetSetting_int(midieditor, "snap_enabled")
  sel_start, sel_end = reaper.GetSet_LoopTimeRange(false,false,0,0,false)
  cursorpos = reaper.GetCursorPosition()
  if cursorpos == sel_start and cursorpos == sel_end then
    reaper.Main_OnCommand(40635, 0) 
    sel_start, sel_end = reaper.GetSet_LoopTimeRange(false,false,0,0,false)
  end
  
  if snap_enabled == 0 then
    reaper.MIDIEditor_OnCommand(midieditor, 1014)
  end
  if reaper.GetToggleCommandState(42010) == 0 then 
    reaper.MIDIEditor_OnCommand(midieditor, 41022) 
  end
  grid = reaper.BR_GetPrevGridDivision(cursorpos)
  if sel_start == 0 and sel_end == 0 then
    reaper.Main_OnCommand(40626, 0)  
  end
  reaper.SetEditCurPos(grid, 0, 0)
  if sel_start == 0 and sel_end == 0 then
    reaper.Main_OnCommand(40625, 0) 
  else
    if cursorpos >= (sel_start+sel_end)/2 then
      reaper.Main_OnCommand(40626, 0) 
    else
      reaper.Main_OnCommand(40625, 0) 
    end
  end
  
end
reaper.MIDIEditor_OnCommand(midieditor, 41022) 
reaper.SetProjectGrid(0, arrange_division)

  if (wason == 1) then
  reaper.Main_OnCommand(CursorToTime, 0)
  end





reaper.PreventUIRefresh(-1)
end

function LenNotes()
midieditor = reaper.MIDIEditor_GetActive()
reaper.MIDIEditor_OnCommand(midieditor, 40447)
end

  take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())                     
  if take == nil then return end                                                    
  retval,count_notes,ccs,sysex = reaper.MIDI_CountEvts(take)                            
  for i = 0,count_notes do                                                                
  local retval, sel, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take,i-1)
    if sel then LenNotes() break                                           
    elseif count_notes == i and edge and outedge then Time()                   
    end
  end

