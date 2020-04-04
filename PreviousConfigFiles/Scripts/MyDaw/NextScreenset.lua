function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
  
end





local is_vkb_on  = reaper.GetToggleCommandState(40377) 





function nothing() end
function exit() reaper.defer(nothing) end







function InputToVKBON()
if (InputToVKB_State == 0) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(InputToVKB, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 

function ShowVkbON()
if (ShowVkb_State == 0) then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(ShowVkb, 0)
reaper.PreventUIRefresh(-1) 
else exit() end 

end 



function movemix()
mix = reaper.JS_Window_Find("Mixer", true)

if mix then
	offset = 48
 rpr =  reaper.GetMainHwnd()
 retval, left, top, right, bottom = reaper.JS_Window_GetClientRect( rpr )
 mxx = (left-6)
 mxy = (top+offset )
 reaper.JS_Window_SetPosition( mix, mxx, mxy, (right-left)+14 , (bottom - top)-40 )
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)
end
end













local t = "MainClip"
local o = "last_window_set"
local e = 40454 local l = 40455 local a = 40456 local l = 0 
function StepWindowSet(n) 
local l = reaper.GetExtState(t, o);
if (l == ""
    or l == nil) then l = a
else l = tonumber(l) or a end local l = l + n;
if (l > a) then l = e end
if (l < e) then l = a end 



reaper.Main_OnCommand(l, 0) 
reaper.SetExtState(t, o, tostring(l), false);


if is_vkb_on ==1 then 



InputToVKB = 40637
ShowVkb = 40377

InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)



ShowVkbON()

InputToVKBON()


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
movevp()


end

if l==40456 then movemix() end

end local l = 1 StepWindowSet(l)
