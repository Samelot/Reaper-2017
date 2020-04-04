function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end



function writeini(section, key, path)
inipath = reaper.get_ini_file()
reaper.BR_Win32_WritePrivateProfileString(section, key, path, inipath )
reaper.TrackList_AdjustWindows(true)
reaper.UpdateArrange()
end


function readini()
inipath = reaper.get_ini_file()
one, note  = reaper.BR_Win32_GetPrivateProfileString( "vkb", "notecenter", '0', inipath )
return note
end


function movevp()
vp = reaper.JS_Window_Find("Virtual MIDI keyboard", true)
if vp then
rpr = reaper.JS_Window_GetParent( vp )
retval, left, top, right, bottom = reaper.JS_Window_GetClientRect( rpr )
vkbx = (right-50)
vkby = (top)
reaper.JS_Window_SetPosition( vp, vkbx, vkby, 110, 28 )
reaper.JS_Window_SetOpacity(vp, "ALPHA", 0)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)

end
end


notecenter = tonumber(readini())
if ( notecenter < 96 and notecenter ~= 96 ) then 
octavedown =  notecenter +12
writeini("vkb", "notecenter", octavedown)

InputToVKB = 40637
ShowVkb = 40377

InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)


if ShowVkb_State == 1 then
reaper.PreventUIRefresh(1)

vp = reaper.JS_Window_Find("Virtual MIDI keyboard", true)
reaper.JS_WindowMessage_Send(vp, "WM_COMMAND", 2, 0, 0, 0)


reaper.Main_OnCommand(ShowVkb, 0)

if InputToVKB == 0 then
reaper.Main_OnCommand(InputToVKB, 0)
end

else

reaper.Main_OnCommand(ShowVkb, 0)

if InputToVKB == 0 then
reaper.Main_OnCommand(InputToVKB, 0)
end


end

vpshow = reaper.JS_Window_Find("Virtual MIDI keyboard", true)
function run()
  vpshow = reaper.JS_Window_Find("Virtual MIDI keyboard", true)
  if vpshow == true then reaper.defer(run) else  movevp()   end
end

run()



reaper.PreventUIRefresh(-1)

end






