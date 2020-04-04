InputToVKB = 40637
ShowVkb = 40377

InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)


function nothing() end
function exit() reaper.defer(nothing) end




function InputToVKBON()
if (InputToVKB_State == 0) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(InputToVKB, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 






reaper.PreventUIRefresh(1)  
InputToVKBON()
reaper.PreventUIRefresh(-1)
