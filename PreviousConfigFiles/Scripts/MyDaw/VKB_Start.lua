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



InputToVKBOFF()
ShowVkbOFF()





InputToVKB = 40637
ShowVkb = 40377

InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)

t0 = os.clock()

function run()

t = os.clock()
InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)
  
  if (t - t0 < 0.5)  then reaper.defer(run) else 
  
InputToVKBON()

ShowVkbON()


movevp() 
  
  
end
end

run()
toggleState = 1

is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
reaper.SetToggleCommandState(sec, reaper.NamedCommandLookup('_RS7f81469b26a2a81175b678597677ce0961b1c4fe'), toggleState);  
reaper.RefreshToolbar2(sec, cmd); 

reaper.RefreshToolbar(reaper.NamedCommandLookup('_RS7f81469b26a2a81175b678597677ce0961b1c4fe'))

reaper.SetExtState( "MyDaw", "ShowItemEnvelopes", "true", false) 


reaper.SetToggleCommandState(sec, reaper.NamedCommandLookup('_RSe1639a15cdaa4f1a315ffb5a7a1e5c2c7741e4df'), 1);  
reaper.RefreshToolbar2(sec, cmd); 

reaper.RefreshToolbar(reaper.NamedCommandLookup('_RSe1639a15cdaa4f1a315ffb5a7a1e5c2c7741e4df'))
  

