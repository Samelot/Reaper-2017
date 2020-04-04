InputToVKB = 40637
ShowVkb = 40377

InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)


function nothing() end
function exit() reaper.defer(nothing) end



function InputToVKBOFF()
if (InputToVKB_State == 1) then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(InputToVKB, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 


function ShowVkbOFF()
if (ShowVkb_State == 1) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(ShowVkb, 0)  
reaper.PreventUIRefresh(-1)
else exit() end 
end 




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





---------Make VKB OFF

if (ShowVkb_State == 1) then

reaper.PreventUIRefresh(1)
InputToVKBOFF()
ShowVkbOFF()
reaper.PreventUIRefresh(-1)
    
  
    
      toggleState = 0

---------Make Vkb ON
  
  elseif (ShowVkb_State == 0) then

reaper.PreventUIRefresh(1)  
InputToVKBON()
ShowVkbON()
movevp()
reaper.PreventUIRefresh(-1)
  
    toggleState = 1

end

is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
reaper.SetToggleCommandState(sec, cmd, toggleState);  
reaper.RefreshToolbar2(sec, cmd);  

