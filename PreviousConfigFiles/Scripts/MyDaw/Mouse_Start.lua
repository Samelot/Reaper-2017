reaper.PreventUIRefresh(1)
  reaper.Main_OnCommand(39490, 0)
  reaper.Main_OnCommand(39289, 0)
  reaper.Main_OnCommand(39162, 0)
  reaper.Main_OnCommand(39129, 0)
  reaper.Main_OnCommand(39364, 0)
  reaper.SetMouseModifier( 'MM_CTX_MIDI_NOTE_CLK', 0, "_RS7d3c_2c6a0ebe4c435cf904ffff40f14c8861b32a12e0" )
reaper.Main_OnCommand(39705, 0) 
  reaper.TrackList_AdjustWindows(0)
  reaper.PreventUIRefresh(-1)
    toggleState = 0
is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
reaper.SetToggleCommandState(sec, reaper.NamedCommandLookup('_RSca86956568b59f475ae821d865f662de8ede6589'), toggleState);  
reaper.RefreshToolbar2(sec, cmd); 

reaper.RefreshToolbar(reaper.NamedCommandLookup('_RSca86956568b59f475ae821d865f662de8ede6589'))




