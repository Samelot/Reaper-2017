function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end

pen1 = reaper.GetToggleCommandState(39291)


---------Make Mouse ON
if (pen1 == 1) then
reaper.JS_Mouse_SetCursor(reaper.JS_Mouse_LoadCursor(32512))
  reaper.Main_OnCommand(39490, 0)
  reaper.Main_OnCommand(39289, 0)
  reaper.Main_OnCommand(39161, 0)
  reaper.Main_OnCommand(39129, 0)
  reaper.Main_OnCommand(39364, 0)
  reaper.SetMouseModifier( 'MM_CTX_MIDI_NOTE_CLK', 0, "_RS7d3c_2c6a0ebe4c435cf904ffff40f14c8861b32a12e0" )
  reaper.Main_OnCommand(39705, 0) 
  reaper.TrackList_AdjustWindows(0)

    toggleState = 0
---------Make Pen ON
  elseif (pen1 == 0) then
local info = debug.getinfo(1,'S');



cur = reaper.GetResourcePath()..'/Cursors/midi_paint.cur'

curhandle = reaper.JS_Mouse_LoadCursorFromFile(cur)

reaper.JS_Mouse_SetCursor(curhandle)
   reaper.Main_OnCommand(39502, 0)
   reaper.Main_OnCommand(39291, 0)
   reaper.Main_OnCommand(39678, 0)
   reaper.Main_OnCommand(39708, 0)
   reaper.Main_OnCommand(39170, 0)
   reaper.Main_OnCommand(39141, 0)
   reaper.Main_OnCommand(39354, 0)
  reaper.TrackList_AdjustWindows(0)

    
    toggleState = 1
  end


is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
reaper.SetToggleCommandState(sec, cmd, toggleState);  
reaper.RefreshToolbar2(sec, cmd);  

