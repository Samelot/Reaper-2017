function SelDuplicate()
midieditor = reaper.MIDIEditor_GetActive()
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.MIDIEditor_OnCommand(midieditor, 40746)  --Sel
reaper.MIDIEditor_OnCommand(midieditor, 40734) --Dup
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Duplicate', -1)
end

function Duplicate()
midieditor = reaper.MIDIEditor_GetActive()
reaper.MIDIEditor_OnCommand(midieditor, 40734)
end

  take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())                     
  if take == nil then return end                                                    
  retval,count_notes,ccs,sysex = reaper.MIDI_CountEvts(take)                            
  for i = 0,count_notes do                                                                
  local retval, sel, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take,i-1)
    if sel then 
    
 reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
    
    
    Duplicate() 
    
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1)  
    
    
    break                                           
    elseif count_notes == i then 
 reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)    
    
    SelDuplicate()                   
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Cut', -1)      
    end
  end

